<?php

namespace App\Http\Controllers\CSG;

use App\Http\Controllers\Controller;
use App\Models\AuditLog;
use App\Models\CSG\Project;
use App\Models\CSG\Approval;
use App\Models\CSG\LedgerEntry;
use App\Models\User\Rating;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\DB;
use Illuminate\Support\Facades\Storage;
use Illuminate\Support\Facades\Log;
use Illuminate\Support\Facades\Auth;
use Illuminate\Support\Str;

class ProjectController extends Controller
{
    public function index()
    {
        return response()->json(Project::where('archive', 0)->get());
    }

    public function show($id)
    {
        try {
            $project = Project::with(['approver:id,name', 'creator:id,name'])->find($id);
            
            if (!$project) {
                return response()->json(['message' => 'Project not found'], 404);
            }

            // Check for tampered ledger entries in this project
            $tamperedCount = 0;
            $verification = \App\Support\BlockchainService::verifyChain($project->id);
            if (isset($verification['tamperedBlocks']) && is_array($verification['tamperedBlocks'])) {
                $tamperedCount = count($verification['tamperedBlocks']);
            }

            $projectData = $project->toArray();
            $projectData['tamperedAlerts'] = $tamperedCount;
            $projectData['approveBy'] = $project->approver?->name ?? null;
            $projectData['createdBy'] = $project->creator?->name ?? null;

            $initialTransferLedger = LedgerEntry::where('project_id', $project->id)
                ->where('type', 'Initial')
                ->where('category', 'Transfer')
                ->where('archive', 0)
                ->first();

            if ($initialTransferLedger) {
                $sourceEntry = $this->findTransferSourceEntry($project->id);
                $transferMetadata = $sourceEntry ? json_decode($sourceEntry->note, true) : null;
                $projectData['budgetSource'] = 'past_project';
                $projectData['transferFromProjectId'] = is_array($transferMetadata)
                    ? ($transferMetadata['transfer_source_project_id'] ?? null)
                    : null;
                $projectData['transferAmount'] = (float) $initialTransferLedger->amount;
            } else {
                $projectData['budgetSource'] = 'none';
                $projectData['transferFromProjectId'] = null;
                $projectData['transferAmount'] = null;
            }
            
            return response()->json($projectData, 200);
        } catch (\Exception $e) {
            return response()->json([
                'message' => 'Failed to fetch project',
                'error' => $e->getMessage()
            ], 500);
        }
    }

