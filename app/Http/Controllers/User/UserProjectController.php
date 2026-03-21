<?php

namespace App\Http\Controllers\User;

use App\Http\Controllers\Controller;
use App\Models\Project;
use App\Models\Rating;
use App\Models\User;
use Illuminate\Http\Request;
use Illuminate\Support\Str;
use Inertia\Inertia;

class UserProjectController extends Controller
{
    public function dashboard(Request $request)
    {
        $user = $this->resolveCurrentUser();

        return Inertia::render('User/Dashboard', [
            'projects' => $this->getProjects($user?->id),
            'userRatingMap' => $this->getUserRatingMap($user?->id),
            'page' => 'dashboard',
        ]);
    }

    public function index(Request $request)
    {
        $user = $this->resolveCurrentUser();

        return Inertia::render('User/Dashboard', [
            'projects' => $this->getProjects($user?->id),
            'userRatingMap' => $this->getUserRatingMap($user?->id),
            'page' => 'projects',
        ]);
    }

    public function show(Request $request, string $id)
    {
        $user = $this->resolveCurrentUser();

        $project = Project::query()
            ->where('archive', 0)
            ->with([
                'ratings' => function ($query) {
                    $query->where('archive', 0)->latest('created_at');
                },
                'ratings.user:id,name',
                'ledgerEntries' => function ($query) {
                    $query->latest('created_at');
                },
            ])
            ->withAvg(['ratings' => function ($query) {
                $query->where('archive', 0);
            }], 'rating_score')
            ->withCount(['ratings' => function ($query) {
                $query->where('archive', 0);
            }])
            ->findOrFail($id);

        $userRating = null;
        if ($user) {
            $userRating = $project->ratings->firstWhere('user_id', $user->id);
        }

        $ledgerEntries = $project->ledgerEntries->map(function ($entry) {
            return [
                'id' => $entry->id,
                'type' => $entry->type,
                'amount' => (float) ($entry->amount ?? 0),
                'budgetBreakdown' => (int) ($entry->budget_breakdown ?? 0),
                'description' => $entry->description,
                'category' => $entry->category,
                'ledgerProof' => $entry->ledger_proof,
                'approvalStatus' => $entry->approval_status ?: 'Draft',
                'note' => $entry->note,
                'approvedBy' => $entry->approved_by,
                'createdAt' => optional($entry->created_at)->format('Y-m-d H:i'),
                'approvedAt' => optional($entry->approved_at)->format('Y-m-d H:i'),
                'rejectedAt' => optional($entry->rejected_at)->format('Y-m-d H:i'),
            ];
        })->values();

        $proofDocuments = $project->ledgerEntries
            ->filter(fn ($entry) => !empty($entry->ledger_proof))
            ->map(function ($entry) {
                return [
                    'id' => $entry->id,
                    'fileName' => basename((string) $entry->ledger_proof),
                    'ledgerProof' => $entry->ledger_proof,
                    'linkedTransaction' => $entry->id,
                    'uploadDate' => optional($entry->created_at)->format('Y-m-d'),
                    'status' => $entry->approval_status ?: 'Draft',
                ];
            })->values();

        $statusTimeline = collect([
            [
                'id' => 'project-created',
                'label' => 'Project Created',
                'description' => 'Project created by CSG.',
                'date' => optional($project->created_at)->format('Y-m-d H:i'),
                'type' => 'project',
            ],
            [
                'id' => 'project-status',
                'label' => 'Project Status Updated',
                'description' => sprintf('Current status: %s / Approval: %s', $project->status ?: 'Draft', $project->approval_status ?: 'Pending'),
                'date' => optional($project->updated_at)->format('Y-m-d H:i'),
                'type' => 'project',
            ],
        ])->merge(
            $project->ledgerEntries->map(function ($entry) {
                return [
                    'id' => 'ledger-' . $entry->id,
                    'label' => 'Ledger Entry ' . ($entry->type ?: 'Entry'),
                    'description' => sprintf('%s - %s', $entry->description ?: 'No description', $entry->approval_status ?: 'Draft'),
                    'date' => optional($entry->created_at)->format('Y-m-d H:i'),
                    'type' => 'ledger',
                ];
            })
        )->sortByDesc('date')->values();

        return Inertia::render('User/Dashboard', [
            'projects' => $this->getProjects($user?->id),
            'project' => [
                'id' => $project->id,
                'title' => $project->title,
                'description' => $project->description,
                'category' => $project->category,
                'status' => $project->status ?: 'Draft',
                'approvalStatus' => $project->approval_status ?: 'Pending',
                'budget' => (float) ($project->budget ?? 0),
                'startDate' => optional($project->start_date)->format('Y-m-d'),
                'endDate' => optional($project->end_date)->format('Y-m-d'),
                'averageRating' => round((float) ($project->ratings_avg_rating_score ?? 0), 1),
                'ratingsCount' => (int) ($project->ratings_count ?? 0),
                'ratings' => $project->ratings->map(function ($rating) {
                    return [
                        'id' => $rating->id,
                        'rating' => (int) $rating->rating_score,
                        'comment' => $rating->comments,
                        'date' => optional($rating->created_at)->format('Y-m-d'),
                        'user' => [
                            'id' => $rating->user?->id,
                            'name' => $rating->user?->name ?? 'Unknown User',
                        ],
                    ];
                })->values(),
                'currentUserRating' => $userRating ? [
                    'rating' => (int) $userRating->rating_score,
                    'comment' => $userRating->comments,
                ] : null,
                'ledgerEntries' => $ledgerEntries,
                'proofDocuments' => $proofDocuments,
                'statusTimeline' => $statusTimeline,
            ],
            'userRatingMap' => $this->getUserRatingMap($user?->id),
            'projectId' => $id,
            'page' => 'project-details',
        ]);
    }

