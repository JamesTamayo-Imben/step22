<?php

namespace App\Http\Controllers\CSG;

use App\Http\Controllers\Controller;
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
            $project = Project::find($id);
            
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
                'proposed_by' => 'required|string',
                'status' => 'nullable|string',
                'approval_status' => 'nullable|string',
                'start_date' => 'nullable|date',
                'end_date' => 'nullable|date|after_or_equal:start_date',
                'project_proof' => 'nullable|file|mimes:pdf,jpg,jpeg,png|max:10240', // 10MB max
                'is_initial' => 'nullable|in:0,1',
            ]);
            
            $project = new Project();
            $project->id = Str::uuid()->toString();
            $project->title = $request->title;
            $project->description = $request->description;
            $project->objective = $request->objective;
            $project->venue = $request->venue;
            $project->category = $request->category;
            $project->budget = $request->budget ?? 0;
            $project->proposed_by = $request->proposed_by;
            $project->start_date = $request->start_date;
            $project->end_date = $request->end_date;
            $project->status = $request->status ?? 'Draft';
            $project->approval_status = $request->approval_status ?? 'Draft';
            $project->archive = 0;
            $project->is_initial = $request->is_initial ?? 0;
            
            // Handle file upload
            if ($request->hasFile('project_proof')) {
                $file = $request->file('project_proof');
                $fileName = time() . '_' . $file->getClientOriginalName();
                
                // Store the file
                $filePath = Storage::disk('public')->putFileAs('project_proofs', $file, $fileName);
                $project->project_proof = $filePath;
            }
            
            $project->created_at = now();
            $project->updated_at = now();
            
            $project->save();

            // Create an initial baseline ledger entry when project starts with budget.
            if ((float) ($project->budget ?? 0) > 0) {
                LedgerEntry::create([
                    'id' => (string) Str::uuid(),
                    'project_id' => $project->id,
                    'type' => 'Initial',
                    'amount' => (float) $project->budget,
                    'budget_breakdown' => json_encode([]),
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
            }
            
            // Return the project with the file URL
            $project->project_proof_url = $project->project_proof ? Storage::url($project->project_proof) : null;
            
            return response()->json($project, 201);
        } catch (\Exception $e) {
            Log::error('Project creation failed: ' . $e->getMessage());
            return response()->json([
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
                'proposed_by' => 'sometimes|required|string',
                'start_date' => 'nullable|date',
                'end_date' => 'nullable|date|after_or_equal:start_date',
                'project_proof' => 'nullable|file|mimes:pdf,jpg,jpeg,png|max:10240',
            ]);
            
            // Update only fields that are provided
            if ($request->has('title')) $project->title = $request->title;
            if ($request->has('description')) $project->description = $request->description;
            if ($request->has('objective')) $project->objective = $request->objective;
            if ($request->has('venue')) $project->venue = $request->venue;
            if ($request->has('category')) $project->category = $request->category;
            if ($request->has('budget')) $project->budget = $request->budget;
            if ($request->has('proposed_by')) $project->proposed_by = $request->proposed_by;
            if ($request->has('start_date')) $project->start_date = $request->start_date;
            if ($request->has('end_date')) $project->end_date = $request->end_date;
            if ($request->has('status')) $project->status = $request->status;
            if ($request->has('approval_status')) $project->approval_status = $request->approval_status;
            if ($request->has('archive')) $project->archive = $request->archive;
            if ($request->has('note')) $project->note = $request->note;
            if ($request->has('approve_by')) $project->approve_by = $request->approve_by;
            
            $project->updated_at = now();
            
            // Handle file upload if new file is provided
            if ($request->hasFile('project_proof')) {
                // Delete old file if exists
                if ($project->project_proof && Storage::disk('public')->exists($project->project_proof)) {
                    Storage::disk('public')->delete($project->project_proof);
                }
                
                $file = $request->file('project_proof');
                $fileName = time() . '_' . $file->getClientOriginalName();
                $filePath = $file->storeAs('project_proofs', $fileName, 'public');
                $project->project_proof = $filePath;
            }
            
            $project->save();
            
            // Add file URL to response
            $project->project_proof_url = $project->project_proof ? Storage::url($project->project_proof) : null;
            
            return response()->json($project, 200);
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
            LedgerEntry::where('project_id', $id)
                ->update(['archive' => 1, 'updated_at' => now()]);
            
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
            
            // Update approval status to pending adviser approval
            // Keep the project status as is (Draft/Ongoing/Complete based on dates)
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
                        'rating' => (int) $r->rating_score,
                        'comment' => (string) ($r->comments ?? ''),
                        'created_at' => optional($r->created_at)->format('Y-m-d') ?? '',
                        'helpful' => (int) ($r->helpful_count ?? 0),
                    ];
                })->values();
            
            // Calculate statistics
            $total = $ratings->count();
            $average = $total > 0 ? round($ratings->avg('rating') * 2) / 2 : 0;
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
}