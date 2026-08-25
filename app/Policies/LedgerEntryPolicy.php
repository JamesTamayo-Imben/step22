<?php

namespace App\Policies;

use App\Models\User;
use App\Models\CSG\LedgerEntry;

class LedgerEntryPolicy
{
    public function viewAny(?User $user): bool
    {
        return $user?->hasPermission('ledger.view') ?: false;
    }

    public function view(?User $user, LedgerEntry $entry): bool
    {
        return $user?->hasPermission('ledger.view') ?: false;
    }

    public function create(?User $user): bool
    {
        return $user?->hasPermission('ledger.create') ?: false;
    }

    public function update(?User $user, LedgerEntry $entry): bool
    {
        if (!$user) return false;
        if ($user->role?->slug === 'superadmin') return true;
        if ($user->hasPermission('ledger.edit')) {
            if ($user->role?->slug === 'csg') {
                return (string) $entry->project?->created_by === (string) $user->id;
            }
            return true;
        }
        return false;
    }

    public function delete(?User $user, LedgerEntry $entry): bool
    {
        if (!$user) return false;
        if ($user->role?->slug === 'superadmin') return true;
        if ($user->hasPermission('ledger.delete')) {
            if ($user->role?->slug === 'csg') {
                return (string) $entry->project?->created_by === (string) $user->id;
            }
            return true;
        }
        return false;
    }

    public function uploadProof(?User $user, LedgerEntry $entry): bool
    {
        if (!$user) return false;
        if ($user->role?->slug === 'superadmin') return true;
        if ($user->hasPermission('ledger.edit')) {
            if ($user->role?->slug === 'csg') {
                return (string) $entry->project?->created_by === (string) $user->id;
            }
            return true;
        }
        return false;
    }
}
