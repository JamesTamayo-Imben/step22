<?php

namespace App\Http\Controllers\CSG;

use App\Http\Controllers\Controller;
use App\Models\CSG\LedgerEntry;
use App\Models\CSG\Meeting;
use App\Models\CSG\Project;
use App\Models\User\Rating;
use App\Support\ProjectBudgetCalculator;
use Illuminate\Support\Facades\Auth;
use Illuminate\Support\Facades\Redirect;
use Illuminate\Support\Facades\DB;
use Inertia\Inertia;

class CSGDashboardController extends Controller
{
    public function index()
    {
        // Role-based authorization: Only CSG Officer users can access this
        $user = Auth::user();
        if (!$user || !$user->hasRole('CSG Officer')) {
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

        $stats = $this->computeCSGDashboardStats();
        
        // Return dashboard data with the initial page so it is available immediately.
        return Inertia::render('CSG/Dashboard', [
            'statistics' => $stats['statistics'],
            'projects' => $this->getProjectsData(),
            'recommendedProjects' => $this->getRecommendedProjects(),
            'recentLedgerEntries' => $this->getLedgerEntriesData(),
            'upcomingMeetings' => $this->getMeetingsData(),
        ]);
    }

    private function getProjectsData()
    {
        $projects = Project::where('archive', 0)
            ->latest('created_at')
            ->take(4)
            ->get()
            ->map(function ($project) {
                $ledger = LedgerEntry::where('project_id', $project->id)
                    ->selectRaw("SUM(CASE WHEN type = 'Income' THEN amount ELSE 0 END) as income")
                    ->selectRaw("SUM(CASE WHEN type = 'Expense' THEN amount ELSE 0 END) as expense")
                    ->first();

                $income = $ledger->income ? (float) $ledger->income : 0;
                $expense = $ledger->expense ? (float) $ledger->expense : 0;
                $progress = match ($project->status) {
                    'Completed' => 100,
                    'Ongoing' => 70,
                    'Planning', 'Draft' => 15,
                    default => 40,
                };

                return [
                    'id' => $project->id,
                    'title' => $project->title,
                    'status' => $project->status ?? 'Draft',
                    'income' => $income,
                    'expense' => $expense,
                    'progress' => $progress,
                    'start_date' => optional($project->start_date)->format('M d, Y'),
                    'end_date' => optional($project->end_date)->format('M d, Y'),
                ];
            });

        return $projects;
    }

    private function getLedgerEntriesData()
    {
        $recentLedgerEntries = LedgerEntry::with('project')
            ->latest('created_at')
            ->take(5)
            ->get()
            ->map(function ($entry) {
                return [
                    'id' => $entry->id,
                    'desc' => $entry->project?->title ? $entry->project->title : $entry->description,
                    'title' => $entry->description,
                    'amount' => ($entry->type === 'Income' ? '+' : '-') . '₱' . number_format($entry->amount, 2),
                    'status' => $entry->approval_status ?: 'Draft',
                    'type' => strtolower($entry->type),
                ];
            });

        return $recentLedgerEntries;
    }

    private function getMeetingsData()
    {
        try {
            $now = now();
            $upcomingMeetings = Meeting::where('archive', false)
                ->where('is_done', false)
                ->orderBy('scheduled_date', 'desc') // Null values come last with DESC
                ->take(5)
                ->get();

            \Illuminate\Support\Facades\Log::info('🔍 Upcoming meetings query result:', [
                'count' => $upcomingMeetings->count(),
                'now' => $now,
                'meetings' => $upcomingMeetings->map(fn($m) => [
                    'title' => $m->title,
                    'scheduled_date' => $m->scheduled_date,
                    'date' => $m->date,
                    'time' => $m->time,
                ])->toArray(),
            ]);

            $mapped = $upcomingMeetings->map(function ($meeting) {
                return [
                    'id' => $meeting->id,
                    'title' => $meeting->title,
                    'date' => $meeting->date ?? 'No Date',
                    'time' => $meeting->time ?? 'No Time',
                    'attendees' => $meeting->expected_attendees ?? 0,
                    'is_done' => $meeting->is_done,
                    'archive' => $meeting->archive,
                ];
            })
            ->values()
            ->toArray();

            return $mapped;
        } catch (\Exception $e) {
            \Illuminate\Support\Facades\Log::error('❌ Error fetching upcoming meetings:', [
                'error' => $e->getMessage(),
                'trace' => $e->getTraceAsString(),
            ]);
            return [];
        }
    }

    private function computeCSGDashboardStats()
    {
        $activeProjectsCount = Project::where('archive', 0)->count();
        $pendingApprovalCount = Project::where('archive', 0)->where('approval_status', 'Pending Adviser Approval')->count();

        // Calculate average rating and CSAT
        $ratings = Rating::where('archive', false)->get();
        $averageRating = $ratings->count() > 0
    ? round(
        ($ratings->avg('satisfaction_rating')
        + $ratings->avg('completeness_rating')
        + $ratings->avg('engagement_rating')) / 3
    , 1)
    : 0.0;
        
        // CSAT: ratings of 3-5 stars = satisfied, 1-2 stars = not satisfied
        $satisfied = $ratings->filter(function ($r) {
    $avg = (($r->satisfaction_rating ?? 0)
          + ($r->completeness_rating ?? 0)
          + ($r->engagement_rating ?? 0)) / 3;
    return $avg >= 3;
})->count();
        $csatRate = $ratings->count() > 0 ? (int) round(100 * $satisfied / $ratings->count()) : 0;
        $totalRatings = $ratings->count();

        $ledgerSumsPerProject = LedgerEntry::select('project_id',
            DB::raw("SUM(CASE WHEN type = 'Income' THEN amount ELSE 0 END) as income"),
            DB::raw("SUM(CASE WHEN type = 'Expense' THEN amount ELSE 0 END) as expense")
        )
        ->where('approval_status', 'Approved')
        ->groupBy('project_id')
        ->get();

        $projectNetValues = $ledgerSumsPerProject->map(fn($row) => (float) $row->income - (float) $row->expense);
        $avgNetForProject = $projectNetValues->count() > 0
            ? round($projectNetValues->avg(), 2)
            : 0;

        $budgetMismatchCount = 0;
        $ledgerByProject = LedgerEntry::where('approval_status', 'Approved')
            ->where('archive', false)
            ->get()
            ->groupBy('project_id');

        foreach ($ledgerByProject as $projectId => $entries) {
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

                app(\App\Services\TamperingEmailService::class)->sendBudgetMismatchIfNew(
                    (string) $project->id,
                    (string) ($project->title ?? 'Unknown Project'),
                    (float) $displayBudget,
                    (float) $computedBudget,
                );
            }
        }

        return [
            'statistics' => [
                'activeProjects' => $activeProjectsCount,
                'pendingApprovals' => $pendingApprovalCount,
                'avgNetPerProject' => $avgNetForProject,
                'averageRating' => $averageRating,
                'csatRate' => $csatRate,
                'totalRatings' => $totalRatings,
                'isBudgetTampered' => $budgetMismatchCount > 0,
                'budgetMismatchCount' => $budgetMismatchCount,
            ],
        ];
    }

