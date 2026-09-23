<?php

namespace App\Http\Controllers\Adviser;

use App\Http\Controllers\Controller;
use App\Models\AuditLog;
use Illuminate\Support\Facades\Auth;
use App\Models\CSG\Meeting;
use App\Models\CSG\DateChangeRequest;
use App\Models\User;
use App\Models\User\LedgerEntry;
use App\Models\User\Project;
use App\Support\BlockchainService;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Log;
use Illuminate\Support\Facades\Storage;
use Illuminate\Support\Str;
use Illuminate\Validation\ValidationException;
use Inertia\Inertia;

//what line the ledger entry block the showing of initial, initial transfer, and transfer entries in the pending approval list for advisers
//in line 50, the ledger entries are filtered to exclude 'Initial' and 'Initial Transfer' types, and only include transfer entries that are either not in the 'Transfer' category or are of type 'Transfer'. This is done to ensure that advisers only see relevant ledger entries that require their approval, while excluding baseline and initial transfer entries that do not require action.

class AdviserApprovalController extends Controller
{
    public function index()
    {
        // Include CSG/submitted rows that still need adviser action (DB mixes approval_status and status)
        $projectQuery = Project::query()
            ->where('archive', false)
            ->whereIn('approval_status', [
                'Pending Adviser Approval',
                'Pending Approval',
            ])
            ->with(['student.user'])
            ->orderByDesc('updated_at');

        $projects = $projectQuery->get()->map(fn (Project $p) => $this->serializeProject($p, 'Pending Approval'));

        //this is for fetching all ledger entries that are pending adviser approval, excluding 'Initial' and 'Initial Transfer' types, and including transfer entries that are either not in the 'Transfer' category or are of type 'Transfer'
        $ledgerPending = LedgerEntry::query()
            ->where('approval_status', 'Pending Adviser Approval')
            ->whereNotIn('type', ['Initial', 'Initial Transfer', 'Transfer'])
            // ->where(function ($query) {
            //     $query->where('category', '!=', 'Transfer') //the catehory is not transfer, or the type is transfer, then include it in the results
            //         ->orWhere('type', 'Transfer');
            // })
            ->with('project')
            ->orderByDesc('updated_at')
            ->get();

        $ledgerRows = $ledgerPending->map(fn (LedgerEntry $e) => $this->serializeLedgerCard($e));

        $proofRows = $ledgerPending
            ->filter(fn (LedgerEntry $e) => ! empty($e->resolveLedgerProof()))
            ->map(fn (LedgerEntry $e) => $this->serializeProofCard($e))
            ->values();

        $meetings = $this->pendingMeetings()->map(fn (Meeting $m) => $this->serializeMeeting($m));

        $rejectedProjects = Project::query()
            ->where('archive', false)
            ->where('approval_status', 'Rejected')
            ->with(['student.user'])
            ->orderByDesc('updated_at')
            ->get()
            ->map(fn (Project $p) => $this->serializeProject($p, 'Rejected'));

            //this is a helper function to fetch all rejected ledger entries that are not of type Initial or Initial Transfer, and also include transfer entries that are either not in the Transfer category or are of type Transfer
        $rejectedLedger = LedgerEntry::query()
            ->where('approval_status', 'Rejected')
            ->whereNotIn('type', ['Initial', 'Initial Transfer', 'Transfer'])
            // ->where(function ($query) {
            //     $query->where('category', '!=', 'Transfer')
            //         ->orWhere('type', 'Transfer');
            // })
            ->with('project')
            ->orderByDesc('updated_at')
            ->get()
            ->map(fn (LedgerEntry $e) => $this->serializeLedgerCard($e, 'Rejected'));

        $rejectedMeetings = Meeting::query()
            ->where('archive', false)
            ->where('is_done', true)
            ->orderByDesc('updated_at')
            ->get()
            ->filter(function (Meeting $m) {
                return ($this->meetingMinutesMeta($m)['adviser_minutes_status'] ?? null) === 'rejected';
            })
            ->map(fn (Meeting $m) => $this->serializeMeeting($m, 'Rejected'));

        $rejectedDateChangeRequests = DateChangeRequest::where('status', 'rejected')
            ->with(['project:id,title', 'requestedByUser:id,name'])
            ->orderByDesc('updated_at')
            ->get()
            ->map(function ($dcr) {
                return [
                    'id' => $dcr->id,
                    'approvalType' => 'date_change',
                    'title' => 'Date Change Request - ' . $dcr->project?->title,
                    'project' => $dcr->project?->title,
                    'submittedBy' => $dcr->requestedByUser?->name ?? 'Unknown',
                    'submittedDate' => $dcr->created_at?->format('Y-m-d H:i:s'),
                    'status' => 'Rejected',
                    'description' => $dcr->reason,
                    'currentStartDate' => $dcr->current_start_date,
                    'currentEndDate' => $dcr->current_end_date,
                    'proposedStartDate' => $dcr->proposed_start_date,
                    'proposedEndDate' => $dcr->proposed_end_date,
                    'reason' => $dcr->reason,
                    'projectId' => $dcr->project_id,
                ];
            })->values();

        $rejectedItems = $rejectedProjects->concat($rejectedLedger)->concat($rejectedMeetings)->concat($rejectedDateChangeRequests)->sortByDesc(fn ($i) => $i['submittedDate'] ?? '')->values();

        // Fetch approved items
        $approvedProjects = Project::query()
            ->where('archive', false)
            ->where('approval_status', 'Approved')
            ->with(['student.user'])
            ->orderByDesc('updated_at')
            ->get()
            ->map(fn (Project $p) => $this->serializeProject($p, 'Approved'));

            //this is a helper function to fetch all approved ledger entries that are not of type Initial or Initial Transfer, and also include transfer entries that are either not in the Transfer category or are of type Transfer
        $approvedLedger = LedgerEntry::query()
            ->where('approval_status', 'Approved')
            ->whereNotIn('type', ['Initial', 'Initial Transfer', 'Transfer'])
            // ->where(function ($query) {
            //     $query->where('category', '!=', 'Transfer')
            //         ->orWhere('type', 'Transfer');
            // })
            ->with('project')
            ->orderByDesc('updated_at')
            ->get()
            ->map(fn (LedgerEntry $e) => $this->serializeLedgerCard($e, 'Approved'));

        $approvedMeetings = Meeting::query()
            ->where('archive', false)
            ->where('is_done', true)
            ->orderByDesc('updated_at')
            ->get()
            ->filter(function (Meeting $m) {
                return ($this->meetingMinutesMeta($m)['adviser_minutes_status'] ?? null) === 'approved';
            })
            ->map(fn (Meeting $m) => $this->serializeMeeting($m, 'Approved'));

        $approvedDateChangeRequests = DateChangeRequest::where('status', 'approved')
            ->with(['project:id,title', 'requestedByUser:id,name'])
            ->orderByDesc('updated_at')
            ->get()
            ->map(function ($dcr) {
                return [
                    'id' => $dcr->id,
                    'approvalType' => 'date_change',
                    'title' => 'Date Change Request - ' . $dcr->project?->title,
                    'project' => $dcr->project?->title,
                    'submittedBy' => $dcr->requestedByUser?->name ?? 'Unknown',
                    'submittedDate' => $dcr->created_at?->format('Y-m-d H:i:s'),
                    'status' => 'Approved',
                    'description' => $dcr->reason,
                    'currentStartDate' => $dcr->current_start_date,
                    'currentEndDate' => $dcr->current_end_date,
                    'proposedStartDate' => $dcr->proposed_start_date,
                    'proposedEndDate' => $dcr->proposed_end_date,
                    'reason' => $dcr->reason,
                    'projectId' => $dcr->project_id,
                ];
            })->values();

        $approvedItems = $approvedProjects->concat($approvedLedger)->concat($approvedMeetings)->concat($approvedDateChangeRequests)->sortByDesc(fn ($i) => $i['submittedDate'] ?? '')->values();

        // Fetch pending date change requests
        $dateChangeRequests = DateChangeRequest::where('status', 'pending')
            ->with(['project:id,title', 'requestedByUser:id,name'])
            ->orderByDesc('created_at')
            ->get()
            ->map(function ($dcr) {
                return [
                    'id' => $dcr->id,
                    'approvalType' => 'date_change',
                    'title' => 'Date Change Request - ' . $dcr->project?->title,
                    'project' => $dcr->project?->title,
                    'submittedBy' => $dcr->requestedByUser?->name ?? 'Unknown',
                    'submittedDate' => $dcr->created_at?->format('Y-m-d H:i:s'),
                    'status' => 'Pending Approval',
                    'description' => $dcr->reason,
                    'currentStartDate' => $dcr->current_start_date,
                    'currentEndDate' => $dcr->current_end_date,
                    'proposedStartDate' => $dcr->proposed_start_date,
                    'proposedEndDate' => $dcr->proposed_end_date,
                    'reason' => $dcr->reason,
                    'projectId' => $dcr->project_id,
                ];
            })->values();

        return Inertia::render('Adviser/Approvals', [
            'pendingProjects' => $projects,
            'pendingLedger' => $ledgerRows,
            'pendingProofs' => $proofRows,
            'pendingMeetings' => $meetings,
            'approvedItems' => $approvedItems,
            'rejectedItems' => $rejectedItems,
            'changeRequests' => $dateChangeRequests,
        ]);
    }

