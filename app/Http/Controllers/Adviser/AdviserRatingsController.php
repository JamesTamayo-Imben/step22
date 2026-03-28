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
                $rows = $byProject->get($project->id, collect());
                $total = $rows->count();
                $avg = $total > 0 ? round($rows->avg('rating_score'), 2) : 0.0;
                $distribution = [5 => 0, 4 => 0, 3 => 0, 2 => 0, 1 => 0];
                foreach ($rows as $row) {
                    $s = (int) $row->rating_score;
                    if ($s >= 1 && $s <= 5) {
                        $distribution[$s]++;
                    }
                }

                $now = Carbon::now();
                $recent = $rows->filter(fn ($r) => $r->created_at && $r->created_at->gte($now->copy()->subDays(30)));
                $older = $rows->filter(fn ($r) => $r->created_at && $r->created_at->lt($now->copy()->subDays(30)) && $r->created_at->gte($now->copy()->subDays(60)));
                $avgRecent = $recent->count() ? round($recent->avg('rating_score'), 2) : null;
                $avgOlder = $older->count() ? round($older->avg('rating_score'), 2) : null;
                $trend = 'stable';
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
                    'id' => $project->id,
                    'projectName' => $project->title ?? 'Untitled',
                    'averageRating' => $total ? (float) $avg : 0.0,
                    'totalRatings' => $total,
                    'trend' => $trend,
                    'trendValue' => abs($trendValue),
                    'ratingDistribution' => $distribution,
                ];
            })
            ->sortByDesc('totalRatings')
            ->values();

        $studentRatings = $ratings->map(function (Rating $r) {
            return [
                'id' => $r->id,
                'studentName' => $r->user?->name ?? 'Student',
                'projectName' => $r->project?->title ?? 'Project',
                'projectId' => $r->project_id,
                'rating' => (int) $r->rating_score,
                'comment' => (string) ($r->comments ?? ''),
                'date' => optional($r->created_at)->format('Y-m-d') ?? '',
                'createdAt' => optional($r->created_at)?->toIso8601String(),
                'helpful' => (int) ($r->helpful_count ?? 0),
            ];
        })->values();

        $overallAvg = $ratings->count() ? round($ratings->avg('rating_score'), 2) : 0.0;
        $fourPlus = $ratings->where('rating_score', '>=', 4)->count();
        $satisfactionRate = $ratings->count() ? (int) round(100 * $fourPlus / $ratings->count()) : 0;

        return Inertia::render('Adviser/Ratings', [
            'projectSummaries' => $projectSummaries,
            'studentRatings' => $studentRatings,
            'kpi' => [
                'overallAverage' => (float) $overallAvg,
                'totalRatings' => $ratings->count(),
                'projectCountWithRatings' => $byProject->count(),
                'satisfactionRate' => $satisfactionRate,
            ],
        ]);
    }
}