    public function store(Request $request)
    {
        try {
            // Validate required fields
            $validated = $request->validate([
                'title' => 'required|string|max:255',
                'description' => 'required|string',
                'objective' => 'required|string',
                'venue' => 'required|string',
                'category' => 'required|string',
                'budget' => 'nullable|numeric|min:0',
                'has_budget' => 'nullable|in:0,1,true,false',
                'is_active' => 'nullable|in:0,1,true,false',
                'budget_source' => 'nullable|in:none,past_project',
                'transfer_from_project_id' => 'nullable|string|exists:projects,id',
                'transfer_amount' => 'nullable|numeric|min:0',
                'proposed_by' => 'required|string',
                'status' => 'nullable|string',
                'approval_status' => 'nullable|string',
                'start_date' => 'nullable|date',
                'end_date' => 'nullable|date|after_or_equal:start_date',
                'project_proof' => 'nullable|file|mimes:pdf,jpg,jpeg,png|max:10240', // 10MB max
                'is_initial' => 'nullable|in:0,1',
            ]);

            $hasBudget = $request->boolean('has_budget');
            $isActive = $request->boolean('is_active');
            $budgetSource = $request->input('budget_source', 'none');
            $transferFromProjectId = $request->input('transfer_from_project_id');
            $transferAmount = $request->filled('transfer_amount') ? (float) $request->input('transfer_amount') : 0;
            $budgetAmount = $hasBudget && $request->filled('budget') ? (float) $request->budget : 0;
            $effectiveBudgetAmount = $budgetAmount;
            if ($hasBudget && $budgetSource === 'past_project' && $transferAmount > 0) {
                $effectiveBudgetAmount = $transferAmount;
            }
            $submittedStatus = $request->input('status');
            $submittedApprovalStatus = $request->input('approval_status');

            if ($budgetSource === 'past_project') {
                $request->validate([
                    'transfer_from_project_id' => 'required|string|exists:projects,id',
                    'transfer_amount' => 'required|numeric|min:0.01',
                ]);
            }

            DB::beginTransaction();
            
            $project = new Project();
            $project->id = Str::uuid()->toString();
            $project->title = $request->title;
            $project->description = $request->description;
            $project->objective = $request->objective;
            $project->venue = $request->venue;
            $project->category = $request->category;
            $project->budget = $effectiveBudgetAmount;
            $project->proposed_by = $request->proposed_by;
            $project->start_date = $request->start_date;
            $project->end_date = $request->end_date;
            $project->status = $submittedStatus ?: ($isActive ? 'Ongoing' : 'Draft');
            $project->approval_status = $submittedApprovalStatus ?: ($isActive ? 'Pending Adviser Approval' : 'Draft');
            $project->archive = 0;
            $project->is_initial = $request->is_initial ?? ($effectiveBudgetAmount > 0 ? 1 : 0);
            $project->created_by = Auth::id();
            $project->updated_by = Auth::id();
            
            // Handle file upload
            if ($request->hasFile('project_proof')) {
                try {
                    $file = $request->file('project_proof');
                    $fileName = time() . '_' . Str::random(10) . '_' . $file->getClientOriginalName();
                    
                    // Store the file
                    $filePath = Storage::disk('public')->putFileAs('project_proofs', $file, $fileName);
                    $project->project_proof = 'storage/project_proofs/' . $fileName;
                    
                    Log::info('✅ Project proof file uploaded', [
                        'project_id' => $project->id,
                        'file_name' => $fileName,
                        'file_path' => $filePath,
                    ]);
                } catch (\Exception $fileError) {
                    Log::warning('⚠️ Failed to upload project proof file', [
                        'error' => $fileError->getMessage(),
                    ]);
                    // Don't fail the project creation if file upload fails
                }
            }
            
            $project->created_at = now();
            $project->updated_at = now();
            
            // Save project to database
            $project->save();
            Log::info('✅ Project saved to database', ['project_id' => $project->id]);

            AuditLog::create([
                'id' => (string) Str::uuid(),
                'user_id' => Auth::id(),
                'actionable_id' => $project->id,
                'actionable_type' => 'project',
                'action' => 'Project Created',
                'module' => 'projects',
                'action_type' => 'create',
                'status' => 'Success',
                'details' => 'Created project "' . $project->title . '"',
                'ip_address' => $request->ip(),
                'browser_info' => substr((string) $request->userAgent(), 0, 500),
                'archive' => 0,
            ]);

            $sourceProject = null;
            if ($budgetSource === 'past_project' && $transferAmount > 0 && $transferFromProjectId) {
                $sourceProject = Project::where('archive', 0)->find($transferFromProjectId);

                if ($sourceProject) {
                    $remainingBudget = (float) $sourceProject->budget;
                    if ($remainingBudget < $transferAmount) {
                        throw new \Exception('Transfer amount exceeds the selected project\'s remaining budget');
                    }

                    $transferMetadata = json_encode([
                        'transfer_source_project_id' => $sourceProject->id,
                        'transfer_source_project_title' => $sourceProject->title,
                        'transfer_destination_project_id' => $project->id,
                        'transfer_destination_project_title' => $project->title,
                    ]);
                    $destinationTransferNote = 'Transferred from completed project "' . $sourceProject->title . '" to project "' . $project->title . '"';
                    $transferApprovalStatus = $project->approval_status === 'Approved' ? 'Approved' : 'Draft';
                    //transferNote

                    LedgerEntry::create([
                        'id' => (string) Str::uuid(),
                        'project_id' => $sourceProject->id,
                        'type' => 'Expense',
                        'amount' => $transferAmount,
                        'budget_breakdown' => null,
                        'description' => 'Transferred to project "' . $project->title . '"',
                        'category' => 'Transfer',
                        'approval_status' => $transferApprovalStatus,
                        'note' => $transferMetadata,
                        'created_by' => Auth::id(),
                        'updated_by' => Auth::id(),
                        'archive' => 0,
                        'created_at' => now(),
                        'updated_at' => now(),
                    ]);

                    LedgerEntry::create([
                        'id' => (string) Str::uuid(),
                        'project_id' => $project->id,
                        'type' => 'Initial',
                        'amount' => $transferAmount,
                        'budget_breakdown' => null,
                        'description' => 'Transferred from completed project "' . $sourceProject->title . '"',
                        'category' => 'Transfer',
                        'approval_status' => $transferApprovalStatus,
                        'note' => $destinationTransferNote,
                        'created_by' => Auth::id(),
                        'updated_by' => Auth::id(),
                        'archive' => 0,
                        'created_at' => now(),
                        'updated_at' => now(),
                    ]);
                }
            }

            // Create an initial baseline ledger entry when project starts with budget.
            // Skip this for budget transfers from a past project because the transfer entry
            // already represents the project's starting budget on the destination project.
            $initialLedger = null;
            $isTransferBudget = $budgetSource === 'past_project' && $transferAmount > 0 && !empty($transferFromProjectId);
            if ((float) ($project->budget ?? 0) > 0 && !$isTransferBudget) {
                try {
                    $initialLedger = LedgerEntry::create([
                        'id' => (string) Str::uuid(),
                        'project_id' => $project->id,
                        'type' => 'Initial',
                        'amount' => (float) $project->budget,
                        'budget_breakdown' => null,
                        'description' => 'Initial project budget baseline',
                        'category' => 'Project Budget Baseline',
                        'approval_status' => 'Draft',
                        'note' => 'Auto-generated baseline on project creation',
                        'created_by' => Auth::id(),
                        'updated_by' => Auth::id(),
                        'archive' => 0,
                        'created_at' => now(),
                        'updated_at' => now(),
                    ]);
                    Log::info('✅ Initial ledger entry created', ['ledger_id' => $initialLedger->id]);
                } catch (\Exception $ledgerError) {
                    Log::warning('⚠️ Failed to create initial ledger entry', [
                        'error' => $ledgerError->getMessage(),
                    ]);
                    // Don't fail the project creation if ledger creation fails
                }
            }
            
            DB::commit();

            // Return the project with the file URL and initial ledger
            $project->project_proof_url = $project->project_proof ? Storage::url($project->project_proof) : null;
            
            $responseData = $project->toArray();
            if ($initialLedger) {
                $responseData['initial_ledger'] = [
                    'id' => $initialLedger->id,
                    'amount' => (float) $initialLedger->amount,
                    'approval_status' => $initialLedger->approval_status,
                    'created_at' => $initialLedger->created_at,
                ];
            }
            
            Log::info('✅ Project creation successful', ['project_id' => $project->id]);
            return response()->json($responseData, 201);
            
        } catch (\Illuminate\Validation\ValidationException $e) {
            DB::rollBack();
            Log::warning('❌ Project validation error', ['errors' => $e->errors()]);
            return response()->json([
                'success' => false,
                'message' => 'Validation error',
                'errors' => $e->errors()
            ], 422);
        } catch (\Exception $e) {
            DB::rollBack();
            Log::error('❌ Project creation failed', [
                'error' => $e->getMessage(),
                'trace' => $e->getTraceAsString(),
            ]);
            return response()->json([
                'success' => false,
                'message' => 'Failed to create project',
                'error' => $e->getMessage()
            ], 500);
        }
    }
    
