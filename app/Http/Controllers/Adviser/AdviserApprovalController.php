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
use Illuminate\Support\Str;
use Inertia\Inertia;

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

        $ledgerPending = LedgerEntry::query()
            ->where('approval_status', 'Pending Adviser Approval')
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

        $rejectedLedger = LedgerEntry::query()
            ->where('approval_status', 'Rejected')
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

        $rejectedItems = $rejectedProjects->concat($rejectedLedger)->concat($rejectedMeetings)->sortByDesc(fn ($i) => $i['submittedDate'] ?? '')->values();

        // Fetch approved items
        $approvedProjects = Project::query()
            ->where('archive', false)
            ->where('approval_status', 'Approved')
            ->with(['student.user'])
            ->orderByDesc('updated_at')
            ->get()
            ->map(fn (Project $p) => $this->serializeProject($p, 'Approved'));

        $approvedLedger = LedgerEntry::query()
            ->where('approval_status', 'Approved')
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

        $approvedItems = $approvedProjects->concat($approvedLedger)->concat($approvedMeetings)->sortByDesc(fn ($i) => $i['submittedDate'] ?? '')->values();

        // Fetch pending date change requests
        $dateChangeRequests = \App\Models\CSG\DateChangeRequest::where('status', 'pending')
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
        ]);

        $userId = Auth::id();
        $type = $data['type'] === 'date_change' ? 'change_date' : $data['type'];

        match ($type) {
            'project' => $this->approveProject($data['id'], $userId, $data['notes'] ?? ''),
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

        match ($type) {
            'project' => $this->rejectProject($data['id'], $data['reason']),
            'ledger', 'proof' => $this->rejectLedger($data['id'], $data['reason']),
            'meeting' => $this->rejectMeeting($data['id'], $data['reason']),
            'change_date' => $this->rejectDateChangeRequest($data['id'], $data['reason']),
        };

        return back();
    }

    private function approveProject(string $id, $userId, string $notes = ''): void
    {
        $project = Project::where('id', $id)->where('archive', false)->firstOrFail();
        $wasApproved = $project->approval_status === 'Approved';
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

        // Approve and chain the initial baseline ledger when project is first approved.
        if (! $wasApproved) {
            $initialLedger = LedgerEntry::query()
                ->where('project_id', $project->id)
                ->where('type', 'Initial')
                ->where('archive', false)
                ->orderBy('created_at')
                ->first();

            if ($initialLedger && $initialLedger->approval_status !== 'Approved') {
                $initialLedger->update([
                    'approval_status' => 'Approved',
                    'approved_by' => $userId,
                    'approved_at' => now(),
                    'updated_by' => $userId,
                    'note' => $initialLedger->note ?: 'Auto-approved with project approval',
                ]);

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

            // Also automatically approve connected transfer ledger entries when the project is approved.
            $transferEntries = LedgerEntry::query()
                ->where('category', 'Transfer')
                ->where('archive', false)
                ->where(function ($query) use ($project) {
                    $query->where('project_id', $project->id)
                          ->orWhere('note', 'like', '%' . $project->id . '%');
                })
                ->get();

            foreach ($transferEntries as $transferEntry) {
                if ($transferEntry->approval_status === 'Approved') {
                    continue;
                }

                $transferMetadata = json_decode($transferEntry->note, true);

                $transferEntry->update([
                    'approval_status' => 'Approved',
                    'approved_by' => $userId,
                    'approved_at' => now(),
                    'updated_by' => $userId,
                    'rejected_at' => null,
                    'note' => 'Auto-approved with project approval',
                ]);

                try {
                    BlockchainService::addBlockToChain($transferEntry->id, $transferEntry->project_id, [
                        'description' => $transferEntry->description,
                        'amount' => $transferEntry->amount,
                        'type' => $transferEntry->type,
                    ]);
                } catch (\Exception $e) {
                    Log::error('Failed to add transfer ledger block to chain: ' . $e->getMessage());
                }

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

        $this->writeAudit(
            'Project Approved',
            $project->id,
            'project',
            'Approved project: '.($project->title ?? $project->id),
            'approvals'
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

    private function rejectProject(string $id, string $reason): void
    {
        $project = Project::where('id', $id)->where('archive', false)->firstOrFail();
        $project->update([
            'approval_status' => 'Rejected',
            'note' => $reason,
            'updated_by' => Auth::id(),
        ]);

        $this->writeAudit(
            'Project Rejected',
            $project->id,
            'project',
            'Rejected project: '.($project->title ?? $project->id).' — '.$reason,
            'approvals'
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
            'approved_by' => $userId,
            'approved_at' => now(),
            'updated_by' => $userId,
            'rejection_reason' => $notes,
        ]);

        $this->writeAudit(
            'Date Change Request Approved',
            $request->id,
            'date_change_request',
            'Approved date change request for project: '.($request->project?->title ?? $request->project_id),
            'approvals'
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
    private function rejectDateChangeRequest(string $id, string $reason): void
    {
        $request = DateChangeRequest::where('id', $id)->firstOrFail();
        $request->update([
            'status' => 'rejected',
            'rejected_by' => Auth::id(),
            'rejected_at' => now(),
            'updated_by' => Auth::id(),
            'rejection_reason' => $reason,
        ]);

        $this->writeAudit(
            'Date Change Request Rejected',
            $request->id,
            'date_change_request',
            'Rejected date change request for project: '.($request->project?->title ?? $request->project_id).' — '.$reason,
            'approvals'
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
            'ledger'
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

    private function rejectLedger(string $id, string $reason): void
    {
        $entry = LedgerEntry::where('id', $id)->firstOrFail();
        $entry->update([
            'approval_status' => 'Rejected',
            'note' => $reason,
            'rejected_at' => now(),
            'updated_by' => Auth::id(),
            'approved_by' => null,
            'approved_at' => null,
        ]);

        $this->writeAudit(
            'Ledger Entry Rejected',
            $entry->id,
            'ledger_entry',
            ($entry->description ?? '').' — '.$reason,
            'ledger'
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

    protected function serializeProject(Project $p, string $status): array
    {
        $submittedBy = $this->userName($p->created_by)
            ?: ($p->student?->user?->name ?? $p->proposed_by ?? 'Unknown');

        $initialLedger = $p->ledgerEntries()
            ->where('type', 'Initial')
            ->where('archive', 0)
            ->orderBy('created_at', 'asc') 
            ->first();

        $proofPath = $initialLedger?->ledger_proof ?? null;

        return [
            'id' => $p->id,
            'title' => $p->title ?? 'Untitled',
            'submittedBy' => $submittedBy,
            'submittedDate' => optional($p->updated_at)->format('Y-m-d') ?? '',
            'status' => $status,
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
            'project_proof' => $proofPath,
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

    private function writeAudit(string $action, ?string $actionableId, ?string $actionableType, string $details, string $module): void
    {
        AuditLog::create([
            'id' => (string) Str::uuid(),
            'user_id' => Auth::id(),
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