<?php

namespace App\Http\Controllers\Adviser;

use App\Models\CSG\Meeting;
use App\Models\CSG\ProjectDateChangeRequest;
use App\Models\User;
use App\Models\User\LedgerEntry;
use App\Models\User\Project;
use Illuminate\Support\Facades\Auth;
use Inertia\Inertia;

class AdviserHistoryController extends AdviserApprovalController
{
    public function index()
    {
        // Fetch pending items
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

        // Fetch pending date change requests
        $pendingDateChanges = ProjectDateChangeRequest::query()
            ->where('approval_status', 'Pending Adviser Approval')
            ->with(['project', 'student.user'])
            ->orderByDesc('created_at')
            ->get()
            ->map(fn (ProjectDateChangeRequest $d) => $this->serializeDateChangeRequest($d, 'Pending Adviser Approval'));

        $meetings = $this->pendingMeetings()->map(fn (Meeting $m) => $this->serializeMeeting($m));

        // Fetch rejected items
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

        // Fetch rejected date change requests
        $rejectedDateChanges = ProjectDateChangeRequest::query()
            ->where('approval_status', 'Rejected')
            ->with(['project', 'student.user'])
            ->orderByDesc('updated_at')
            ->get()
            ->map(fn (ProjectDateChangeRequest $d) => $this->serializeDateChangeRequest($d, 'Rejected'));

        $rejectedMeetings = Meeting::query()
            ->where('archive', false)
            ->where('is_done', true)
            ->orderByDesc('updated_at')
            ->get()
            ->filter(function (Meeting $m) {
                return ($this->meetingMinutesMeta($m)['adviser_minutes_status'] ?? null) === 'rejected';
            })
            ->map(fn (Meeting $m) => $this->serializeMeeting($m, 'Rejected'));

        $rejectedItems = $rejectedProjects->concat($rejectedLedger)->concat($rejectedDateChanges)->concat($rejectedMeetings)->sortByDesc(fn ($i) => $i['submittedDate'] ?? '')->values();

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

        // Fetch approved date change requests
        $approvedDateChanges = ProjectDateChangeRequest::query()
            ->where('approval_status', 'Approved')
            ->with(['project', 'student.user'])
            ->orderByDesc('updated_at')
            ->get()
            ->map(fn (ProjectDateChangeRequest $d) => $this->serializeDateChangeRequest($d, 'Approved'));

        $approvedMeetings = Meeting::query()
            ->where('archive', false)
            ->where('is_done', true)
            ->orderByDesc('updated_at')
            ->get()
            ->filter(function (Meeting $m) {
                return ($this->meetingMinutesMeta($m)['adviser_minutes_status'] ?? null) === 'approved';
            })
            ->map(fn (Meeting $m) => $this->serializeMeeting($m, 'Approved'));

        $approvedItems = $approvedProjects->concat($approvedLedger)->concat($approvedDateChanges)->concat($approvedMeetings)->sortByDesc(fn ($i) => $i['submittedDate'] ?? '')->values();

        return Inertia::render('Adviser/History', [
            'pendingProjects' => $projects,
            'pendingLedger' => $ledgerRows,
            'pendingDateChanges' => $pendingDateChanges,
            'pendingMeetings' => $meetings,
            'approvedItems' => $approvedItems,
            'rejectedItems' => $rejectedItems,
        ]);
    }

    protected function serializeDateChangeRequest(ProjectDateChangeRequest $d, string $status): array
    {
        $projectTitle = $d->project?->title ?? 'Unknown Project';
        $studentName = $d->student?->user?->name ?? $d->student?->name ?? 'Unknown Student';

        return [
            'id' => $d->id,
            'title' => "Date Change Request - {$projectTitle}",
            'submittedBy' => $studentName,
            'submittedDate' => optional($d->created_at)->format('Y-m-d') ?? '',
            'status' => $status,
            'type' => 'date-change',
            'approvalType' => 'date-change',
            'description' => "Request to change project dates from {$d->proposed_start_date->format('M d, Y')} to {$d->proposed_end_date->format('M d, Y')}",
            'project' => $projectTitle,
            'currentStartDate' => $d->project?->start_date,
            'currentEndDate' => $d->project?->end_date,
            'proposedStartDate' => $d->proposed_start_date->format('Y-m-d'),
            'proposedEndDate' => $d->proposed_end_date->format('Y-m-d'),
            'reason' => $d->reason ?? 'No reason provided',
            'approvalNotes' => $d->approval_notes,
            'rejectionReason' => $d->rejection_reason,
            'created_at' => optional($d->created_at)->format('Y-m-d H:i:s') ?? 'N/A',
            'project_id' => $d->project_id,
        ];
    }
}