    public function update(Request $request, $id)
    {
        try {
            $project = Project::find($id);
            
            if (!$project) {
                return response()->json(['message' => 'Project not found'], 404);
            }
            
            // Validate the request
            $request->validate([
                'title' => 'sometimes|required|string|max:255',
                'description' => 'sometimes|required|string',
                'objective' => 'sometimes|required|string',
                'venue' => 'sometimes|required|string',
                'category' => 'sometimes|required|string',
                'budget' => 'sometimes|nullable|numeric|min:0',
                'has_budget' => 'nullable|in:0,1,true,false',
                'budget_source' => 'nullable|in:none,past_project',
                'transfer_from_project_id' => 'nullable|string|exists:projects,id',
                'transfer_amount' => 'nullable|numeric|min:0',
                'proposed_by' => 'sometimes|required|string',
                'start_date' => 'nullable|date',
                'end_date' => 'nullable|date|after_or_equal:start_date',
                'project_proof' => 'nullable|file|mimes:pdf,jpg,jpeg,png|max:10240',
            ]);

            $hasBudget = $request->boolean('has_budget');
            $budgetSource = $request->input('budget_source', 'none');
            $transferFromProjectId = $request->input('transfer_from_project_id');
            $transferAmount = $request->filled('transfer_amount') ? (float) $request->input('transfer_amount') : 0;

            if ($hasBudget && $budgetSource === 'past_project') {
                $request->validate([
                    'transfer_from_project_id' => 'required|string|exists:projects,id',
                    'transfer_amount' => 'required|numeric|min:0.01',
                ]);
            }
            
            // Update only fields that are provided
            if ($request->has('title')) $project->title = $request->title;
            if ($request->has('description')) $project->description = $request->description;
            if ($request->has('objective')) $project->objective = $request->objective;
            if ($request->has('venue')) $project->venue = $request->venue;
            if ($request->has('category')) $project->category = $request->category;
            
            // If budget is being changed, update the existing baseline ledger entry (never duplicate)
            if ($request->has('has_budget') || $request->has('budget') || $request->has('budget_source')) {
                $oldBudget = (float) $project->budget;
                $baseline = $this->findProjectBaselineEntry($project->id);
                $newBudget = $oldBudget;

                if (!$hasBudget) {
                    $newBudget = 0;
                } elseif ($budgetSource === 'past_project' && $transferAmount > 0 && $transferFromProjectId) {
                    $sourceProject = Project::where('archive', 0)->find($transferFromProjectId);

                    if (!$sourceProject) {
                        return response()->json(['message' => 'Source project not found'], 422);
                    }

                    if ((string) $sourceProject->id === (string) $project->id) {
                        return response()->json(['message' => 'Cannot transfer budget from the same project'], 422);
                    }

                    $existingSourceEntry = $baseline && $baseline->category === 'Transfer'
                        ? $this->findTransferSourceEntry($project->id)
                        : null;
                    $previousTransferAmount = $existingSourceEntry ? (float) $existingSourceEntry->amount : 0;
                    $sameSource = $existingSourceEntry
                        && (string) $existingSourceEntry->project_id === (string) $sourceProject->id;
                    $availableBalance = (float) $sourceProject->budget + ($sameSource ? $previousTransferAmount : 0);

                    if ($transferAmount > $availableBalance) {
                        return response()->json(['message' => 'Transfer amount exceeds the selected project\'s remaining budget'], 422);
                    }

                    $newBudget = $transferAmount;
                } elseif ($request->has('budget')) {
                    $newBudget = $hasBudget && $request->filled('budget') ? (float) $request->budget : 0;
                }

                $project->budget = $newBudget;

                $resolvedBudgetContext = $this->resolveBudgetUpdateContext(
                    $project,
                    $baseline,
                    $budgetSource,
                    $transferFromProjectId,
                    $transferAmount,
                    $newBudget
                );

                if ($project->approval_status !== 'Approved') {
                    $this->syncProjectBudgetLedger(
                        $project,
                        $baseline,
                        $newBudget,
                        $hasBudget,
                        $resolvedBudgetContext['budgetSource'],
                        $resolvedBudgetContext['transferFromProjectId'],
                        $resolvedBudgetContext['transferAmount']
                    );
                }
            }
            
            if ($request->has('proposed_by')) $project->proposed_by = $request->proposed_by;
            if ($request->has('start_date')) $project->start_date = $request->start_date;
            if ($request->has('end_date')) $project->end_date = $request->end_date;
            if ($request->has('status')) $project->status = $request->status;
            if ($request->has('approval_status')) {
                $project->approval_status = $request->approval_status;

                if ($project->approval_status === 'Approved') {
                    $transferEntries = LedgerEntry::where('project_id', $project->id)
                        ->where('category', 'Transfer')
                        ->where('archive', 0)
                        ->where('note', 'like', '%' . $project->id . '%')
                        ->get();

                    foreach ($transferEntries as $transferEntry) {
                        $noteData = json_decode($transferEntry->note, true);
                        if (!is_array($noteData)) {
                            continue;
                        }

                        $sourceProjectId = $noteData['transfer_source_project_id'] ?? null;
                        if (!$sourceProjectId) {
                            continue;
                        }

                        $sourceProject = Project::where('archive', 0)->find($sourceProjectId);
                        if (!$sourceProject) {
                            continue;
                        }

                        $remainingBudget = (float) $sourceProject->budget;
                        $transferAmount = (float) $transferEntry->amount;
                        if ($remainingBudget >= $transferAmount) {
                            $sourceProject->budget = max(0, $remainingBudget - $transferAmount);
                            $sourceProject->updated_by = Auth::id();
                            $sourceProject->updated_at = now();
                            $sourceProject->save();
                        }
                    }

                    $transferProjectEntries = LedgerEntry::where('category', 'Transfer')
                        ->where('archive', 0)
                        ->where('note', 'like', '%' . $project->id . '%')
                        ->where('project_id', '!=', $project->id)
                        ->get();

                    foreach ($transferProjectEntries as $transferProjectEntry) {
                        $destinationProject = Project::where('archive', 0)->find($transferProjectEntry->project_id);
                        if ($destinationProject && $destinationProject->id !== $project->id) {
                            $destinationProject->approval_status = 'Approved';
                            $destinationProject->updated_by = Auth::id();
                            $destinationProject->updated_at = now();
                            $destinationProject->save();
                        }
                    }
                }

                $transferApprovalStatus = in_array($project->approval_status, ['Approved']) ? 'Approved' : 'Draft';
                LedgerEntry::where('project_id', $project->id)
                    ->where('category', 'Transfer')
                    ->where('archive', 0)
                    ->where('note', 'like', '%' . $project->id . '%')
                    ->update([
                        'approval_status' => $transferApprovalStatus,
                        'updated_by' => Auth::id(),
                        'updated_at' => now(),
                    ]);
            }
            if ($request->has('archive')) $project->archive = $request->archive;
            if ($request->has('note')) $project->note = $request->note;
            if ($request->has('approve_by')) $project->approve_by = $request->approve_by;
            
            $project->updated_by = Auth::id();
            $project->updated_at = now();
            
            // Handle file upload if new file is provided
            if ($request->hasFile('project_proof')) {
                // Delete old file if exists - extract actual path from storage prefix
                if ($project->project_proof) {
                    $actualPath = str_replace('storage/', '', $project->project_proof);
                    if (Storage::disk('public')->exists($actualPath)) {
                        Storage::disk('public')->delete($actualPath);
                    }
                }
                
                $file = $request->file('project_proof');
                $fileName = time() . '_' . $file->getClientOriginalName();
                $filePath = $file->storeAs('project_proofs', $fileName, 'public');
                $project->project_proof = 'storage/project_proofs/' . $fileName;
            }
            
            $project->save();
            
            // Add file URL to response
            $project->project_proof_url = $project->project_proof ? Storage::url($project->project_proof) : null;
            
            // Include the Initial ledger entry in response to show updated budget immediately
            $initialLedger = LedgerEntry::where('project_id', $project->id)
                ->where('type', 'Initial')
                ->where('archive', 0)
                ->first();
            
            $responseData = $project->toArray();
            if ($initialLedger) {
                $responseData['initial_ledger'] = [
                    'id' => $initialLedger->id,
                    'amount' => (float) $initialLedger->amount,
                    'approval_status' => $initialLedger->approval_status,
                    'updated_at' => $initialLedger->updated_at,
                ];
            }
            
            return response()->json($responseData, 200);
        } catch (\Exception $e) {
            Log::error('Project update failed: ' . $e->getMessage());
            return response()->json([
                'message' => 'Failed to update project',
                'error' => $e->getMessage()
            ], 500);
        }
    }
    
