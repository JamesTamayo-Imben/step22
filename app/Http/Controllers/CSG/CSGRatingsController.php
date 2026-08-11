<?php

namespace App\Http\Controllers\CSG;

use App\Http\Controllers\Controller;
use App\Models\User\Project;
use App\Models\User\Rating;
use App\Support\RatingKpiCalculator;
use Carbon\Carbon;
use Inertia\Inertia;

class CSGRatingsController extends Controller
{
    public function index()
    {
        $projects = Project::query()
            ->where('archive', false)
            ->where('approval_status', 'Approved')
            ->pluck('id');

        $ratings = Rating::query()
            ->where('archive', false)
            ->whereIn('project_id', $projects)
            ->with(['project:id,title', 'user:id,name'])
            ->orderByDesc('created_at')
            ->get();

        $byProject = $ratings->groupBy('project_id');

        $projectSummaries = $this->buildProjectSummaries($projects, $byProject);
        $recentComments   = $this->buildRecentComments($ratings);
        [$overallAvg, $csatRate, $satisfied, $notSatisfied] = $this->buildKpiStats($ratings);

        return Inertia::render('CSG/Ratings', [
            'projectSummaries' => $projectSummaries,
            'recentComments'   => $recentComments,
            'kpi'              => [
                'overallAverage'          => (float) $overallAvg,
                'totalRatings'            => $ratings->count(),
                'projectCountWithRatings' => $byProject->count(),
                'csatRate'                => $csatRate,
                'satisfied'               => $satisfied,
                'notSatisfied'            => $notSatisfied,
            ],
        ]);
    }

    /**
     * Get ratings data as JSON (for AJAX/API calls)
     */
    public function getRatingsData()
    {
        $projects = Project::query()
            ->where('archive', false)
            ->where('approval_status', 'Approved')
            ->pluck('id');

        $ratings = Rating::query()
            ->where('archive', false)
            ->whereIn('project_id', $projects)
            ->with(['project:id,title', 'user:id,name'])
            ->orderByDesc('created_at')
            ->get();

        $byProject = $ratings->groupBy('project_id');

        $projectSummaries = $this->buildProjectSummaries($projects, $byProject);
        $recentComments   = $this->buildRecentComments($ratings, 10);
        [$overallAvg, $csatRate, $satisfied, $notSatisfied] = $this->buildKpiStats($ratings);

        return response()->json([
            'projectSummaries' => $projectSummaries,
            'recentComments'   => $recentComments,
            'kpi'              => [
                'overallAverage'          => (float) $overallAvg,
                'totalRatings'            => $ratings->count(),
                'projectCountWithRatings' => $byProject->count(),
                'csatRate'                => $csatRate,
                'satisfied'               => $satisfied,
                'notSatisfied'            => $notSatisfied,
            ],
        ]);
    }

    // -------------------------------------------------------------------------
    // Private helpers (eliminates duplication between index & getRatingsData)
    // -------------------------------------------------------------------------

    private function buildProjectSummaries($projectIds, $byProject)
    {
        return Project::query()
            ->whereIn('id', $projectIds)
            ->get()
            ->map(function (Project $project) use ($byProject) {
                $rows  = $byProject->get($project->id, collect());
                $total = $rows->count();

                $avg = $total > 0 ? round(
                    ($rows->avg('satisfaction_rating') +
                     $rows->avg('engagement_rating') +
                     $rows->avg('completeness_rating')) / 3, 2
                ) : 0.0;

                // Distribution bucketed by rounded per-row average
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

                // CSAT: 3-5 stars = satisfied
                $satisfied    = $distribution[5] + $distribution[4] + $distribution[3];
                $notSatisfied = $distribution[2] + $distribution[1];
                $csat         = $total > 0 ? (int) round(100 * $satisfied / $total) : 0;

                return [
                    'id'                 => $project->id,
                    'projectName'        => $project->title ?? 'Untitled',
                    'averageRating'      => (float) $avg,
                    'satisfactionRating' => $total > 0 ? round((float) $rows->avg('satisfaction_rating'), 2) : 0.0,
                    'completenessRating' => $total > 0 ? round((float) $rows->avg('completeness_rating'), 2) : 0.0,
                    'engagementRating'   => $total > 0 ? round((float) $rows->avg('engagement_rating'), 2) : 0.0,
                    'totalRatings'       => $total,
                    'ratingDistribution' => $distribution,
                    'csat'               => $csat,
                    'satisfied'          => $satisfied,
                    'notSatisfied'       => $notSatisfied,
                ];
            })
            ->sortByDesc('totalRatings')
            ->values();
    }

    private function buildRecentComments($ratings, ?int $limit = null)
    {
        $collection = $ratings->sortByDesc('created_at');

        if ($limit) {
            $collection = $collection->take($limit);
        }

        return $collection->map(function (Rating $r) {
            $avg = round(
                ((float) $r->satisfaction_rating +
                 (float) $r->completeness_rating +
                 (float) $r->engagement_rating) / 3,
                1
            );

            return [
                'id'          => $r->id,
                'studentName' => $r->user?->name ?? 'Student',
                'projectName' => $r->project?->title ?? 'Project',
                'projectId'   => $r->project_id,
                'rating'      => $avg,
                'comment'     => (string) ($r->comments ?? ''),
                'date'        => optional($r->created_at)->format('Y-m-d') ?? '',
                'createdAt'   => optional($r->created_at)?->toIso8601String(),
                'helpful'     => (int) ($r->helpful_count ?? 0),
            ];
        })->values();
    }

    private function buildKpiStats($ratings): array
    {
        if ($ratings->count() === 0) {
            return [0.0, 0, 0, 0];
        }

        $overallAvg = round(
            ($ratings->avg('satisfaction_rating') +
             $ratings->avg('completeness_rating') +
             $ratings->avg('engagement_rating')) / 3, 2
        );

        // CSAT per-row: average of three sub-ratings >= 3 = satisfied
        $satisfied = $ratings->filter(function ($r) {
            $average = (
                (float) $r->satisfaction_rating +
                (float) $r->engagement_rating +
                (float) $r->completeness_rating
            ) / 3;

            return round($average) >= 3;
        })->count();

        $notSatisfied = $ratings->count() - $satisfied;
        $csatRate     = RatingKpiCalculator::calculateCsatRate($ratings);

        return [$overallAvg, $csatRate, $satisfied, $notSatisfied];
    }
}