    public function approve(Request $request)
    {
        $data = $request->validate([
            'type' => 'required|in:project,ledger,proof,meeting,change_date,date_change',
            'id' => 'required|string',
            'notes' => 'nullable|string|max:2000',
            'approval_copy' => 'nullable|file|mimes:pdf|max:10240',
        ]);

        $user = Auth::user();
        $type = $data['type'] === 'date_change' ? 'change_date' : $data['type'];
        $required = match ($type) {
            'project', 'change_date' => 'projects.approve',
            'ledger' => 'ledger.approve',
            'proof' => 'proof-documents.approve',
            'meeting' => 'meetings.approve-minutes',
            default => null,
        };

        if ($required && !$user?->hasPermission($required)) {
            abort(403, 'You do not have permission to approve this item.');
        }

        $userId = Auth::id();

        match ($type) {
            'project' => $this->approveProject($data['id'], $userId, $data['notes'] ?? '', $request->file('approval_copy')),
            'ledger', 'proof' => $this->approveLedger($data['id'], $userId, $data['notes'] ?? ''),
            'meeting' => $this->approveMeeting($data['id'], $data['notes'] ?? ''),
            'change_date' => $this->approveDateChangeRequest($data['id'], $userId, $data['notes'] ?? ''),
        };

        return back();
    }