    public function destroy($id)
    {
        try {
            $project = Project::find($id);
            
            if (!$project) {
                return response()->json(['message' => 'Project not found'], 404);
            }
            
            // Delete associated file if exists
            if ($project->project_proof && Storage::disk('public')->exists($project->project_proof)) {
                Storage::disk('public')->delete($project->project_proof);
            }

            // Archive all associated ledger entries (including initial entry) before project deletion
            LedgerEntry::where('project_id', $id)
                ->update(['archive' => 1, 'updated_at' => now()]);

            // Delete blockchain chain records for this project
            DB::table('chain')->where('approval_id', $id)->delete();
            
            // Hard delete the project
            $project->delete();

            AuditLog::create([
                'id' => (string) Str::uuid(),
                'user_id' => Auth::id(),
                'actionable_id' => $id,
                'actionable_type' => 'project',
                'action' => 'Project Deleted',
                'module' => 'projects',
                'action_type' => 'delete',
                'status' => 'Success',
                'details' => 'Deleted project "' . ($project->title ?? 'N/A') . '" and archived related ledger entries',
                'ip_address' => request()->ip(),
                'browser_info' => substr((string) request()->userAgent(), 0, 500),
                'archive' => 0,
            ]);
            
            return response()->json(['message' => 'Project and associated records deleted successfully'], 200);
        } catch (\Exception $e) {
            return response()->json([
                'message' => 'Failed to delete project',
                'error' => $e->getMessage()
            ], 500);
        }
    }
    
