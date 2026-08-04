<?php
// app/Http/Controllers/LedgerEntryController.php
//the edit proof in ledger entry is in line 100


namespace App\Http\Controllers\CSG;

use App\Http\Controllers\Controller;
use App\Models\AuditLog;
use App\Models\CSG\LedgerEntry;
use App\Models\CSG\Project;
use App\Models\CSG\Approval;
use App\Models\User;
use Illuminate\Http\Request;
// use Illuminate\Support\Facades\Storage;
use Illuminate\Support\Facades\Log;
use Illuminate\Support\Facades\Auth;
use Illuminate\Support\Str;
use Illuminate\Validation\ValidationException;

class LedgerEntryController extends Controller
{
    /**
     * Get ledger entries for a specific project
     */

/**
 * Handles the uploading of transaction proofs (receipts/images).
 * Implements Immutable Ledger design by hashing the file content.
 */
public function uploadProof(Request $request, $id)
{
    try {
        // 1. Find the specific ledger entry
        $entry = LedgerEntry::findOrFail($id);

        // 2. Validate the file presence and type
        if (!$request->hasFile('proof_file')) {
            return response()->json(['success' => false, 'message' => 'No file was uploaded.'], 400);
        }

        $file = $request->file('proof_file');

        // 3. SECURE HASHING (Core Capstone Feature)
        // We generate a unique SHA-256 hash based on the file's content.
        // This ensures transparency: if the file is changed, the hash won't match.
        $fileHash = hash_file('sha256', $file->getRealPath());
        $extension = $file->getClientOriginalExtension();
        $fileName = $fileHash . '.' . $extension;

        // 4. STORAGE (Local Folder)
        // Automatically creates 'storage/app/public/ledger_proofs' if it doesn't exist
        $path = $file->storeAs('ledger_proofs', $fileName, 'public');

        // 5. UPDATE DATABASE
        // Store the web-accessible path and the content hash for auditing
        $entry->update([
            'ledger_proof' => 'storage/ledger_proofs/' . $fileName,
            'file_content_hash' => $fileHash, // Ensure this column exists in your table
            'updated_at' => now()
        ]);

        // 6. JSON RESPONSE (Fixes the ERR_EMPTY_RESPONSE)
        return response()->json([
            'success' => true,
            'message' => 'Proof uploaded and verified successfully!',
            'data' => [
                'path' => asset('storage/ledger_proofs/' . $fileName),
                'hash' => $fileHash
            ]
        ], 200);

    } catch (\Illuminate\Database\Eloquent\ModelNotFoundException $e) {
        return response()->json(['success' => false, 'message' => 'Ledger entry not found.'], 404);
    } catch (\Exception $e) {
        // Catch-all for server errors (folder permissions, etc.)
        return response()->json(['success' => false, 'message' => 'Server Error: ' . $e->getMessage()], 500);
    }
}


    public function index($projectId)
    {
        try {
            $entries = LedgerEntry::where('project_id', $projectId)
                ->where('archive', 0)
                ->orderBy('created_at', 'desc')
                ->get();
            
            // Get the project to include initial budget breakdown
            $project = Project::find($projectId);
            
            // Map entries and add project budget breakdown for the initial entry
            $mappedEntries = $entries->map(function($entry) use ($project) {
                $entryData = $entry->toArray();
                
                // Include the ledger entry's budget breakdown
                $entryData['budget_breakdown'] = $entry->budget_breakdown 
                    ? (is_string($entry->budget_breakdown) ? json_decode($entry->budget_breakdown, true) : $entry->budget_breakdown)
                    : [];
                
                // Transform approved_by from ID to user name
                if ($entryData['approved_by']) {
                    $entryData['approved_by'] = $this->getUserName($entryData['approved_by']);
                }
                 if ($entryData['created_by']) {
        $entryData['created_by'] = $this->getUserName($entryData['created_by']);
    }
    if ($entryData['updated_by']) {
        $entryData['updated_by'] = $this->getUserName($entryData['updated_by']);
    }

                $entryData['ledger_proof'] = $entry->resolveLedgerProof();
                $entryData['note'] = $entry->getDisplayNote();
                
                return $entryData;
            });
            
            return response()->json($mappedEntries);
        } catch (\Exception $e) {
            return response()->json([
                'message' => 'Failed to fetch ledger entries',
                'error' => $e->getMessage()
            ], 500);
        }
    }