    public function reject(Request $request)
    {
        $data = $request->validate([
            'type' => 'required|in:project,ledger,proof,meeting,change_date,date_change',
            'id' => 'required|string',
            'reason' => 'required|string|min:3|max:2000',
        ]);

        $type = $data['type'] === 'date_change' ? 'change_date' : $data['type'];

        $user = Auth::user();
        $required = match ($type) {
            'project', 'change_date' => 'projects.reject',
            'ledger', 'proof' => 'ledger.reject',
            default => null,
        };

        if ($required && !$user?->hasPermission($required)) {
            abort(403, 'You do not have permission to reject this item.');
        }

        $userId = Auth::id();

        match ($type) {
            'project' => $this->rejectProject($data['id'], $data['reason'], $userId),
            'ledger', 'proof' => $this->rejectLedger($data['id'], $data['reason'], $userId),
            'meeting' => $this->rejectMeeting($data['id'], $data['reason']),
            'change_date' => $this->rejectDateChangeRequest($data['id'], $data['reason'], $userId),
        };

        return back();
    }

    private function approveProject(string $id, $userId, string $notes = '', $approvalCopy = null): void
    {
        $project = Project::where('id', $id)->where('archive', false)->firstOrFail();
        $wasApproved = $project->approval_status === 'Approved';

        if (! $approvalCopy) {
            throw ValidationException::withMessages([
                'approval_copy' => ['Please upload a PDF copy of the approved proposal before confirming approval.'],
            ]);
        }

        if ($approvalCopy) {
            $this->storeProjectProofOnInitialLedger($project, $approvalCopy);
        }

        
        $project->update([
            'approval_status' => 'Approved',
            'approve_by' => (string) $userId,
            'approved_at' => now(),
            'updated_by' => $userId,
            'note' => $notes,
        ]);

        // Create genesis block in blockchain for this project
        try {
            BlockchainService::createGenesisBlock($project->id, [
                'title' => $project->title,
                'description' => $project->description,
                'amount' => $project->budget,
            ]);
        } catch (\Exception $e) {
            Log::error('Failed to create genesis block for project: ' . $e->getMessage());
        }

        // Chain baseline and transfer ledger entries before syncing approval status.
        // syncProjectLedgerApprovalStatus marks Initial/Transfer rows as Approved first,
        // which previously prevented them from ever being added to the chain.
        if (! $wasApproved) {
            $initialLedger = $this->getInitialLedgerEntry($project);

            if ($initialLedger && ! BlockchainService::ledgerHasChainBlock($initialLedger->id, $project->id)) {
                try {
                    BlockchainService::addBlockToChain($initialLedger->id, $project->id, [
                        'description' => $initialLedger->description,
                        'amount' => $initialLedger->amount,
                        'type' => $initialLedger->type,
                    ]);
                } catch (\Exception $e) {
                    Log::error('Failed to add initial baseline block to chain: ' . $e->getMessage());
                }
            }

            $transferEntries = LedgerEntry::query()
                ->where('category', 'Transfer')
                ->where('archive', false)
                ->where(function ($query) use ($project) {
                    $query->where('project_id', $project->id)
                          ->orWhere('note', 'like', '%' . $project->id . '%');
                })
                ->get();

            foreach ($transferEntries as $transferEntry) {
                if (! BlockchainService::ledgerHasChainBlock($transferEntry->id, $transferEntry->project_id)) {
                    try {
                        BlockchainService::addBlockToChain($transferEntry->id, $transferEntry->project_id, [
                            'description' => $transferEntry->description,
                            'amount' => $transferEntry->amount,
                            'type' => $transferEntry->type,
                        ]);
                    } catch (\Exception $e) {
                        Log::error('Failed to add transfer ledger block to chain: ' . $e->getMessage());
                    }
                }

                $transferMetadata = json_decode($transferEntry->note, true);

                if (is_array($transferMetadata)) {
                    $sourceProjectId = $transferMetadata['transfer_source_project_id'] ?? null;
                    $destinationProjectId = $transferMetadata['transfer_destination_project_id'] ?? null;

                    if ($sourceProjectId && $destinationProjectId === $project->id && $transferEntry->project_id !== $project->id) {
                        $sourceProject = Project::where('archive', false)->find($sourceProjectId);
                        if ($sourceProject) {
                            $amount = (float) $transferEntry->amount;
                            $sourceProject->budget = max(0, (float) $sourceProject->budget - $amount);
                            $sourceProject->updated_by = $userId;
                            $sourceProject->updated_at = now();
                            $sourceProject->save();
                        }
                    }
                }
            }
        }

        $this->syncProjectLedgerApprovalStatus($project, 'Approved', $userId);

        $this->writeAudit(
            'Project Approved',
            $project->id,
            'project',
            'Approved project: '.($project->title ?? $project->id),
            'approvals',
            $userId
        );

        $this->createNotification(
            'Project Approved',
            sprintf(
                'Project "%s" has been approved.',
                $project->title ?? 'Untitled Project'
            ),
            'project',
            null
        );
    }