    public function archive($id)
    {
        try {
            $project = Project::find($id);
            
            if (!$project) {
                return response()->json(['message' => 'Project not found'], 404);
            }
            
            $project->archive = 1;
            $project->save();

            // Archive all ledger entries (initial + others) for this project
            $archivedLedgers = LedgerEntry::where('project_id', $id)
                ->update(['archive' => 1, 'updated_at' => now()]);

            AuditLog::create([
                'id' => (string) Str::uuid(),
                'user_id' => Auth::id(),
                'actionable_id' => $project->id,
                'actionable_type' => 'project',
                'action' => 'Project Archived',
                'module' => 'projects',
                'action_type' => 'delete',
                'status' => 'Success',
                'details' => 'Archived project "' . ($project->title ?? 'N/A') . '" and ' . $archivedLedgers . ' related ledger entr' . ($archivedLedgers === 1 ? 'y' : 'ies'),
                'ip_address' => request()->ip(),
                'browser_info' => substr((string) request()->userAgent(), 0, 500),
                'archive' => 0,
            ]);
            
            return response()->json(['message' => 'Project archived successfully'], 200);
        } catch (\Exception $e) {
            return response()->json([
                'message' => 'Failed to archive project',
                'error' => $e->getMessage()
            ], 500);
        }
   }

    public function submitForApproval($id)
    {
        try {
            $project = Project::find($id);
            
            if (!$project) {
                return response()->json(['message' => 'Project not found'], 404);
            }
            
            $transferEntries = LedgerEntry::where('project_id', $project->id)
                ->where('category', 'Transfer')
                ->where('archive', 0)
                ->get();

            // Submitting a project for approval must always wait for adviser approval.
            // Transfer-linked projects should not become approved immediately.
            $project->approval_status = 'Pending Adviser Approval';
            $project->updated_at = now();
            $project->save();


            // Create approval record (no teacher/adviser table dependency)
            try {
                $approverEmployeeId = $project->approve_by;

                if (!$approverEmployeeId && Auth::check()) {
                    // use current logged-in user id as fallback employee_id
                    $approverEmployeeId = (string) Auth::id();
                }

                Approval::create([
                    'employee_id' => $approverEmployeeId,
                    'project_id' => (string) $project->id,
                    'reference_type' => 'project',
                    'approvable_type' => 'project',
                    'status' => 'pending',
                ]);
            } catch (\Exception $approvalError) {
                // Log success path and continue. Data may still be in project record.
                Log::warning('Approval insertion skipped due to error: ' . $approvalError->getMessage());
            }

            $this->createNotification(
                'Project submitted for approval',
                sprintf(
                    'Your project "%s" has been submitted and is pending adviser approval.',
                    $project->title ?? 'Untitled Project'
                ),
                'project',
                $project->created_by
            );
            
            return response()->json([
                'message' => 'Project submitted for adviser approval successfully',
                'data' => $project
            ], 200);
        } catch (\Exception $e) {
            return response()->json([
                'message' => 'Failed to submit project for approval',
                'error' => $e->getMessage()
            ], 500);
        }
    }

    public function ledgerEntries($id)
    {
        try {
            $project = Project::find($id);

            if (!$project) {
                return response()->json(['message' => 'Project not found'], 404);
            }

            $ledgerEntries = DB::table('ledger_entries')
                ->where('project_id', $id)
                ->where('archive', 0)
                ->orderBy('created_at', 'asc')
                ->get();

            return response()->json($ledgerEntries, 200);
        } catch (\Exception $e) {
            return response()->json([
                'message' => 'Failed to fetch ledger entries',
                'error' => $e->getMessage()
            ], 500);
        }
    }
    