    /**
     * Get all ledger entries (optionally filtered by project)
     */
    public function all(Request $request)
    {
        try {
            $query = LedgerEntry::where('archive', 0);

            if ($request->filled('project_id')) {
                $query->where('project_id', $request->input('project_id'));
            }

            // Only return entries for projects that exist and are not archived
            $entries = $query->with('project')
                ->whereHas('project', function ($q) {
                    $q->where('archive', 0);  // Only show entries from non-archived projects
                })
                ->orderBy('created_at', 'desc')
                ->get();

            // Match ProjectDetails ledger-tab logic:
            // compute verification per project, then mark specific ledger IDs as tampered
            $projectVerifications = [];
            $uniqueProjectIds = $entries->pluck('project_id')->filter()->unique();
            foreach ($uniqueProjectIds as $projectId) {
                $projectVerifications[$projectId] = \App\Support\BlockchainService::verifyChain($projectId);
            }

            // Process budget breakdown for each entry
            $processedEntries = $entries->map(function($entry) use ($projectVerifications) {
                $entryData = $entry->toArray();

                // Use the ledger entry's own budget breakdown
                $entryData['budget_breakdown'] = $entry->budget_breakdown
                    ? (is_string($entry->budget_breakdown) ? json_decode($entry->budget_breakdown, true) : $entry->budget_breakdown)
                    : [];

                // Add project name for easier display
                $entryData['project_name'] = $entry->project ? $entry->project->title : 'Unknown Project';

                $verification = $projectVerifications[$entry->project_id] ?? ['isValid' => false, 'status' => 'no_chain', 'tamperedBlocks' => []];
                $isTampered = collect($verification['tamperedBlocks'] ?? [])->contains(function ($tamperedBlock) use ($entry) {
                    return ($tamperedBlock['ledgerId'] ?? null) === $entry->id;
                });

                $verificationState = [
                    'submitted' => optional($entry->created_at)->format('Y-m-d h:i A') ?? '',
                    'blockchainStatus' => $verification['status'] ?? 'no_chain',
                    'blockchainValid' => ! $isTampered && ($verification['isValid'] ?? false),
                    'tampered' => $isTampered,
                ];

                if ($entry->approved_at) {
                    $verificationState['reviewed'] = $entry->approved_at->format('Y-m-d h:i A');
                    $verificationState['approvedRejected'] = $entry->approved_at->format('Y-m-d h:i A');
                } elseif ($entry->rejected_at) {
                    $verificationState['reviewed'] = $entry->rejected_at->format('Y-m-d h:i A');
                    $verificationState['approvedRejected'] = $entry->rejected_at->format('Y-m-d h:i A');
                }

                $entryData['verificationState'] = $verificationState;
                
                // Transform approved_by from ID to user name
                if ($entryData['approved_by']) {
                    $entryData['approved_by'] = $this->getUserName($entryData['approved_by']);
                }

                $entryData['ledger_proof'] = $entry->resolveLedgerProof();
                $entryData['note'] = $entry->getDisplayNote();

                return $entryData;
            });

            return response()->json($processedEntries);
        } catch (\Exception $e) {
            return response()->json([
                'message' => 'Failed to fetch ledger entries',
                'error' => $e->getMessage(),
            ], 500);
        }
    }