    private function rejectProject(string $id, string $reason, ?string $userId = null): void
    {
        $project = Project::where('id', $id)->where('archive', false)->firstOrFail();
        $userId = $userId ?? Auth::id();
        $project->update([
            'approval_status' => 'Rejected',
            'note' => $reason,
            'updated_by' => $userId,
        ]);

        $this->syncProjectLedgerApprovalStatus($project, 'Rejected', $userId);

        $this->writeAudit(
            'Project Rejected',
            $project->id,
            'project',
            'Rejected project: '.($project->title ?? $project->id).' — '.$reason,
            'approvals',
            $userId
        );

        $this->createNotification(
            'Project Rejected',
            sprintf(
                'Your project "%s" was rejected. Reason: %s',
                $project->title ?? 'Untitled Project',
                $reason
            ),
            'project',
            $project->created_by
        );
    }

    //approve change date request
    private function approveDateChangeRequest(string $id, $userId, string $notes = ''): void
    {
        $request = DateChangeRequest::where('id', $id)->firstOrFail();

        $request->update([
            'status' => 'approved',
            'reviewed_by' => $userId,
            'reviewed_at' => now(),
            'rejection_reason' => $notes,
        ]);

        $project = $request->project;
        if ($project) {
            $project->update([
                'start_date' => $request->proposed_start_date,
                'end_date' => $request->proposed_end_date,
                'updated_by' => $userId,
            ]);
        }

        $this->writeAudit(
            'Date Change Request Approved',
            $request->id,
            'date_change_request',
            'Approved date change request for project: '.($request->project?->title ?? $request->project_id),
            'approvals',
            $userId
        );

        $this->createNotification(
            'Date Change Request Approved',
            sprintf(
                'Your date change request for project "%s" has been approved.',
                $request->project?->title ?? 'Unknown Project'
            ),
            'date_change',
            $request->requested_by
        );

    }

    //reject change date request
    private function rejectDateChangeRequest(string $id, string $reason, ?string $userId = null): void
    {
        $request = DateChangeRequest::where('id', $id)->firstOrFail();
        $userId = $userId ?? Auth::id();
        $request->update([
            'status' => 'rejected',
            'reviewed_by' => $userId,
            'reviewed_at' => now(),
            'rejection_reason' => $reason,
        ]);

        $this->writeAudit(
            'Date Change Request Rejected',
            $request->id,
            'date_change_request',
            'Rejected date change request for project: '.($request->project?->title ?? $request->project_id).' — '.$reason,
            'approvals',
            $userId
        );

        $this->createNotification(
            'Date Change Request Rejected',
            sprintf(
                'Your date change request for project "%s" was rejected. Reason: %s',
                $request->project?->title ?? 'Unknown Project',
                $reason
            ),
            'date_change',
            $request->requested_by
        );
    }