    // Add method to get file
    public function getFile($id)
    {
        try {
            $project = Project::find($id);
            
            if (!$project || !$project->project_proof) {
                return response()->json(['message' => 'File not found'], 404);
            }
            
            if (!Storage::disk('public')->exists($project->project_proof)) {
                return response()->json(['message' => 'File not found on disk'], 404);
            }
            
            return response()->json([
                'url' => Storage::url($project->project_proof),
                'filename' => basename($project->project_proof)
            ], 200);
        } catch (\Exception $e) {
            return response()->json([
                'message' => 'Failed to get file',
                'error' => $e->getMessage()
            ], 500);
        }
    }
    
    // Add method to delete file only
    public function deleteFile($id)
    {
        try {
            $project = Project::find($id);
            
            if ($project && $project->project_proof) {
                // Delete the file from storage
                if (Storage::disk('public')->exists($project->project_proof)) {
                    Storage::disk('public')->delete($project->project_proof);
                }
                $project->project_proof = null;
                $project->save();
                
                return response()->json(['message' => 'File deleted successfully'], 200);
            }
            
            return response()->json(['message' => 'No file found'], 404);
        } catch (\Exception $e) {
            return response()->json([
                'message' => 'Failed to delete file',
                'error' => $e->getMessage()
            ], 500);
        }
    }

    public function getRatings($id)
    {
        try {
            $project = Project::find($id);
            
            if (!$project) {
                return response()->json(['message' => 'Project not found'], 404);
            }
            
            $ratings = Rating::query()
                ->where('project_id', $id)
                ->where('archive', false)
                ->with(['user:id,name'])
                ->orderByDesc('created_at')
                ->get()
                ->map(function (Rating $r) {
                    return [
                        'id' => $r->id,
                        'user_name' => $r->user?->name ?? 'Student',
                        'rating' => (int) ($r->rating_score ?? 0),
                        'satisfaction_rating' => (int) ($r->satisfaction_rating ?? 0),
                        'completeness_rating' => (int) ($r->completeness_rating ?? 0),
                        'engagement_rating' => (int) ($r->engagement_rating ?? 0),
                        'comment' => (string) ($r->comments ?? ''),
                        'created_at' => optional($r->created_at)->format('Y-m-d') ?? '',
                        'date' => optional($r->created_at)->format('Y-m-d') ?? '',
                        'helpful' => (int) ($r->helpful_count ?? 0),
                    ];
                })->values();
            
            // Calculate statistics
            $total = $ratings->count();
            $satisfactionAverage = $total > 0 ? round($ratings->avg('satisfaction_rating'), 2) : 0;
            $completenessAverage = $total > 0 ? round($ratings->avg('completeness_rating'), 2) : 0;
            $engagementAverage = $total > 0 ? round($ratings->avg('engagement_rating'), 2) : 0;
            $average = $total > 0
                ? round((float) (($satisfactionAverage + $completenessAverage + $engagementAverage) / 3), 2)
                : 0;
            $distribution = [5 => 0, 4 => 0, 3 => 0, 2 => 0, 1 => 0];
            
            foreach ($ratings as $r) {
                if (isset($distribution[$r['rating']])) {
                    $distribution[$r['rating']]++;
                }
            }
            
            // CSAT: 3-5 stars = satisfied, 1-2 stars = not satisfied
            $satisfied = $distribution[5] + $distribution[4] + $distribution[3];
            $notSatisfied = $distribution[2] + $distribution[1];
            $csat = $total > 0 ? (int) round(100 * $satisfied / $total) : 0;

            return response()->json([
                'ratings' => $ratings,
                'statistics' => [
                    'averageRating' => (float) $average,
                    'totalRatings' => $total,
                    'satisfactionAverage' => $satisfactionAverage,
                    'completenessAverage' => $completenessAverage,
                    'engagementAverage' => $engagementAverage,
                    'ratingDistribution' => $distribution,
                    'csatRate' => $csat,
                    'satisfied' => $satisfied,
                    'notSatisfied' => $notSatisfied,
                ],
            ], 200);
        } catch (\Exception $e) {
            return response()->json([
                'message' => 'Failed to fetch ratings',
                'error' => $e->getMessage()
            ], 500);
        }
    }

