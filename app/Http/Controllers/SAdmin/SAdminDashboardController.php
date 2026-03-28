<?php

namespace App\Http\Controllers\SAdmin;

use App\Http\Controllers\Controller;
use App\Models\AuditLog;
use App\Models\Role;
use App\Models\User;
use App\Models\User\LedgerEntry;
use App\Models\User\Project;
use Inertia\Inertia;

class SAdminDashboardController extends Controller
{
    public function index()
    {
        $totalUsers = User::query()->where('archive', false)->count();
        $activeRoles = Role::query()->count();
        $approvedProjects = Project::query()->where('archive', false)->where('approval_status', 'Approved')->count();
        $pendingApprovals = Project::query()
            ->where('archive', false)
            ->whereIn('approval_status', ['Pending Adviser Approval', 'Pending Approval'])
            ->count()
            + LedgerEntry::query()->where('approval_status', 'Pending Adviser Approval')->count();

        $recentAuditCount = AuditLog::query()->where('archive', false)->where('created_at', '>=', now()->subDays(7))->count();

        return Inertia::render('SAdmin/Dashboard', [
            'stats' => [
                'totalUsers' => $totalUsers,
                'activeRoles' => $activeRoles,
                'approvedProjects' => $approvedProjects,
                'pendingApprovals' => $pendingApprovals,
                'auditEventsWeek' => $recentAuditCount,
            ],
        ]);
    }
}