    private function approveLedger(string $id, $userId, string $notes = ''): void
    {
        $entry = LedgerEntry::where('id', $id)->with('project')->firstOrFail();
        $wasApproved = $entry->approval_status === 'Approved';

        $entry->update([
            'approval_status' => 'Approved',
            'approved_by' => $userId,
            'approved_at' => now(),
            'updated_by' => $userId,
            'rejected_at' => null,
            'note' => $notes,
        ]);

        if (! $wasApproved && $entry->project) {
            $amount = (float) $entry->amount;
            if ($amount > 0) {
                // Transfer entries should be handled specially: the source entry (on the
                // project the funds are taken from) must have its budget decreased when
                // approved, while the destination entry should behave like an `Initial`
                // (no additional budget adjustment).
                if (($entry->category ?? '') === 'Transfer') {
                    $meta = json_decode($entry->note, true);
                    if (is_array($meta)) {
                        $sourceProjectId = $meta['transfer_source_project_id'] ?? null;
                        $destinationProjectId = $meta['transfer_destination_project_id'] ?? null;

                        // If this ledger entry belongs to the source project, deduct budget
                        if ($sourceProjectId && (string) $sourceProjectId === (string) $entry->project_id) {
                            $entry->project->budget = max(0, (float) $entry->project->budget - $amount);
                        }

                        // If entry belongs to destination project, treat like Initial (no change)
                    }
                } else {
                    // Non-transfer behaviour (legacy)
                    if ($entry->type === 'Expense') {
                        $entry->project->budget = (float) $entry->project->budget - $amount;
                    } elseif (in_array($entry->type, ['Income', 'Donation', 'Sponsorship'], true)) {
                        $entry->project->budget = (float) $entry->project->budget + $amount;
                    } elseif ($entry->type === 'Initial') {
                        // Initial entries are baseline snapshots and should not re-apply budget changes.
                        $entry->project->budget = (float) $entry->project->budget;
                    } elseif ($entry->type === 'Canvas') {
                        // For Canvas entries, we can decide how to adjust the budget. Assuming it adds to the budget:
                        $entry->project->budget = (float) $entry->project->budget;
                    }
                }

                $entry->project->save();
            }
        }

        // Add block to blockchain chain for this project
        try {
            BlockchainService::addBlockToChain($entry->id, $entry->project_id, [
                'description' => $entry->description,
                'amount' => $entry->amount,
                'type' => $entry->type,
            ]);
        } catch (\Exception $e) {
            Log::error('Failed to add ledger block to chain: ' . $e->getMessage());
        }

        $details = ($entry->description ?? '').' — '.$entry->project?->title;
        $this->writeAudit(
            'Ledger Entry Approved',
            $entry->id,
            'ledger_entry',
            $details,
            'ledger',
            $userId
        );

        $this->createNotification(
            'Ledger Entry Approved',
            sprintf(
                'Ledger entry for project "%s" has been approved.',
                $entry->project?->title ?? 'Unknown Project'
            ),
            'ledger',
            $entry->created_by ?? $entry->project?->created_by
        );
    }

    //this is a helper function to sync the approval status of all related ledger entries for a project when the project is approved or rejected
    private function syncProjectLedgerApprovalStatus(Project $project, string $approvalStatus, ?string $userId = null): void
    {
        $userId = $userId ?? Auth::id();
        $updatedAt = now();
        $payload = [
            'approval_status' => $approvalStatus,
            'updated_by' => $userId,
            'updated_at' => $updatedAt,
        ];

        if ($approvalStatus === 'Approved') {
            $payload['approved_by'] = $userId;
            $payload['approved_at'] = $updatedAt;
            $payload['rejected_at'] = null;
        } elseif ($approvalStatus === 'Rejected') {
            $payload['approved_by'] = null;
            $payload['approved_at'] = null;
            $payload['rejected_at'] = $updatedAt;
        } else {
            $payload['approved_by'] = null;
            $payload['approved_at'] = null;
            $payload['rejected_at'] = null;
        }

        $relatedEntries = LedgerEntry::query()
            ->where('archive', 0)
            ->where(function ($query) {
                $query->where('type', 'Initial')
                    ->orWhere('category', 'Transfer');
            })
            ->get();

        $relatedEntries->each(function (LedgerEntry $entry) use ($project, $payload): void {
            $noteData = json_decode((string) $entry->note, true);
            $isProjectMatch = (string) $entry->project_id === (string) $project->id;
            $isTransferMatch = is_array($noteData)
                && (
                    (string) ($noteData['transfer_source_project_id'] ?? '') === (string) $project->id
                    || (string) ($noteData['transfer_destination_project_id'] ?? '') === (string) $project->id
                );
            $isNoteMatch = str_contains((string) $entry->note, (string) $project->id);

            if ($isProjectMatch || $isTransferMatch || $isNoteMatch) {
                $entry->fill($payload);
                $entry->save();
            }
        });
    }

