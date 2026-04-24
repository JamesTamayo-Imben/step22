<?php

namespace App\Http\Controllers\SAdmin;

use App\Http\Controllers\Controller;
use App\Models\AuditLog;
use App\Models\CSG\LedgerEntry;
use App\Models\CSG\Meeting;
use App\Models\CSG\Project;
use Inertia\Inertia;

class SAdminArchivedItemsController extends Controller
{
    private function archivedByMap(array $ids, string $actionableType): array
    {
        if (empty($ids)) {
            return [];
        }

        return AuditLog::query()
            ->with('user:id,name')
            ->whereIn('actionable_id', $ids)
            ->where('actionable_type', $actionableType)
            ->where(function ($q) {
                $q->where('action', 'like', '%Archiv%')
                    ->orWhere('details', 'like', '%Archiv%');
            })
            ->orderByDesc('created_at')
            ->get()
            ->groupBy('actionable_id')
            ->map(function ($logs) {
                $latest = $logs->first();
                return $latest?->user?->name ?? 'Unknown';
            })
            ->toArray();
    }

    public function index()
    {
        $projectRows = Project::query()
            ->where('archive', 1)
            ->orderByDesc('updated_at')
            ->orderByDesc('created_at')
            ->get([
                'id',
                'title',
                'category',
                'approval_status',
                'status',
                'updated_at',
                'created_at',
            ]);

        $projectArchivedBy = $this->archivedByMap($projectRows->pluck('id')->all(), 'project');

        $archivedProjects = $projectRows
            ->map(function (Project $project) use ($projectArchivedBy) {
                return [
                    'id' => $project->id,
                    'title' => $project->title ?? 'Untitled Project',
                    'category' => $project->category ?? 'N/A',
                    'approvalStatus' => $project->approval_status ?? 'N/A',
                    'status' => $project->status ?? 'N/A',
                    'archivedAt' => optional($project->updated_at ?? $project->created_at)?->format('Y-m-d H:i:s'),
                    'archivedBy' => $projectArchivedBy[$project->id] ?? 'Unknown',
                ];
            })
            ->values();

        $ledgerRows = LedgerEntry::query()
            ->with('project:id,title')
            ->where('archive', 1)
            ->orderByDesc('updated_at')
            ->orderByDesc('created_at')
            ->get([
                'id',
                'project_id',
                'type',
                'amount',
                'category',
                'description',
                'approval_status',
                'updated_at',
                'created_at',
            ]);

        $ledgerArchivedBy = $this->archivedByMap($ledgerRows->pluck('id')->all(), 'ledger_entry');

        $archivedLedgerEntries = $ledgerRows
            ->map(function (LedgerEntry $entry) use ($ledgerArchivedBy) {
                return [
                    'id' => $entry->id,
                    'projectTitle' => $entry->project?->title ?? 'Unknown Project',
                    'type' => $entry->type ?? 'N/A',
                    'amount' => (float) ($entry->amount ?? 0),
                    'category' => $entry->category ?? 'N/A',
                    'description' => $entry->description ?? '',
                    'approvalStatus' => $entry->approval_status ?? 'N/A',
                    'archivedAt' => optional($entry->updated_at ?? $entry->created_at)?->format('Y-m-d H:i:s'),
                    'archivedBy' => $ledgerArchivedBy[$entry->id] ?? 'Unknown',
                ];
            })
            ->values();

        $meetingRows = Meeting::query()
            ->where('archive', true)
            ->orderByDesc('updated_at')
            ->orderByDesc('created_at')
            ->get([
                'id',
                'title',
                'scheduled_date',
                'is_done',
                'updated_at',
                'created_at',
            ]);

        $meetingArchivedBy = $this->archivedByMap($meetingRows->pluck('id')->all(), 'meeting');

        $archivedMeetings = $meetingRows
            ->map(function (Meeting $meeting) use ($meetingArchivedBy) {
                return [
                    'id' => $meeting->id,
                    'title' => $meeting->title ?? 'Untitled Meeting',
                    'scheduledDate' => optional($meeting->scheduled_date)?->format('Y-m-d H:i:s'),
                    'status' => $meeting->is_done ? 'Completed' : 'Scheduled',
                    'archivedAt' => optional($meeting->updated_at ?? $meeting->created_at)?->format('Y-m-d H:i:s'),
                    'archivedBy' => $meetingArchivedBy[$meeting->id] ?? 'Unknown',
                ];
            })
            ->values();

        return Inertia::render('SAdmin/ArchivedItems', [
            'archivedProjects' => $archivedProjects,
            'archivedLedgerEntries' => $archivedLedgerEntries,
            'archivedMeetings' => $archivedMeetings,
        ]);
    }
}
