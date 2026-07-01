<?php

namespace App\Http\Controllers\Adviser;

use App\Http\Controllers\Controller;
use App\Models\User\Project;
use App\Models\User\Rating;
use Carbon\Carbon;
use Inertia\Inertia;

class AdviserRatingsController extends Controller
{
    public function index()
    {
        $approvedProjectIds = Project::query()
            ->where('archive', false)
            ->where('approval_status', 'Approved')
            ->pluck('id');

        $ratings = Rating::query()
            ->where('archive', false)
            ->whereIn('project_id', $approvedProjectIds)
            ->with(['project:id,title', 'user:id,name'])
            ->orderByDesc('created_at')
            ->get();

        $byProject = $ratings->groupBy('project_id');

        $projectSummaries = Project::query()
            ->whereIn('id', $approvedProjectIds)
            ->get()
            ->map(function (Project $project) use ($byProject) {
                $rows  = $byProject->get($project->id, collect());
                $total = $rows->count();

                $avg = $total > 0 ? round(
                    ($rows->avg('satisfaction_rating') +
                     $rows->avg('engagement_rating') +
                     $rows->avg('completeness_rating')) / 3, 2
                ) : 0.0;

                $distribution = [5 => 0, 4 => 0, 3 => 0, 2 => 0, 1 => 0];
                foreach ($rows as $row) {
                    $s = (int) round(
                        ((float) $row->satisfaction_rating +
                         (float) $row->engagement_rating +
                         (float) $row->completeness_rating) / 3
                    );
                    if ($s >= 1 && $s <= 5) {
                        $distribution[$s]++;
                    }
                }

                $now    = Carbon::now();
                $recent = $rows->filter(fn ($r) => $r->created_at && $r->created_at->gte($now->copy()->subDays(30)));
                $older  = $rows->filter(fn ($r) => $r->created_at &&
                    $r->created_at->lt($now->copy()->subDays(30)) &&
                    $r->created_at->gte($now->copy()->subDays(60))
                );

                $avgRecent = $recent->count() ? round(
                    ($recent->avg('satisfaction_rating') +
                     $recent->avg('engagement_rating') +
                     $recent->avg('completeness_rating')) / 3, 2
                ) : null;

                $avgOlder = $older->count() ? round(
                    ($older->avg('satisfaction_rating') +
                     $older->avg('engagement_rating') +
                     $older->avg('completeness_rating')) / 3, 2
                ) : null;

                $trend      = 'stable';
                $trendValue = 0.0;
                if ($avgRecent !== null && $avgOlder !== null) {
                    $trendValue = round($avgRecent - $avgOlder, 2);
                    if ($trendValue > 0.05) {
                        $trend = 'up';
                    } elseif ($trendValue < -0.05) {
                        $trend = 'down';
                    }
                }

                return [
                    'id'                 => $project->id,
                    'projectName'        => $project->title ?? 'Untitled',
                    'averageRating'      => (float) $avg,
                    'satisfactionRating' => $total > 0 ? round((float) $rows->avg('satisfaction_rating'), 2) : 0.0,
                    'completenessRating' => $total > 0 ? round((float) $rows->avg('completeness_rating'), 2) : 0.0,
                    'engagementRating'   => $total > 0 ? round((float) $rows->avg('engagement_rating'), 2) : 0.0,
                    'totalRatings'       => $total,
                    'trend'              => $trend,
                    'trendValue'         => abs($trendValue),
                    'ratingDistribution' => $distribution,
                ];
            })
            ->sortByDesc('totalRatings')
            ->values();

        $studentRatings = $ratings->map(function (Rating $r) {
            return [
                'id'          => $r->id,
                'studentName' => $r->user?->name ?? 'Student',
                'projectName' => $r->project?->title ?? 'Project',
                'projectId'   => $r->project_id,
                'rating'      => round(
                    ((float) $r->satisfaction_rating +
                     (float) $r->engagement_rating +
                     (float) $r->completeness_rating) / 3, 1
                ),
                'comment'     => (string) ($r->comments ?? ''),
                'date'        => optional($r->created_at)->format('Y-m-d') ?? '',
                'createdAt'   => optional($r->created_at)?->toIso8601String(),
                'helpful'     => (int) ($r->helpful_count ?? 0),
            ];
        })->values();

        // Overall average across all three sub-ratings
        $overallAvg = $ratings->count() ? round(
            ($ratings->avg('satisfaction_rating') +
             $ratings->avg('completeness_rating') +
             $ratings->avg('engagement_rating')) / 3, 2
        ) : 0.0;

        // CSAT: 3-5 stars = satisfied (same logic as CSGRatingsController)
        $satisfied      = $ratings->whereIn('satisfaction_rating', [3, 4, 5])->count();
        $notSatisfied   = $ratings->whereIn('satisfaction_rating', [1, 2])->count();
        $satisfactionRate = $ratings->count()
            ? (int) round(100 * $satisfied / $ratings->count())
            : 0;

        return Inertia::render('Adviser/Ratings', [
            'projectSummaries' => $projectSummaries,
            'studentRatings'   => $studentRatings,
            'kpi'              => [
                'overallAverage'          => (float) $overallAvg,
                'totalRatings'            => $ratings->count(),
                'projectCountWithRatings' => $byProject->count(),
                'satisfactionRate'        => $satisfactionRate,
            ],
        ]);
    }
}