    private function rejectLedger(string $id, string $reason, ?string $userId = null): void
    {
        $entry = LedgerEntry::where('id', $id)->firstOrFail();
        $userId = $userId ?? Auth::id();
        $entry->update([
            'approval_status' => 'Rejected',
            'note' => $reason,
            'rejected_at' => now(),
            'updated_by' => $userId,
            'approved_by' => null,
            'approved_at' => null,
        ]);

        $this->writeAudit(
            'Ledger Entry Rejected',
            $entry->id,
            'ledger_entry',
            ($entry->description ?? '').' — '.$reason,
            'ledger',
            $userId
        );

        $this->createNotification(
            'Ledger Entry Rejected',
            sprintf(
                'Ledger entry for project "%s" was rejected. Reason: %s',
                $entry->project?->title ?? 'Unknown Project',
                $reason
            ),
            'ledger',
            $entry->created_by ?? $entry->project?->created_by
        );
    }

    private function approveMeeting(string $id, string $notes = ''): void
    {
        $meeting = Meeting::where('id', $id)->where('archive', false)->firstOrFail();
        $meta = $this->meetingMinutesMeta($meeting);
        $meta['adviser_minutes_status'] = 'approved';
        $meta['adviser_approval_notes'] = $notes;
        unset($meta['minutes_rejection_reason']);
        $meeting->action_items = json_encode($meta);
        $meeting->save();

        $this->writeAudit(
            'Meeting Minutes Approved',
            $meeting->id,
            'meeting',
            $meeting->title ?? $meeting->id,
            'approvals'
        );
    }

    private function rejectMeeting(string $id, string $reason): void
    {
        $meeting = Meeting::where('id', $id)->where('archive', false)->firstOrFail();
        $meta = $this->meetingMinutesMeta($meeting);
        $meta['adviser_minutes_status'] = 'rejected';
        $meta['minutes_rejection_reason'] = $reason;
        $meeting->action_items = json_encode($meta);
        $meeting->save();

        $this->writeAudit(
            'Meeting Minutes Rejected',
            $meeting->id,
            'meeting',
            ($meeting->title ?? $meeting->id).' — '.$reason,
            'approvals'
        );
    }

    protected function pendingMeetings()
    {
        return Meeting::query()
            ->where('archive', false)
            ->where('is_done', true)
            ->where(function ($q) {
                $q->whereNotNull('meeting_proof')->orWhereNotNull('minutes_content');
            })
            ->orderByDesc('updated_at')
            ->get()
            ->filter(function (Meeting $m) {
                $s = $this->meetingMinutesMeta($m)['adviser_minutes_status'] ?? null;

                return $s !== 'approved' && $s !== 'rejected';
            })
            ->values();
    }

    protected function meetingMinutesMeta(Meeting $m): array
    {
        $raw = $m->action_items;
        if (! $raw) {
            return [];
        }
        $j = json_decode($raw, true);

        return is_array($j) ? $j : [];
    }

    protected function userName(?string $userId): string
    {
        if (! $userId) {
            return 'Unknown';
        }
        $u = User::find($userId);

        return $u?->name ?? 'Unknown';
    }

    //this function stores the project proof file on the initial ledger entry and updates the project with the proof path and file hash
    // private function storeProjectProofOnInitialLedger(Project $project, $file, ?LedgerEntry $initialLedger = null): LedgerEntry
    // {
    //     $initialLedger = $initialLedger ?: $this->getInitialLedgerEntry($project);

