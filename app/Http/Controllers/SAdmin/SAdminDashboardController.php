<?php

namespace App\Http\Controllers\SAdmin;

use App\Http\Controllers\Controller;
use App\Models\AuditLog;
use App\Models\Role;
use App\Models\StudentCsgOfficer;
use App\Models\TeacherAdviser;
use App\Models\User;
use App\Models\User\LedgerEntry;
use App\Models\User\Project;
use Inertia\Inertia;

class SAdminDashboardController extends Controller
{
    public function index()
    {
        $totalUsers = User::query()->where('archive', false)->count();
        $activeRoles = Role::query()->whereNotIn('name', ['Student'])->count();
        $approvedProjects = Project::query()->where('archive', false)->where('approval_status', 'Approved')->count();
        $pendingApprovals = Project::query()
            ->where('archive', false)
            ->whereIn('approval_status', ['Pending Adviser Approval', 'Pending Approval'])
            ->count()
            + LedgerEntry::query()->where('approval_status', 'Pending Adviser Approval')->count();

        $recentAuditCount = AuditLog::query()->where('archive', false)->where('created_at', '>=', now()->subDays(7))->count();

        // Project status breakdown for pie chart
        $projectStatuses = Project::query()
            ->where('archive', false)
            ->selectRaw('approval_status, COUNT(*) as count')
            ->groupBy('approval_status')
            ->pluck('count', 'approval_status')
            ->toArray();

        $projectStatusChart = [
            ['name' => 'Approved', 'value' => $projectStatuses['Approved'] ?? 0],
            ['name' => 'Pending Adviser', 'value' => $projectStatuses['Pending Adviser Approval'] ?? 0],
            ['name' => 'Pending Approval', 'value' => $projectStatuses['Pending Approval'] ?? 0],
            ['name' => 'Rejected', 'value' => $projectStatuses['Rejected'] ?? 0],
        ];

        // Audit activity by day (last 7 days)
        $auditByDay = [];
        for ($i = 6; $i >= 0; $i--) {
            $date = now()->subDays($i)->format('Y-m-d');
            $count = AuditLog::query()
                ->where('archive', false)
                ->whereDate('created_at', $date)
                ->count();
            $auditByDay[] = [
                'date' => now()->subDays($i)->format('M d'),
                'count' => $count,
            ];
        }

        // Users by role
        $usersByRole = [];
        $roles = Role::query()->whereNotIn('name', ['Student'])->get();
        
        foreach ($roles as $role) {
            if ($role->name === 'Teacher') {
                // Combine Teacher and Student counts into Member
                $teacherCount = User::query()->where('archive', false)->where('role_id', $role->id)->count();
                $studentRole = Role::query()->where('name', 'Student')->first();
                $studentCount = 0;
                if ($studentRole) {
                    $studentCount = User::query()->where('archive', false)->where('role_id', $studentRole->id)->count();
                }
                $usersByRole[] = [
                    'name' => 'Member',
                    'value' => $teacherCount + $studentCount,
                ];
            } else {
                $usersByRole[] = [
                    'name' => $role->name,
                    'value' => User::query()->where('archive', false)->where('role_id', $role->id)->count(),
                ];
            }
        }

        // CSG and Adviser counts
        $totalCsgOfficers = StudentCsgOfficer::query()
            ->where('archive', false)
            ->where('is_csg', true)
            ->distinct('user_id')
            ->count('user_id');

        $totalAdvisers = TeacherAdviser::query()
            ->where('archive', false)
            ->where('is_adviser', true)
            ->distinct('user_id')
            ->count('user_id');

        // Ledger entries status
        $ledgerStatuses = LedgerEntry::query()
            ->selectRaw('approval_status, COUNT(*) as count')
            ->groupBy('approval_status')
            ->pluck('count', 'approval_status')
            ->toArray();

        $ledgerStatusChart = [
            ['name' => 'Approved', 'value' => $ledgerStatuses['Approved'] ?? 0],
            ['name' => 'Pending', 'value' => $ledgerStatuses['Pending Adviser Approval'] ?? 0],
            ['name' => 'Rejected', 'value' => $ledgerStatuses['Rejected'] ?? 0],
        ];

        return Inertia::render('SAdmin/Dashboard', [
            'stats' => [
                'totalUsers' => $totalUsers,
                'activeRoles' => $activeRoles,
                'approvedProjects' => $approvedProjects,
                'pendingApprovals' => $pendingApprovals,
                'auditEventsWeek' => $recentAuditCount,
                'totalCsgOfficers' => $totalCsgOfficers,
                'totalAdvisers' => $totalAdvisers,
            ],
            'charts' => [
                'projectStatus' => $projectStatusChart,
                'auditByDay' => $auditByDay,
                'usersByRole' => $usersByRole,
                'ledgerStatus' => $ledgerStatusChart,
            ],
        ]);
    }

