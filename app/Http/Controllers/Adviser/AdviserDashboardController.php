<?php

namespace App\Http\Controllers\Adviser;

use App\Http\Controllers\Controller;
use App\Models\AuditLog;
use App\Models\CSG\Meeting;
use App\Models\Student;
use App\Models\User;
use App\Models\User\LedgerEntry;
use App\Models\User\Project;
use App\Models\User\Rating;
use App\Support\ProjectBudgetCalculator;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Auth;
use Illuminate\Support\Facades\Redirect;
// use Illuminate\Support\Carbon;
// use Illuminate\Support\Facades\DB;
use Inertia\Inertia;

class AdviserDashboardController extends Controller
{
    public function index(Request $request)
    {
        // Role-based authorization: Only Admin/Adviser and Admin/SADU users can access this
        $user = Auth::user();
        if (!$user || (!$user->hasRole('Admin/Adviser') && !$user->hasRole('Admin/SADU'))) {
            // Redirect to appropriate dashboard based on role
            if ($user) {
               if ($user->hasRole('Admin/Adviser') || $user->hasRole('Admin/SADU')) {
                    return Redirect::route('adviser.dashboard');
                } elseif ($user->hasRole('Super Admin')) {
                    return Redirect::route('sadmin.dashboard');
                } elseif ($user->hasRole('Student') || $user->hasRole('Ordinary Teacher')) {
                    return Redirect::route('user.dashboard');
                }
            }
            return Redirect::route('login');
        }

        $pendingProjects = Project::query()
            ->where('archive', false)
            ->whereIn('approval_status', ['Pending Adviser Approval', 'Pending Approval'])
            ->count();

              $pendingLedger = LedgerEntry::query()
            ->where('archive', false)
            ->whereIn('approval_status', ['Pending Adviser Approval', 'Pending Approval'])
            ->count();

        $activeCsgCount = Student::where('is_csg', true)->where('csg_is_active', true)->where('archive', false)->count();

        $pendingMeetings = Meeting::query()
            ->where('archive', false)
            ->where('is_done', true)
            ->where(function ($q) {
                $q->whereNotNull('meeting_proof')->orWhereNotNull('minutes_content');
            })
            ->get()
            ->filter(function (Meeting $m) {
                $meta = json_decode($m->action_items ?? '', true);
                $s = is_array($meta) ? ($meta['adviser_minutes_status'] ?? null) : null;

                return $s !== 'approved' && $s !== 'rejected';
            })
            ->count();

        $pendingApprovalsTotal = $pendingProjects + $pendingLedger + $pendingMeetings;

        // Check for tampered ledger entries across all projects
        $tamperedCount = 0;
        $allLedgerEntries = LedgerEntry::query()
            ->with('project')
            ->where('archive', false)
            ->get();

        $projectIds = $allLedgerEntries->pluck('project_id')->unique();
        foreach ($projectIds as $projectId) {
            $verification = \App\Support\BlockchainService::verifyChain($projectId);
            if (isset($verification['tamperedBlocks']) && is_array($verification['tamperedBlocks'])) {
                $tamperedCount += count($verification['tamperedBlocks']);
            }
        }

        $budgetMismatchCount = 0;
        $approvedLedgerEntries = LedgerEntry::query()
            ->where('archive', false)
            ->where('approval_status', 'Approved')
            ->get()
            ->groupBy('project_id');

        foreach ($approvedLedgerEntries as $projectId => $entries) {
            $project = Project::query()->find($projectId);
            if (!$project) {
                continue;
            }

            if ($entries->isEmpty()) {
                continue;
            }

            $displayBudget = (float) ($project->budget ?? 0);
            $computedBudget = ProjectBudgetCalculator::fromLedgerEntries($entries);

            if (ProjectBudgetCalculator::hasMismatch($displayBudget, $computedBudget, true)) {
                $budgetMismatchCount++;
            }
        }

        // $ratingAvg = Rating::query()->where('archive', false)->avg('rating_score');
        // $ratingAvg = Rating::query()->where('archive', false)->avg('satisfaction_rating');
        // $avgRating = $ratingAvg !== null ? round((float) $ratingAvg, 2) : 0.0;

        $ratings = Rating::query()->where('archive', false)->get();

$avgRating = $ratings->count() > 0
    ? round(
        ($ratings->avg('satisfaction_rating')
        + $ratings->avg('completeness_rating')
        + $ratings->avg('engagement_rating')) / 3
    , 2)
    : 0.0;

        $recentActivity = AuditLog::query()
            ->with('user:id,name')
            ->orderByDesc('created_at')
            ->limit(5)
            ->get()
            ->map(function (AuditLog $log) {
                $action = strtolower((string) ($log->action ?? ''));

                return [
                    'action' => $log->action ?? 'Activity',
                    'time' => optional($log->created_at)->diffForHumans() ?? '',
                    'status' => str_contains($action, 'reject') ? 'rejected' : 'approved',
                ];
            });

        $queue = collect();

        foreach (LedgerEntry::with('project')->where('approval_status', 'Pending Adviser Approval')->orderByDesc('updated_at')->limit(2)->get() as $e) {
            $queue->push([
                'type' => 'Ledger Entry',
                'title' => $e->description ?: 'Ledger transaction',
                'amount' => $e->amount !== null ? '₱'.number_format((float) $e->amount, 2) : null,
                'submittedBy' => User::query()->find($e->created_by)?->name ?? 'CSG',
                'time' => optional($e->updated_at)->diffForHumans() ?? '',
                'priority' => 'high',
            ]);
        }

        foreach (Project::query()->where('archive', false)->whereIn('approval_status', ['Pending Adviser Approval', 'Pending Approval'])->orderByDesc('updated_at')->limit(2)->get() as $p) {
            if ($queue->count() >= 3) {
                break;
            }
            $queue->push([
                'type' => 'Project',
                'title' => $p->title ?: 'Project',
                'amount' => $p->budget !== null ? '₱'.number_format((float) $p->budget, 2) : null,
                'submittedBy' => User::query()->find($p->created_by)?->name ?? ($p->proposed_by ?? 'CSG'),
                'time' => optional($p->updated_at)->diffForHumans() ?? '',
                'priority' => 'medium',
            ]);
        }

        return Inertia::render('Adviser/Dashboard', [
            'stats' => [
                'pendingApprovals' => $pendingApprovalsTotal,
                // 'pendingProjects' => $pendingProjects,
                // 'pendingLedger' => $pendingLedger,
                'pendingMeetings' => $pendingMeetings,
                'avgRating' => $avgRating,
                'tamperedAlerts' => $tamperedCount,
                'activeCsgCount' => $activeCsgCount,
                'isBudgetTampered' => $budgetMismatchCount > 0,
                'budgetMismatchCount' => $budgetMismatchCount,
            ],
            'approvalQueue' => $queue->take(3)->values(),
            'recentActivity' => $recentActivity,
        ]);
    }
}