    //     if (! $initialLedger) {
    //         $initialLedger = LedgerEntry::create([
    //             'id' => (string) Str::uuid(),
    //             'project_id' => $project->id,
    //             'type' => 'Initial',
    //             'amount' => (float) ($project->budget ?? 0),
    //             'budget_breakdown' => null,
    //             'description' => 'Initial project budget baseline',
    //             'category' => 'Project Budget Baseline',
    //             'approval_status' => 'Draft',
    //             'note' => 'Auto-generated baseline on project approval',
    //             'created_by' => Auth::id(),
    //             'updated_by' => Auth::id(),
    //             'archive' => 0,
    //             'created_at' => now(),
    //             'updated_at' => now(),
    //         ]);
    //     }

    //     $fileHash = hash_file('sha256', $file->getRealPath());
    //     $extension = $file->getClientOriginalExtension();
    //     $fileName = $fileHash . ($extension ? '.' . $extension : '');
    //     Storage::disk('public')->putFileAs('ledger_proofs', $file, $fileName);

    //     $proofPath = 'storage/ledger_proofs/' . $fileName;
    //     $initialLedger->ledger_proof = $proofPath;
    //     $initialLedger->file_content_hash = $fileHash;
    //     $initialLedger->save();

    //     $project->forceFill([
    //         'project_proof' => $proofPath,
    //         'file_content_hash' => $fileHash,
    //     ])->save();

    //     return $initialLedger;
    // }

    private function storeProjectProofOnInitialLedger(Project $project, $file, ?LedgerEntry $initialLedger = null): LedgerEntry
{
    $initialLedger = $initialLedger ?: $this->getInitialLedgerEntry($project);

    if (! $initialLedger) {
        $initialLedger = LedgerEntry::create([
            'id' => (string) Str::uuid(),
            'project_id' => $project->id,
            'type' => 'Initial',
            'amount' => (float) ($project->budget ?? 0),
            'budget_breakdown' => null,
            'description' => 'Initial project budget baseline',
            'category' => 'Project Budget Baseline',
            'approval_status' => 'Draft',
            'note' => 'Auto-generated baseline on project approval',
            'created_by' => Auth::id(),
            'updated_by' => Auth::id(),
            'archive' => 0,
            'created_at' => now(),
            'updated_at' => now(),
        ]);
    }

    $fileHash = hash_file('sha256', $file->getRealPath());
    $extension = $file->getClientOriginalExtension();
    $fileName = $fileHash . ($extension ? '.' . $extension : '');
    $proofPath = Storage::disk('supabase')->putFileAs('project_approval', $file, $fileName);

    // Only backfill ledger_proof if the baseline entry doesn't already have one
    // (covers the freshly-created case above). Never overwrite an existing one.
    if (empty($initialLedger->ledger_proof)) {
        $initialLedger->ledger_proof = $proofPath;
        $initialLedger->file_content_hash = $fileHash;
        $initialLedger->save();
    }

    $project->forceFill([
        'project_proof' => $proofPath,
        'file_content_hash' => $fileHash,
    ])->save();

    return $initialLedger;
}

    private function getInitialLedgerEntry(Project $project): ?LedgerEntry
    {
        return LedgerEntry::query()
            ->where('project_id', $project->id)
            ->where('archive', 0)
            ->where(function ($query) {
                $query->where('type', 'Initial')
                    ->orWhere(function ($subQuery) {
                        $subQuery->where('type', 'Initial Transfer')
                            ->where('category', 'Transfer');
                    });
            })
            ->orderByRaw("CASE WHEN type = 'Initial' THEN 0 ELSE 1 END")
            ->orderBy('created_at', 'asc')
            ->first();
    }

    private function getProjectProofPath(?Project $project): ?string
    {
        if (! $project) {
            return null;
        }

        if (! empty($project->project_proof)) {
            return $project->project_proof;
        }

        $initialLedger = $this->getInitialLedgerEntry($project);

        return $initialLedger?->ledger_proof ?: null;
    }

    protected function serializeProject(Project $p, string $status): array
    {
        $submittedBy = $this->userName($p->created_by)
            ?: ($p->student?->user?->name ?? $p->proposed_by ?? 'Unknown');

        $initialLedger = $p->ledgerEntries()
            ->where('type', 'Initial')
            ->where('archive', 0)
            ->orderBy('created_at', 'asc') 
            ->first();

        $proofPath = $p->project_proof ?: ($initialLedger?->ledger_proof ?? null);
        $proofUrl = $proofPath ? $this->temporaryProofUrl($proofPath) : null;

        return [
            'id' => $p->id,
            'title' => $p->title ?? 'Untitled',
            'submittedBy' => $submittedBy,
            'submittedDate' => optional($p->updated_at)->format('Y-m-d') ?? '',
            'status' => $status,
            'note' => $p->note ?? null,
            'category' => $p->category ?? '',
            'amount' => $p->budget !== null ? (float) $p->budget : null,
            'type' => 'project',
            'approvalType' => 'project',
            'objective' => $p->objective ?? 'Not specified',
            'description' => $p->description ?? 'No description provided',
            'venue' => $p->venue ?? 'Not specified',
            'start_date' => $p->start_date ?? null,
            'end_date' => $p->end_date ?? null,
            'created_by' => $this->userName($p->created_by),
            'created_at' => optional($p->created_at)->format('Y-m-d H:i:s') ?? 'N/A',
            'proposed_by' => $p->proposed_by ?? 'Not specified',
            'project_proof' => $proofUrl,
        ];
    }