    /**
     * Request a change to project dates
     */
    public function requestDateChange(Request $request, $id)
    {
        try {
            $project = Project::find($id);
            
            if (!$project) {
                return response()->json(['message' => 'Project not found'], 404);
            }

            $validated = $request->validate([
                'proposed_start_date' => 'required|date',
                'proposed_end_date' => 'required|date|after_or_equal:proposed_start_date',
                'reason' => 'required|string|max:1000',
            ]);

            // Create date change request
            $changeRequest = \App\Models\CSG\DateChangeRequest::create([
                'id' => (string) Str::uuid(),
                'project_id' => $id,
                'requested_by' => Auth::id(),
                'current_start_date' => $project->start_date,
                'current_end_date' => $project->end_date,
                'proposed_start_date' => $validated['proposed_start_date'],
                'proposed_end_date' => $validated['proposed_end_date'],
                'reason' => $validated['reason'],
                'status' => 'pending',
            ]);

            Log::info('Date change request created: ' . $changeRequest->id . ' for project: ' . $id);

            // Create audit log
            AuditLog::create([
                'id' => (string) Str::uuid(),
                'user_id' => Auth::id(),
                'actionable_id' => $changeRequest->id,
                'actionable_type' => 'date_change_request',
                'action' => 'Date Change Requested',
                'module' => 'project',
                'action_type' => 'create',
                'status' => 'Success',
                'details' => 'Requested date change for project: ' . $project->title,
                'ip_address' => $request->ip(),
                'browser_info' => substr((string) $request->userAgent(), 0, 500),
                'archive' => 0,
            ]);

            return response()->json([
                'success' => true,
                'message' => 'Date change request submitted successfully',
                'data' => $changeRequest,
            ], 201);

        } catch (\Illuminate\Validation\ValidationException $e) {
            Log::warning('Date change request validation failed: ' . json_encode($e->errors()));
            return response()->json([
                'success' => false,
                'message' => 'Validation failed',
                'errors' => $e->errors(),
            ], 422);
        } catch (\Exception $e) {
            Log::error('Date change request failed: ' . $e->getMessage());
            return response()->json([
                'message' => 'Failed to submit date change request',
                'error' => $e->getMessage()
            ], 500);
        }
    }

    public function getDateChangeRequests($id)
    {
        try {
            $project = Project::find($id);
            
            if (!$project) {
                return response()->json(['message' => 'Project not found'], 404);
            }

            $requests = \App\Models\CSG\DateChangeRequest::where('project_id', $id)
                ->with(['requestedByUser:id,name', 'reviewedByUser:id,name'])
                ->orderBy('created_at', 'desc')
                ->get()
                ->map(function ($request) {
                    return [
                        'id' => $request->id,
                        'project_id' => $request->project_id,
                        'status' => $request->status,
                        'current_start_date' => $request->current_start_date,
                        'current_end_date' => $request->current_end_date,
                        'proposed_start_date' => $request->proposed_start_date,
                        'proposed_end_date' => $request->proposed_end_date,
                        'reason' => $request->reason,
                        'requested_by_user' => $request->requestedByUser,
                        'reviewed_by_user' => $request->reviewedByUser,
                        'reviewed_at' => $request->reviewed_at,
                        'rejection_reason' => $request->rejection_reason,
                        'created_at' => $request->created_at,
                        'updated_at' => $request->updated_at,
                    ];
                });

            return response()->json($requests, 200);

        } catch (\Exception $e) {
            Log::error('Failed to fetch date change requests: ' . $e->getMessage());
            return response()->json([
                'message' => 'Failed to fetch date change requests',
                'error' => $e->getMessage()
            ], 500);
        }
    }

    protected function resolveBudgetUpdateContext(
        Project $project,
        ?LedgerEntry $baseline,
        string $budgetSource,
        ?string $transferFromProjectId,
        float $transferAmount,
        float $newBudget
    ): array {
        if ($baseline && $baseline->category === 'Transfer') {
            $sourceEntry = $this->findTransferSourceEntry($project->id);
            $transferMetadata = $sourceEntry ? json_decode($sourceEntry->note, true) : null;

            return [
                'budgetSource' => 'past_project',
                'transferFromProjectId' => $transferFromProjectId
                    ?: (is_array($transferMetadata) ? ($transferMetadata['transfer_source_project_id'] ?? null) : null),
                'transferAmount' => $transferAmount > 0 ? $transferAmount : $newBudget,
            ];
        }

        return [
            'budgetSource' => $budgetSource,
            'transferFromProjectId' => $transferFromProjectId,
            'transferAmount' => $transferAmount > 0 ? $transferAmount : $newBudget,
        ];
    }

    protected function findProjectBaselineEntry(string $projectId): ?LedgerEntry
    {
        return LedgerEntry::where('project_id', $projectId)
            ->where('type', 'Initial')
            ->where('archive', 0)
            ->orderBy('created_at')
            ->first();
    }

    protected function findTransferSourceEntry(string $destinationProjectId): ?LedgerEntry
    {
        return LedgerEntry::where('category', 'Transfer')
            ->where('type', 'Expense')
            ->where('archive', 0)
            ->get()
            ->first(function (LedgerEntry $entry) use ($destinationProjectId) {
                $noteData = json_decode($entry->note, true);

                return is_array($noteData)
                    && (string) ($noteData['transfer_destination_project_id'] ?? '') === (string) $destinationProjectId;
            });
    }

