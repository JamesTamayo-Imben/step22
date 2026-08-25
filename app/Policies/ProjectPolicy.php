<?php

namespace App\Policies;

use App\Models\User;
use App\Models\CSG\Project;

class ProjectPolicy
{
    public function viewAny(?User $user): bool
    {
        return $user?->hasPermission('projects.view') ?: false;
    }

    public function view(?User $user, Project $project): bool
    {
        return $user?->hasPermission('projects.view') ?: false;
    }

    public function create(?User $user): bool
    {
        return $user?->hasPermission('projects.create') ?: false;
    }

    public function update(?User $user, Project $project): bool
    {
        if (!$user) return false;
        if ($user->role?->slug === 'superadmin') return true;
        if ($user->hasPermission('projects.edit')) {
            // CSG officers may only edit their own projects
            if ($user->role?->slug === 'csg') {
                return (string) $project->created_by === (string) $user->id;
            }
            return true;
        }
        return false;
    }

    public function delete(?User $user, Project $project): bool
    {
        if (!$user) return false;
        if ($user->role?->slug === 'superadmin') return true;
        if ($user->hasPermission('projects.delete')) {
            if ($user->role?->slug === 'csg') {
                return (string) $project->created_by === (string) $user->id;
            }
            return true;
        }
        return false;
    }

    public function approve(?User $user, Project $project): bool
    {
        return $user?->hasPermission('projects.approve') ?: false;
    }
}