    /**
     * Store a new ledger entry with optional file upload
     */
    public function store(Request $request)
    {
        try {
            // Validate the request
            $validated = $request->validate([
                'project_id' => 'required|exists:projects,id',
                'type' => 'required|in:Income,Expense,Canvas,Donation,Sponsorship',
                'description' => 'required|string|max:1000',
                'amount' => 'required|numeric|min:0',
                'budget_breakdown' => 'nullable|json',
                'proof_file' => 'nullable|file|mimes:pdf,jpg,jpeg,png|max:10240',
                'ledger_proof' => 'nullable|file|mimes:pdf,jpg,jpeg,png|max:10240',
                'approval_status' => 'nullable|string',
                'created_by' => 'nullable|exists:users,id',
            ]);
            
            // Create new ledger entry
            $entry = new LedgerEntry();
            $entry->id = Str::uuid()->toString();
            $entry->project_id = $request->project_id;
            $entry->type = $request->type;
            $entry->amount = $request->amount;
            $entry->description = $request->description;
            $entry->approval_status = $request->approval_status ?? 'Draft';
            $entry->created_by = Auth::id();
            
            // Handle budget breakdown (store as JSON)
            if ($request->has('budget_breakdown')) {
                $entry->budget_breakdown = $request->budget_breakdown;
            }
            
            // Handle file upload with SHA-256 hashing for immutability
            if ($request->hasFile('proof_file') || $request->hasFile('ledger_proof')) {
                $file = $request->file('proof_file') ?? $request->file('ledger_proof');
                
                // Generate SHA-256 hash of file content for immutability
                $fileHash = hash_file('sha256', $file->getRealPath());
                $extension = $file->getClientOriginalExtension();
                $fileName = $fileHash . '.' . $extension;
                
                // Store file with hash-based name to prevent duplicates in ledger_proofs folder
                $filePath = $file->storeAs('ledger_proofs', $fileName, 'public');
                
                if ($filePath) {
                    $entry->ledger_proof = 'storage/ledger_proofs/' . $fileName;
                    $entry->file_content_hash = $fileHash;
                    Log::info('File stored: ' . $filePath . ' with hash: ' . $fileHash);
                }
            }
            
            $entry->created_at = now();
            $entry->updated_at = now();
            
            $entry->save();
            
            Log::info('Ledger entry created with ID: ' . $entry->id);

            AuditLog::create([
                'id' => (string) Str::uuid(),
                'user_id' => Auth::id(),
                'actionable_id' => $entry->id,
                'actionable_type' => 'ledger_entry',
                'action' => 'Ledger Entry Created',
                'module' => 'ledger',
                'action_type' => 'create',
                'status' => 'Success',
                'details' => 'Created ' . $entry->type . ' ledger entry for project ID ' . $entry->project_id,
                'ip_address' => $request->ip(),
                'browser_info' => substr((string) $request->userAgent(), 0, 500),
                'archive' => 0,
            ]);
            
            // Return simple response - extremely minimal to avoid issues
            return response()->json([
                'success' => true,
                'message' => 'Ledger entry created successfully!',
                'id' => $entry->id,
            ], 201);
            
        } catch (ValidationException $e) {
            Log::warning('Ledger entry validation failed: ' . json_encode($e->errors()));
            return response()->json([
                'success' => false,
                'message' => 'Validation failed',
                'errors' => $e->errors(),
            ], 422);
        } catch (\Exception $e) {
            Log::error('Ledger entry creation failed: ' . $e->getMessage() . ' | Trace: ' . $e->getTraceAsString());
            return response()->json([
                'success' => false,
                'message' => 'Failed to create ledger entry',
                'error' => $e->getMessage()
            ], 500);
        }
    }

    /**
     * Update an existing ledger entry
     */
    // public function update(Request $request, $id)
    // {
    //     try {
    //         $entry = LedgerEntry::findOrFail($id);

    //         if ($entry->type === 'Initial') {
    //             return response()->json([
    //                 'message' => 'Initial baseline entries cannot be edited.',
    //             ], 403);
    //         }
            
    //         // Validate the request
    //         $validated = $request->validate([
    //             'type' => 'required|in:Income,Expense,Canvas,Donation,Sponsorship',
    //             'description' => 'required|string|max:1000',
    //             'amount' => 'required|numeric|min:0',
    //             'budget_breakdown' => 'nullable|json',
    //             'updated_by' => 'nullable|exists:users,id',
    //             'ledger_proof' => 'nullable|file|mimes:pdf,jpg,jpeg,png|max:10240',
    //         ]);
            