    private function getRecommendedProjects()
    {
        $projects = Project::where('archive', 0)
            ->where('approval_status', 'Approved')
            ->get();

        if ($projects->isEmpty()) {
            return [];
        }

        $projectIds = $projects->pluck('id');

        $ratingsByProject = Rating::where('archive', false)
            ->whereIn('project_id', $projectIds)
            ->get()
            ->groupBy('project_id');

        $ledgerSums = LedgerEntry::select('project_id',
                DB::raw("SUM(CASE WHEN type = 'Income' THEN amount ELSE 0 END) as income"),
                DB::raw("SUM(CASE WHEN type = 'Expense' THEN amount ELSE 0 END) as expense")
            )
            ->whereIn('project_id', $projectIds)
            ->where('approval_status', 'Approved')
            ->groupBy('project_id')
            ->get()
            ->keyBy('project_id');

        $now = now();

        return $projects
            ->filter(function ($project) use ($ratingsByProject, $now) {
                return $this->isCompletedProject($project, $now)
                    && $this->getAverageRatingValue($project, $ratingsByProject) > 0
                    && $this->getProjectMonthDistance($project, $now) <= 1;
            })
            ->map(function ($project) use ($ratingsByProject, $ledgerSums) {
                return [
                    'id' => $project->id,
                    'title' => $project->title,
                    'category' => $project->category,
                    'approval_status' => $project->approval_status,
                    'start_date' => $project->start_date,
                    'end_date' => $project->end_date,
                    'averageRating' => $this->getAverageRatingValue($project, $ratingsByProject),
                    'income' => (float) ($ledgerSums->get($project->id)->income ?? 0),
                ];
            })
            ->sort(function ($a, $b) {
                if ($b['averageRating'] !== $a['averageRating']) {
                    return $b['averageRating'] <=> $a['averageRating'];
                }
                return $b['income'] <=> $a['income'];
            })
            ->values()
            ->slice(0, 3)
            ->toArray();
    }

    private function isCompletedProject($project, $referenceDate)
    {
        if (! $project->start_date || ! $project->end_date) {
            return false;
        }

        try {
            $endDate = \Carbon\Carbon::parse($project->end_date)->endOfDay();
            return $referenceDate->gte($endDate);
        } catch (\Exception $e) {
            return false;
        }
    }

    private function getAverageRatingValue($project, $ratingsByProject)
    {
        $ratings = $ratingsByProject->get($project->id, collect());

        if ($ratings->isEmpty()) {
            return 0;
        }

        $sum = $ratings->reduce(function ($carry, $rating) {
            $score = ($rating->satisfaction_rating ?? 0)
                + ($rating->completeness_rating ?? 0)
                + ($rating->engagement_rating ?? 0);

            return $carry + ($score / 3);
        }, 0);

        return round($sum / $ratings->count(), 1);
    }

    private function getProjectMonthDistance($project, $referenceDate)
    {
        $dateValue = $project->start_date ?? $project->end_date;

        if (! $dateValue) {
            return PHP_INT_MAX;
        }

        try {
            $projectDate = \Carbon\Carbon::parse($dateValue);
        } catch (\Exception $e) {
            return PHP_INT_MAX;
        }

        $monthDiff = abs($projectDate->month - $referenceDate->month);
        return min($monthDiff, 12 - $monthDiff);
    }
}