    protected function serializeLedgerCard(LedgerEntry $e, ?string $forceStatus = null): array
{
    $status = $forceStatus ?? 'Pending Approval';
    if ($forceStatus === null && $e->approval_status === 'Rejected') {
        $status = 'Rejected';
    }

    $initialEntry = $e->project?->ledgerEntries()?->where('type', 'Initial')->where('archive', 0)->orderBy('created_at', 'asc')->first();
    $resolvedProof = $e->resolveLedgerProof();
    $projectProof = $initialEntry?->resolveLedgerProof() ?? $resolvedProof;
    $ledgerProof = $resolvedProof;

    // Decode budget_breakdown if it's a JSON string
    $budgetBreakdown = $e->budget_breakdown;
    if (is_string($budgetBreakdown)) {
        $budgetBreakdown = json_decode($budgetBreakdown, true) ?? [];
    }

    return [
        'id' => $e->id,
        'title' => $e->description ?? 'Ledger entry',
        'submittedBy' => $this->userName($e->created_by),
        'submittedDate' => optional($e->created_at)->format('Y-m-d') ?? '',
        'status' => $status === 'Rejected' ? 'Rejected' : 'Pending Approval',
        'note' => $e->note ?? null,
        'amount' => (float) $e->amount,
        'project' => $e->project?->title ?? '',
        'hash' => substr($e->project_id ?? $e->id, 0, 32),
        'type' => 'ledger',
        'approvalType' => 'ledger',
        'description' => $e->description ?? 'No description provided',
        'created_by' => $this->userName($e->created_by),
        'created_at' => optional($e->created_at)->format('Y-m-d H:i:s') ?? 'N/A',
        'entry_type' => $e->type ?? 'Expense', 
        'ledger_proof' => $ledgerProof,
        'project_proof' => $projectProof,
        'budget_breakdown' => $budgetBreakdown ?? [], // <-- ADD THIS
    ];
}

    private function temporaryProofUrl(?string $path): ?string
    {
        if (! $path) {
            return null;
        }

        $key = str_starts_with($path, 'storage/')
            ? substr($path, strlen('storage/'))
            : $path;

        if (filter_var($key, FILTER_VALIDATE_URL)) {
            return $key;
        }

        return Storage::disk('supabase')->temporaryUrl($key, now()->addMinutes(15));
    }

    private function serializeProofCard(LedgerEntry $e): array
    {
        $card = $this->serializeLedgerCard($e);
        $card['type'] = 'proof';
        $proofPath = $e->resolveLedgerProof();
        $card['title'] = basename($proofPath ?? 'proof');

        return $card;
    }

    protected function serializeMeeting(Meeting $m, ?string $forceStatus = null): array
    {
        $meta = $this->meetingMinutesMeta($m);
        $status = $forceStatus ?? (($meta['adviser_minutes_status'] ?? null) === 'rejected' ? 'Rejected' : 'Pending Approval');

        return [
            'id' => $m->id,
            'title' => ($m->title ?? 'Meeting').($m->minutes_file_name ? ' — Minutes' : ''),
            'submittedBy' => $m->student_id ?? 'Unknown',
            'submittedDate' => optional($m->updated_at)->format('Y-m-d') ?? '',
            'status' => $status,
            'type' => 'meeting',
        ];
    }

    private function writeAudit(string $action, ?string $actionableId, ?string $actionableType, string $details, string $module, ?string $userId = null): void
    {
        AuditLog::create([
            'id' => (string) Str::uuid(),
            'user_id' => $userId ?? Auth::id(),
            'actionable_id' => $actionableId,
            'actionable_type' => $actionableType,
            'action' => $action,
            'module' => $module,
            'details' => $details,
            'ip_address' => request()->ip(),
            'browser_info' => substr((string) request()->userAgent(), 0, 500),
            'archive' => 0,
        ]);
    }
}