    public function rolesPermissions()
    {
        // Get all users for the search modal
        $users = User::where('archive', false)
            ->where('status', 'active')
            ->select('id', 'name', 'email', 'phone')
            ->get()
            ->map(function ($user) {
                return [
                    'id' => $user->id,
                    'name' => $user->name,
                    'email' => $user->email,
                    'studentId' => $user->id,
                    'avatar' => strtoupper(substr($user->name, 0, 2)),
                    'currentRole' => $user->role?->name ?? 'Student',
                ];
            });

        // Get current CSG officers
        $csgOfficers = StudentCsgOfficer::with('user')
            ->where('archive', false)
            ->where('csg_is_active', true)
            ->get()
            ->groupBy('csg_position')
            ->map(function ($officers, $position) {
                $officer = $officers->first();
                return [
                    'id' => $officer->id ?? '',
                    'userId' => $officer->user_id ?? '',
                    'position' => $position,
                    'name' => $officer->user?->name ?? '',
                    'email' => $officer->user?->email ?? '',
                ];
            })
            ->values()
            ->toArray();

        // Ensure all positions are present
        $positions = [
            'President',
            'Vice President for Internal Affairs',
            'Vice President for External Affairs',
            'Secretary',
            'Auditor',
            'Press Relations Officer',
            'Business Manager',
            'Student Liaison',
            'ICDI IS Representative',
            'ICDI CS Representative',
            'IGDS SW Representative',
            'ION Representative',
            'IOM Representative'
        ];
        $councilOfficers = [];
        foreach ($positions as $pos) {
            $existing = collect($csgOfficers)->firstWhere('position', $pos);
            if ($existing) {
                $councilOfficers[] = $existing;
            } else {
                $councilOfficers[] = [
                    'position' => $pos,
                    'name' => '',
                    'userId' => '',
                    'email' => '',
                ];
            }
        }

        $csgOfficerCandidates = StudentCsgOfficer::with('user')
            ->where('archive', false)
            ->get()
            ->filter(fn ($officer) => $officer->user)
            ->map(function ($officer) {
                return [
                    'id' => $officer->user_id,
                    'studentId' => $officer->id,
                    'name' => $officer->user->name,
                    'email' => $officer->user->email,
                    'avatar' => strtoupper(substr($officer->user->name, 0, 2)),
                    'position' => $officer->csg_position,
                    'isCsg' => $officer->is_csg,
                    'isActive' => $officer->csg_is_active,
                ];
            })
            ->unique('id')
            ->values()
            ->toArray();

        // Predefined CSG positions
        $csgPositions = collect($positions)->map(function ($position) {
            return [
                'id' => $position,
                'name' => $position,
            ];
        })->toArray();

        // Get current advisers from teacher_adviser table
        $adviserRecords = TeacherAdviser::with('user')
            ->where('archive', false)
            ->where('is_adviser', true)
            ->get()
            ->map(function ($adviser) {
                return [
                    'id' => $adviser->id ?? '',
                    'userId' => $adviser->user_id ?? '',
                    'position' => 'Council Adviser',
                    'name' => $adviser->user?->name ?? '',
                    'email' => $adviser->user?->email ?? '',
                ];
            })
            ->toArray();

        // Ensure adviser positions are present (you can have multiple advisers)
        $adviserPositions = [
            'Council Adviser'
        ];

        $councilAdviser = [];
        foreach ($adviserPositions as $pos) {
            $existing = collect($adviserRecords)->firstWhere('position', $pos);
            if ($existing) {
                $councilAdviser[] = $existing;
            } else {
                $councilAdviser[] = [
                    'position' => $pos,
                    'name' => '',
                    'userId' => '',
                    'email' => '',
                ];
            }
        }

        // Get adviser candidates from teacher_adviser table
        $adviserCandidates = TeacherAdviser::with('user')
            ->where('archive', false)
            ->get()
            ->filter(fn ($adviser) => $adviser->user)
            ->map(function ($adviser) {
                return [
                    'id' => $adviser->user_id,
                    'teacherId' => $adviser->id,
                    'name' => $adviser->user->name,
                    'email' => $adviser->user->email,
                    'avatar' => strtoupper(substr($adviser->user->name, 0, 2)),
                    'isAdviser' => $adviser->is_adviser,
                ];
            })
            ->unique('id')
            ->values()
            ->toArray();

        return Inertia::render('SAdmin/RolesPermissions', [
            'users' => $users,
            'csgOfficerCandidates' => $csgOfficerCandidates,
            'councilOfficers' => $councilOfficers,
            'csgPositions' => $csgPositions,
            'adviserCandidates' => $adviserCandidates,
            'councilAdviser' => $councilAdviser,
        ]);
    }

    public function assignOfficer(\Illuminate\Http\Request $request)
    {
        $request->validate([
            'position' => 'required|string',
            'userId' => 'required|exists:users,id',
        ]);

        $position = $request->position;
        $userId = $request->userId;

        // Revert any existing officer in this position back to Member
        $existingOfficer = StudentCsgOfficer::where('csg_position', $position)
            ->where('archive', false)
            ->first();

        if ($existingOfficer && $existingOfficer->user_id !== $userId) {
            $existingOfficer->update([
                'csg_position' => 'Member',
                'csg_is_active' => false,
                'is_csg' => false,
            ]);
        }

        $candidate = StudentCsgOfficer::where('user_id', $userId)
            ->where('archive', false)
            ->first();

        if (! $candidate) {
            return response()->json(['message' => 'Selected student record not found.'], 422);
        }

        $candidate->update([
            'csg_position' => $position,
            'csg_is_active' => true,
            'is_csg' => true,
        ]);

        //update the user's role to CSG Officer
        $user = User::find($userId);
        if ($user) {
            // Get the CSG Officer role ID (csg officer role slug)
            $csgRole = Role::where('slug', 'csg')->first();
            if ($csgRole) {
                $user->update([
                    'role_id' => $csgRole->id,
                ]);
            }
        }

        // return response()->json(['message' => 'Officer assigned successfully']);
    }