    public function upsertRating(Request $request, string $projectId)
    {
        $user = $this->resolveCurrentUser();
        if (!$user) {
            return response()->json(['message' => 'No user found for rating'], 422);
        }

        $validated = $request->validate([
            'rating' => ['required', 'integer', 'min:1', 'max:5'],
            'comment' => ['nullable', 'string', 'max:1000'],
        ]);

        $project = Project::query()->where('archive', 0)->findOrFail($projectId);

        $rating = Rating::query()->firstOrNew([
            'project_id' => $project->id,
            'user_id' => $user->id,
        ]);

        if (!$rating->exists) {
            $rating->id = (string) Str::uuid();
        }

        $rating->rating_score = $validated['rating'];
        $rating->comments = $validated['comment'] ?? null;
        $rating->archive = 0;
        $rating->save();

        return response()->json([
            'success' => true,
            'message' => $rating->wasRecentlyCreated ? 'Rating submitted successfully' : 'Rating updated successfully',
        ]);
    }

    private function getProjects(?string $userId)
    {
        $projects = Project::query()
            ->where('archive', 0)
            ->withAvg(['ratings' => function ($query) {
                $query->where('archive', 0);
            }], 'rating_score')
            ->withCount(['ratings' => function ($query) {
                $query->where('archive', 0);
            }])
            ->orderByDesc('created_at')
            ->get();

        return $projects->map(function ($project) {
            return [
                'id' => $project->id,
                'title' => $project->title,
                'category' => $project->category ?: 'General',
                'status' => $project->status ?: 'Draft',
                'description' => $project->description,
                'rating' => round((float) ($project->ratings_avg_rating_score ?? 0), 1),
                'ratingsCount' => (int) ($project->ratings_count ?? 0),
                'budget' => (float) ($project->budget ?? 0),
                'startDate' => optional($project->start_date)->format('Y-m-d'),
                'endDate' => optional($project->end_date)->format('Y-m-d'),
            ];
        })->values();
    }

    private function getUserRatingMap(?string $userId): array
    {
        if (!$userId) {
            return [];
        }

        return Rating::query()
            ->where('archive', 0)
            ->where('user_id', $userId)
            ->pluck('rating_score', 'project_id')
            ->map(function ($value) {
                return (int) $value;
            })
            ->toArray();
    }

    private function resolveCurrentUser(): ?User
    {
        if (auth()->check()) {
            return auth()->user();
        }

        return User::query()
            ->whereHas('role', function ($query) {
                $query->where('name', 'Student');
            })
            ->orderBy('created_at')
            ->first();
    }
}