    //         // Update the entry
    //         $entry->type = $request->type;
    //         $entry->description = $request->description;
    //         $entry->amount = $request->amount;
    //         $entry->updated_by = $request->updated_by;
    //         $entry->ledger_proof = $request->ledger_proof;
            
    //         // Handle budget breakdown
    //         if ($request->has('budget_breakdown')) {
    //             $entry->budget_breakdown = $request->budget_breakdown;
    //         }
            
    //         $entry->updated_at = now();
    //         $entry->save();
            
    //         return response()->json($entry);
            
    //     } catch (ValidationException $e) {
    //         Log::warning('Ledger entry update validation failed: ' . json_encode($e->errors()));
    //         return response()->json([
    //             'message' => 'Validation failed',
    //             'errors' => $e->errors(),
    //         ], 422);
    //     } catch (\Exception $e) {
    //         Log::error('Ledger entry update failed: ' . $e->getMessage());
    //         return response()->json([
    //             'message' => 'Failed to update ledger entry',
    //             'error' => $e->getMessage()
    //         ], 500);
    //     }
    // }

    public function update(Request $request, $id)
{
    try {
        $entry = LedgerEntry::findOrFail($id);

        if ($entry->type === 'Initial') {
            return response()->json([
                'message' => 'Initial baseline entries cannot be edited.',
            ], 403);
        }

        // Validate the request
        $validated = $request->validate([
            'type' => 'required|in:Income,Expense,Canvas,Donation,Sponsorship',
            'description' => 'required|string|max:1000',
            'amount' => 'required|numeric|min:0',
            'budget_breakdown' => 'nullable|json',
            'updated_by' => 'nullable|exists:users,id',
            'ledger_proof' => 'nullable|file|mimes:pdf,jpg,jpeg,png|max:10240',
        ]);

        // Update the entry
        $entry->type = $request->type;
        $entry->description = $request->description;
        $entry->amount = $request->amount;
        $entry->updated_by = $request->updated_by;

        // Handle new proof file upload (same hashing scheme as store())
        if ($request->hasFile('ledger_proof')) {
            $file = $request->file('ledger_proof');

            $fileHash = hash_file('sha256', $file->getRealPath());
            $extension = $file->getClientOriginalExtension();
            $fileName = $fileHash . '.' . $extension;

            $filePath = $file->storeAs('ledger_proofs', $fileName, 'public');

            if ($filePath) {
                $entry->ledger_proof = 'storage/ledger_proofs/' . $fileName;
                $entry->file_content_hash = $fileHash;
                Log::info('Ledger entry ' . $entry->id . ' proof updated: ' . $filePath . ' hash: ' . $fileHash);
            }
        }
        // if no new file is sent, leave the existing ledger_proof / file_content_hash untouched

        // Handle budget breakdown
        if ($request->has('budget_breakdown')) {
            $entry->budget_breakdown = $request->budget_breakdown;
        }

        $entry->updated_at = now();
        $entry->save();

        return response()->json($entry);

    } catch (ValidationException $e) {
        Log::warning('Ledger entry update validation failed: ' . json_encode($e->errors()));
        return response()->json([
            'message' => 'Validation failed',
            'errors' => $e->errors(),
        ], 422);
    } catch (\Exception $e) {
        Log::error('Ledger entry update failed: ' . $e->getMessage());
        return response()->json([
            'message' => 'Failed to update ledger entry',
            'error' => $e->getMessage()
        ], 500);
    }
}