    protected function syncProjectBudgetLedger(
        Project $project,
        ?LedgerEntry $baseline,
        float $newBudget,
        bool $hasBudget,
        string $budgetSource,
        ?string $transferFromProjectId,
        float $transferAmount
    ): void {
        if (!$hasBudget || $newBudget <= 0) {
            if ($baseline) {
                $baseline->update([
                    'amount' => 0,
                    'updated_by' => Auth::id(),
                    'updated_at' => now(),
                ]);

                if ($baseline->category === 'Transfer') {
                    $sourceEntry = $this->findTransferSourceEntry($project->id);
                    $sourceEntry?->update([
                        'amount' => 0,
                        'updated_by' => Auth::id(),
                        'updated_at' => now(),
                    ]);
                }
            }

            return;
        }

        if ($budgetSource === 'past_project' && $transferAmount > 0 && ($transferFromProjectId || ($baseline && $baseline->category === 'Transfer'))) {
            $sourceProject = $transferFromProjectId
                ? Project::where('archive', 0)->find($transferFromProjectId)
                : null;

            if (!$sourceProject && $baseline && $baseline->category === 'Transfer') {
                $sourceEntry = $this->findTransferSourceEntry($project->id);
                $transferMetadata = $sourceEntry ? json_decode($sourceEntry->note, true) : null;
                $sourceProjectId = is_array($transferMetadata)
                    ? ($transferMetadata['transfer_source_project_id'] ?? null)
                    : null;

                if ($sourceProjectId) {
                    $sourceProject = Project::where('archive', 0)->find($sourceProjectId);
                }
            }

            if (!$sourceProject) {
                return;
            }

            if ($baseline && $baseline->category === 'Transfer') {
                $this->updateTransferLedgerPair($project, $sourceProject, $baseline, $newBudget);
                return;
            }

            if (!$baseline) {
                $this->createTransferLedgerPair($project, $sourceProject, $newBudget);
            }

            return;
        }

        if ($baseline) {
            $baseline->update([
                'amount' => $newBudget,
                'updated_by' => Auth::id(),
                'updated_at' => now(),
            ]);

            if ($baseline->category === 'Transfer') {
                $sourceEntry = $this->findTransferSourceEntry($project->id);
                $sourceEntry?->update([
                    'amount' => $newBudget,
                    'updated_by' => Auth::id(),
                    'updated_at' => now(),
                ]);
            }

            return;
        }

        LedgerEntry::create([
            'id' => (string) Str::uuid(),
            'project_id' => $project->id,
            'type' => 'Initial',
            'amount' => $newBudget,
            'budget_breakdown' => null,
            'description' => 'Initial project budget baseline',
            'category' => 'Initial',
            'approval_status' => 'Draft',
            'created_by' => Auth::id(),
            'updated_by' => Auth::id(),
            'archive' => 0,
            'created_at' => now(),
            'updated_at' => now(),
        ]);
    }

    protected function updateTransferLedgerPair(
        Project $project,
        Project $sourceProject,
        LedgerEntry $destinationBaseline,
        float $newBudget
    ): void {
        $transferApprovalStatus = $project->approval_status === 'Approved' ? 'Approved' : 'Draft';
        $destinationBaseline->update([
            'amount' => $newBudget,
            'description' => 'Transferred from completed project "' . $sourceProject->title . '"',
            'approval_status' => $transferApprovalStatus,
            'updated_by' => Auth::id(),
            'updated_at' => now(),
        ]);

        $sourceEntry = $this->findTransferSourceEntry($project->id);
        if ($sourceEntry) {
            $transferMetadata = json_encode([
                'transfer_source_project_id' => $sourceProject->id,
                'transfer_source_project_title' => $sourceProject->title,
                'transfer_destination_project_id' => $project->id,
                'transfer_destination_project_title' => $project->title,
            ]);

            $sourceEntry->update([
                'project_id' => $sourceProject->id,
                'amount' => $newBudget,
                'description' => 'Transferred to project "' . $project->title . '"',
                'approval_status' => $transferApprovalStatus,
                'note' => $transferMetadata,
                'updated_by' => Auth::id(),
                'updated_at' => now(),
            ]);
        }
    }

    protected function createTransferLedgerPair(Project $project, Project $sourceProject, float $transferAmount): void
    {
        $transferMetadata = json_encode([
            'transfer_source_project_id' => $sourceProject->id,
            'transfer_source_project_title' => $sourceProject->title,
            'transfer_destination_project_id' => $project->id,
            'transfer_destination_project_title' => $project->title,
        ]);
        $destinationTransferNote = 'Transferred from completed project "' . $sourceProject->title . '" to project "' . $project->title . '"';
        $transferApprovalStatus = $project->approval_status === 'Approved' ? 'Approved' : 'Draft';

        LedgerEntry::create([
            'id' => (string) Str::uuid(),
            'project_id' => $sourceProject->id,
            'type' => 'Expense',
            'amount' => $transferAmount,
            'budget_breakdown' => null,
            'description' => 'Transferred to project "' . $project->title . '"',
            'category' => 'Transfer',
            'approval_status' => $transferApprovalStatus,
            'note' => $transferMetadata,
            'created_by' => Auth::id(),
            'updated_by' => Auth::id(),
            'archive' => 0,
            'created_at' => now(),
            'updated_at' => now(),
        ]);

        LedgerEntry::create([
            'id' => (string) Str::uuid(),
            'project_id' => $project->id,
            'type' => 'Initial',
            'amount' => $transferAmount,
            'budget_breakdown' => null,
            'description' => 'Transferred from completed project "' . $sourceProject->title . '"',
            'category' => 'Transfer',
            'approval_status' => $transferApprovalStatus,
            'note' => $destinationTransferNote,
            'created_by' => Auth::id(),
            'updated_by' => Auth::id(),
            'archive' => 0,
            'created_at' => now(),
            'updated_at' => now(),
        ]);
    }
}