    public function setCouncilTerm(\Illuminate\Http\Request $request)
    {
        $request->validate([
            'startDate' => 'required|date',
            'endDate' => 'required|date|after:startDate',
        ]);

        try {
            // Update all CSG members with the new council term dates
            $updated = StudentCsgOfficer::where('archive', false)
                ->where('csg_is_active', true)
                ->where('csg_position', '!=', 'Member')
                ->update([
                    'csg_term_start' => $request->startDate,
                    'csg_term_end' => $request->endDate,
                ]);

            return response()->json([
                'message' => "Council term updated for {$updated} officers",
                'updated' => $updated,
            ]);
        } catch (\Exception $e) {
            return response()->json([
                'message' => 'Failed to update council term: ' . $e->getMessage(),
            ], 500);
        }
    }

    public function getCouncilTerm()
    {
        // Get any active CSG officer to get the term dates
        // (assuming all officers have the same term dates)
        $officer = StudentCsgOfficer::where('archive', false)
            ->where('csg_is_active', true)
            ->where('csg_position', '!=', 'Member')
            ->whereNotNull('csg_term_start')
            ->whereNotNull('csg_term_end')
            ->first();
        
        if ($officer && $officer->csg_term_start && $officer->csg_term_end) {
            return response()->json([
                'startDate' => $officer->csg_term_start,
                'endDate' => $officer->csg_term_end,
            ]);
        }
        
        return response()->json([
            'startDate' => null,
            'endDate' => null,
        ]);
    }

    public function assignAdviser(\Illuminate\Http\Request $request)
    {
        $request->validate([
            'position' => 'required|string',
            'teacherId' => 'required|exists:teacher_adviser,user_id',
        ]);

        $position = $request->position;
        $teacherId = $request->teacherId;

        // Find the adviser record by user_id
        $adviser = TeacherAdviser::where('user_id', $teacherId)
            ->where('archive', false)
            ->first();

        if (! $adviser) {
            return response()->json(['message' => 'Adviser record not found.'], 422);
        }

        // Update the adviser record to set is_adviser to true
        $adviser->update([
            'is_adviser' => true,
        ]);

        // Update the user's role_id to admin (adviser) role
        $user = User::find($teacherId);
        if ($user) {
            // Get the admin/adviser role ID (admin role slug)
            $adminRole = \App\Models\Role::where('slug', 'admin')->first();
            if ($adminRole) {
                $user->update([
                    'role_id' => $adminRole->id,
                ]);
            }
        }

        // return response()->json(['message' => 'Adviser assigned successfully']);
    }

    public function removeOfficer(\Illuminate\Http\Request $request)
    {
        $request->validate([
            'userId' => 'required|exists:users,id',
        ]);

        $userId = $request->userId;

        // Find the CSG officer record
        $officer = StudentCsgOfficer::where('user_id', $userId)
            ->where('archive', false)
            ->first();

        if (! $officer) {
            return response()->json(['message' => 'Officer record not found.'], 422);
        }

        // Revert the officer back to Member role
        $officer->update([
            'csg_position' => 'Member',
            'csg_is_active' => false,
            'is_csg' => false,
        ]);

        // Revert the user's role back to student role
        $user = User::find($userId);
        if ($user) {
            // Get the student role ID (student role slug)
            $studentRole = Role::where('slug', 'student')->first();
            if ($studentRole) {
                $user->update([
                    'role_id' => $studentRole->id,
                ]);
            }
        }

        // return response()->json(['message' => 'Officer removed successfully']);
    }

    public function removeAdviser(\Illuminate\Http\Request $request)
    {
        $request->validate([
            'teacherId' => 'required|exists:teacher_adviser,user_id',
        ]);

        $teacherId = $request->teacherId;

        // Find the adviser record by user_id
        $adviser = TeacherAdviser::where('user_id', $teacherId)
            ->where('archive', false)
            ->first();

        if (! $adviser) {
            return response()->json(['message' => 'Adviser record not found.'], 422);
        }

        // Update the adviser record to set is_adviser to false
        $adviser->update([
            'is_adviser' => false,
        ]);

        // Revert the user's role back to teacher role
        $user = User::find($teacherId);
        if ($user) {
            // Get the teacher role ID (teacher role slug)
            $teacherRole = Role::where('slug', 'teacher')->first();
            if ($teacherRole) {
                $user->update([
                    'role_id' => $teacherRole->id,
                ]);
            }
        }

        // return response()->json(['message' => 'Adviser removed successfully']);
    }
}