    /**
     * Submit ledger entry for approval
     */
    public function submitForApproval($id)
    {
        try {
            $entry = LedgerEntry::findOrFail($id);

            if ($entry->type === 'Initial') {
                return response()->json([
                    'message' => 'Initial baseline entries are submitted automatically with project approval.',
                ], 403);
            }
            
            // Update approval status to Pending Adviser Approval
            $entry->approval_status = 'Pending Adviser Approval';
            $entry->updated_at = now();
            $entry->save();
            
            // Create approval record (no teacher/adviser table query)
            try {
                $approverEmployeeId = $entry->approved_by;

                if (!$approverEmployeeId && $entry->project) {
                    $approverEmployeeId = $entry->project->approve_by;
                }

                if (!$approverEmployeeId && Auth::check()) {
                    $approverEmployeeId = (string) Auth::id();
                }

                Approval::create([
                    'employee_id' => $approverEmployeeId,
                    'project_id' => (string) $entry->project_id,
                    'reference_type' => 'ledger',
                    'approvable_type' => 'ledger_entry',
                    'status' => 'pending',
                ]);
            } catch (\Exception $approvalError) {
                Log::warning('Approval insertion skipped for ledger submit: ' . $approvalError->getMessage());
            }

            $this->createNotification(
                'Ledger entry submitted for approval',
                sprintf(
                    'Ledger entry for project "%s" was submitted and is pending adviser approval.',
                    $entry->project?->title ?? 'Unknown Project'
                ),
                'ledger',
                $entry->created_by
            );
            
            return response()->json($entry);
            
        } catch (\Exception $e) {
            Log::error('Ledger entry submit for approval failed: ' . $e->getMessage());
            return response()->json([
                'message' => 'Failed to submit ledger entry for approval',
                'error' => $e->getMessage()
            ], 500);
        }
    }

    /**
     * Delete a ledger entry
     */
    public function destroy($id)
    {
        try {
            $entry = LedgerEntry::findOrFail($id);

            if ($entry->type === 'Initial') {
                return response()->json([
                    'message' => 'Initial baseline entries cannot be archived.',
                ], 403);
            }

            $entry->archive = 1;
            $entry->updated_at = now();
            $entry->save();

            AuditLog::create([
                'id' => (string) Str::uuid(),
                'user_id' => Auth::id(),
                'actionable_id' => $entry->id,
                'actionable_type' => 'ledger_entry',
                'action' => 'Ledger Entry Archived',
                'module' => 'ledger',
                'action_type' => 'delete',
                'status' => 'Success',
                'details' => 'Archived ledger entry "' . ($entry->description ?? 'N/A') . '" for project ID ' . $entry->project_id,
                'ip_address' => request()->ip(),
                'browser_info' => substr((string) request()->userAgent(), 0, 500),
                'archive' => 0,
            ]);
            
            return response()->json(['message' => 'Ledger entry archived successfully']);
            
        } catch (\Exception $e) {
            Log::error('Ledger entry archiving failed: ' . $e->getMessage());
            return response()->json([
                'message' => 'Failed to archive ledger entry',
                'error' => $e->getMessage()
            ], 500);
        }
    }

    /**
     * Restore an archived ledger entry
     */
    public function restore($id)
    {
        try {
            $entry = LedgerEntry::findOrFail($id);
            $entry->archive = 0;
            $entry->updated_at = now();
            $entry->save();

            return response()->json(['message' => 'Ledger entry restored successfully']);

        } catch (\Exception $e) {
            Log::error('Ledger entry restore failed: ' . $e->getMessage());
            return response()->json([
                'message' => 'Failed to restore ledger entry',
                'error' => $e->getMessage()
            ], 500);
        }
    }

