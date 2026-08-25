<?php

namespace App\Policies;

use App\Models\User;
use App\Models\User\Rating;
use App\Models\CSG\Project;
use Illuminate\Support\Facades\Auth;

class RatingPolicy
{
    public function create(?User $user, Project $project = null): bool
    {
        if (!$user) return false;
        if (!$user->hasPermission('ratings.create')) return false;

        // If user already rated this project, deny
        if ($project) {
            $existing = \App\Models\Rating::where('project_id', $project->id)
                ->where('user_id', $user->id)
                ->first();
            if ($existing) return false;
        }

        return true;
    }

    public function viewAny(?User $user): bool
    {
        return $user?->hasPermission('ratings.view') ?: false;
    }

    public function view(?User $user, Rating $rating): bool
    {
        return $user?->hasPermission('ratings.view') ?: false;
    }
}