    /**
     * Get all proof documents from ledger entries
     */
    public function getProofDocuments()
    {
        try {
            $proofDocuments = [];

            // 1. Get initial proofs from projects
            $projects = \App\Models\CSG\Project::where('archive', 0)
                ->whereNotNull('project_proof')
                ->orderBy('created_at', 'desc')
                ->get();

            foreach ($projects as $project) {
                $fileName = basename($project->project_proof);
                $filePath = $project->project_proof;
                $fileExtension = pathinfo($fileName, PATHINFO_EXTENSION);
                $fileType = in_array(strtolower($fileExtension), ['pdf']) ? 'PDF' : 'Image';

                // Calculate file size
                $fileSize = 'Unknown';
                try {
                    $fullPath = storage_path('app/public/ledger_proofs/' . $fileName);
                    if (file_exists($fullPath)) {
                        $fileSizeBytes = filesize($fullPath);
                        $fileSize = round($fileSizeBytes / (1024 * 1024), 2) . ' MB';
                    }
                } catch (\Exception $e) {
                    // Keep default 'Unknown'
                }

                $proofDocuments[] = [
                    'id' => 'PROOF-INITIAL-' . substr($project->id, 0, 8),
                    'fileName' => $fileName,
                    'linkedTransaction' => $project->id,
                    'linkedProject' => $project->title,
                    'uploadDate' => $project->created_at->format('Y-m-d'),
                    'fileType' => $fileType,
                    'fileSize' => $fileSize,
                    'status' => 'Approved',
                    // 'uploadedBy' => $project->created_by ? 'User ' . $project->created_by : 'Unknown',
                   'uploadedBy' => $project->created_by
    ? User::find($project->created_by)?->name ?? 'Unknown'
    : 'Unknown',
                    'hash' => 'N/A',
                    'filePath' => $filePath,
                    'description' => 'Initial Project Proof',
                ];
            }

            // 2. Get ledger entry proofs
            $entries = LedgerEntry::where('archive', 0)
                ->whereNotNull('ledger_proof')
                ->with('project')
                ->whereHas('project', function ($q) {
                    $q->where('archive', 0);
                })
                ->orderBy('created_at', 'desc')
                ->get();

            foreach ($entries as $entry) {
                $fileName = basename($entry->ledger_proof);
                $filePath = $entry->ledger_proof;
                $fileExtension = pathinfo($fileName, PATHINFO_EXTENSION);
                $fileType = in_array(strtolower($fileExtension), ['pdf']) ? 'PDF' : 'Image';

                // Calculate file size
                $fileSize = 'Unknown';
                try {
                    $fullPath = storage_path('app/public/ledger_proofs/' . $fileName);
                    if (file_exists($fullPath)) {
                        $fileSizeBytes = filesize($fullPath);
                        $fileSize = round($fileSizeBytes / (1024 * 1024), 2) . ' MB';
                    }
                } catch (\Exception $e) {
                    // Keep default 'Unknown'
                }

                $proofDocuments[] = [
                    'id' => 'PROOF-' . substr($entry->id, 0, 8),
                    'fileName' => $fileName,
                    'linkedTransaction' => $entry->id,
                    'linkedProject' => $entry->project ? $entry->project->title : 'Unknown Project',
                    'uploadDate' => $entry->created_at->format('Y-m-d'),
                    'fileType' => $fileType,
                    'fileSize' => $fileSize,
                    'status' => $entry->approval_status,
                    // 'uploadedBy' => $entry->created_by ? 'User ' . $entry->created_by : 'Unknown',
                   'uploadedBy' => $entry->created_by
    ? User::find($entry->created_by)?->name ?? 'Unknown'
    : 'Unknown',
                    'hash' => $entry->file_content_hash ?? 'Not available',
                    'filePath' => $filePath,
                    'description' => $entry->description ?? 'No description available',
                ];
            }

            return response()->json($proofDocuments);
        } catch (\Exception $e) {
            return response()->json([
                'message' => 'Failed to fetch proof documents',
                'error' => $e->getMessage()
            ], 500);
        }
    }

    /**
     * Verify blockchain integrity for a project
     */
    public function verifyChain($projectId)
    {
        try {
            $verification = \App\Support\BlockchainService::verifyChain($projectId);
            
            return response()->json($verification);
        } catch (\Exception $e) {
            return response()->json([
                'message' => 'Failed to verify blockchain',
                'error' => $e->getMessage()
            ], 500);
        }
    }

    /**
     * Helper method to get user name from user ID
     */
    private function getUserName($userId)
    {
        if (!$userId) {
            return 'Unknown';
        }
        $user = User::find($userId);
        return $user ? $user->name : 'Unknown';
    }
}
