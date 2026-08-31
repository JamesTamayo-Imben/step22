<?php

namespace App\Http\Controllers\SAdmin;

use App\Http\Controllers\Controller;
use App\Models\AuditLog;
use App\Models\CsgPosition;
use App\Models\Role;
use App\Models\StudentCsgOfficer;
use App\Models\TeacherAdviser;
use App\Models\User;
use App\Models\User\LedgerEntry;
use App\Models\User\Project;
use App\Services\RolePermissionService;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Auth;
use Illuminate\Support\Facades\Redirect;
use Illuminate\Support\Str;
use Inertia\Inertia;

class SAdminDashboardController extends Controller
{
    public function index(Request $request)
    {
        $user = Auth::user();
        if (!$user || !$user->hasRole('Super Admin')) {
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

        $totalUsers = User::query()->where('archive', false)->count();
        $activeRoles = Role::query()->whereNotIn('name', ['Student', 'Admin/SADU'])->count();
        $approvedProjects = Project::query()->where('archive', false)->where('approval_status', 'Approved')->count();
        $pendingApprovals = Project::query()
            ->where('archive', false)
            ->whereIn('approval_status', ['Pending Adviser Approval', 'Pending Approval'])
            ->count()
            + LedgerEntry::query()->where('approval_status', 'Pending Adviser Approval')->count();

        $recentAuditCount = AuditLog::query()->where('archive', false)->where('created_at', '>=', now()->subDays(7))->count();

        $projectStatuses = Project::query()
            ->where('archive', false)
            ->get(['status', 'approval_status'])
            ->map(function (Project $project) {
                $status = trim((string) ($project->approval_status ?: $project->status));

                return match (strtolower($status)) {
                    'approved' => 'Approved',
                    'pending adviser approval', 'pending approval', 'pending' => 'Pending Adviser',
                    'rejected' => 'Rejected',
                    default => $status !== '' ? 'Other' : 'Other',
                };
            })
            ->countBy()
            ->toArray();

        $projectStatusChart = [
            ['name' => 'Approved', 'value' => $projectStatuses['Approved'] ?? 0],
            ['name' => 'Pending Adviser', 'value' => $projectStatuses['Pending Adviser'] ?? 0],
            ['name' => 'Rejected', 'value' => $projectStatuses['Rejected'] ?? 0],
        ];

        $auditByDay = [];
        for ($i = 6; $i >= 0; $i--) {
            $day = now()->subDays($i);
            $date = $day->format('Y-m-d');
            $dayLogs = AuditLog::query()
                ->where('archive', false)
                ->whereDate('created_at', $date)
                ->get(['action']);
            $tamperingCount = $dayLogs->filter(fn ($log) => preg_match('/tamper|tampered|tampering/i', (string) $log->action))->count();
            $activityCount = $dayLogs->count() - $tamperingCount;

            $auditByDay[] = [
                'date' => $day->format('M d'),
                'count' => $dayLogs->count(),
            ];
        }

        $heatmapParam = $request->get('heatmap_month');
        try {
            $heatmapStart = $heatmapParam
                ? \Illuminate\Support\Carbon::createFromFormat('Y-m', $heatmapParam)->startOfMonth()
                : now()->startOfMonth();
        } catch (\Exception $e) {
            $heatmapStart = now()->startOfMonth();
        }
        $heatmapEnd = $heatmapStart->copy()->endOfMonth();
        $heatmapEntries = AuditLog::query()
            ->where('archive', false)
            ->whereBetween('created_at', [$heatmapStart->copy()->startOfDay(), $heatmapEnd->copy()->endOfDay()])
            ->get(['created_at', 'action']);
        $heatmapEventsByDate = [];
        foreach ($heatmapEntries as $log) {
            $date = optional($log->created_at)->format('Y-m-d');
            if (!$date) {
                continue;
            }
            $heatmapEventsByDate[$date] ??= ['tampering' => 0, 'activity' => 0];
            if (preg_match('/tamper|tampered|tampering|budget\s*mismatch/i', (string) $log->action)) {
                $heatmapEventsByDate[$date]['tampering']++;
            } else {
                $heatmapEventsByDate[$date]['activity']++;
            }
        }

        $auditHeatmap = [];
        for ($day = $heatmapStart->copy(); $day->lte($heatmapEnd); $day->addDay()) {
            $date = $day->format('Y-m-d');
            $events = $heatmapEventsByDate[$date] ?? ['tampering' => 0, 'activity' => 0];
            $auditHeatmap[] = [
                'date' => $date,
                'label' => $day->format('D'),
                'day' => (int) $day->format('j'),
                'weekday' => (int) $day->dayOfWeek,
                'tamperingCount' => $events['tampering'],
                'activityCount' => $events['activity'],
            ];
        }

        $usersByRole = [];
        $roles = Role::query()->whereNotIn('name', ['Student'])->get();
        
        foreach ($roles as $role) {
            if ($role->name === 'Teacher') {
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
                'auditHeatmap' => $auditHeatmap,
                'heatmapMonth' => $heatmapStart->format('Y-m'),
                'heatmapLabel' => $heatmapStart->format('F Y'),
                'prevHeatmapMonth' => $heatmapStart->copy()->subMonth()->format('Y-m'),
                'nextHeatmapMonth' => $heatmapStart->copy()->addMonth()->format('Y-m'),
                'canNavigateNext' => $heatmapStart->copy()->addMonth()->startOfMonth()->lte(now()->startOfMonth()),
                'usersByRole' => $usersByRole,
                'ledgerStatus' => $ledgerStatusChart,
            ],
        ]);
    }

    public function rolesPermissions()
    {
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

        $councilPositions = CsgPosition::orderBy('position_name')->get();
        $councilOfficers = [];
        foreach ($councilPositions as $pos) {
            $existing = collect($csgOfficers)->firstWhere('position', $pos->position_name);
            if ($existing) {
                $councilOfficers[] = array_merge($existing, [
                    'positionId' => $pos->id,
                ]);
            } else {
                $councilOfficers[] = [
                    'positionId' => $pos->id,
                    'position' => $pos->position_name,
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

        $csgAdviserRecords = TeacherAdviser::with('user')
            ->where('archive', false)
            ->where('is_adviser', true)
            ->whereHas('user', function ($q) {
                $q->whereHas('role', function ($r) {
                    $r->whereIn('slug', ['admin']);
                });
            })
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

        $councilAdviser = [];
        $existing = collect($csgAdviserRecords)->firstWhere('position', 'Council Adviser');
        if ($existing) {
            $councilAdviser[] = $existing;
        } else {
            $councilAdviser[] = [
                'position' => 'Council Adviser',
                'name' => '',
                'userId' => '',
                'email' => '',
            ];
        }

        $saduAdviserRecords = TeacherAdviser::with('user')
            ->where('archive', false)
            ->where('is_adviser', true)
            ->whereHas('user', function ($q) {
                $q->whereHas('role', function ($r) {
                    $r->where('slug', 'admin-sadu');
                });
            })
            ->get()
            ->map(function ($adviser) {
                return [
                    'id' => $adviser->id ?? '',
                    'userId' => $adviser->user_id ?? '',
                    'position' => 'SADU Admin',
                    'name' => $adviser->user?->name ?? '',
                    'email' => $adviser->user?->email ?? '',
                ];
            })
            ->toArray();

        $councilSaduAdviser = [];
        $existingSadu = collect($saduAdviserRecords)->firstWhere('position', 'SADU Admin');
        if ($existingSadu) {
            $councilSaduAdviser[] = $existingSadu;
        } else {
            $councilSaduAdviser[] = [
                'position' => 'SADU Admin',
                'name' => '',
                'userId' => '',
                'email' => '',
            ];
        }

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

        $permissionService = new RolePermissionService();
        $rolePermissionMatrix = $permissionService->buildMatrix();

        $superAdmins = User::with('role')
            ->where('archive', false)
            ->whereHas('role', fn ($q) => $q->where('slug', 'superadmin'))
            ->get()
            ->map(function ($user) {
                return [
                    'id' => $user->id,
                    'name' => $user->name,
                    'email' => $user->email,
                    'status' => $user->status,
                ];
            })
            ->values()
            ->toArray();

        $studentCount = User::query()
            ->where('archive', false)
            ->whereHas('role', fn ($q) => $q->where('slug', 'student'))
            ->count();

        $teacherCount = User::query()
            ->where('archive', false)
            ->whereHas('role', fn ($q) => $q->where('slug', 'teacher'))
            ->count();

        return Inertia::render('SAdmin/RolesPermissions', [
            'users' => $users,
            'csgOfficerCandidates' => $csgOfficerCandidates,
            'councilOfficers' => $councilOfficers,
            'adviserCandidates' => $adviserCandidates,
            'councilAdviser' => $councilAdviser,
            'councilSaduAdviser' => $councilSaduAdviser,
            'rolePermissionMatrix' => $rolePermissionMatrix,
            'roleOptions' => RolePermissionService::roleOptions(),
            'superAdmins' => $superAdmins,
            'studentCount' => $studentCount,
            'teacherCount' => $teacherCount,
        ]);
    }

    public function updateRolePermission(Request $request)
    {
        $validated = $request->validate([
            'roleId' => 'required|exists:roles,id',
            'permissionId' => 'required|exists:permission,id',
            'enabled' => 'required|boolean',
            'positionId' => 'nullable|exists:position,id',
        ]);

        $service = new RolePermissionService();
        $service->updateRolePermission(
            $validated['roleId'],
            $validated['permissionId'],
            (bool) $validated['enabled'],
            $validated['positionId'] ?? null
        );

        return response()->json([
            'message' => 'Permission updated successfully',
            'matrix' => $service->buildMatrix(),
        ]);
    }

    public function saveRolePermissions(Request $request)
    {
        $validated = $request->validate([
            'roleId' => 'required|exists:roles,id',
            'permissionIds' => 'array',
            'permissionIds.*' => 'exists:permission,id',
            'positionId' => 'nullable|exists:position,id',
        ]);

        $service = new RolePermissionService();
        $service->syncRolePermissions(
            $validated['roleId'],
            $validated['permissionIds'] ?? [],
            $validated['positionId'] ?? null
        );

        return response()->json([
            'message' => 'Permissions saved successfully',
            'matrix' => $service->buildMatrix(),
        ]);
    }

    public function restoreRolePermissions(Request $request)
    {
        $validated = $request->validate([
            'roleId' => 'required|exists:roles,id',
            'positionId' => 'nullable|exists:position,id',
            'apply' => 'nullable|boolean',
        ]);

        $service = new RolePermissionService();
        $role = Role::findOrFail($validated['roleId']);
        $defaultIds = $service->defaultPermissionIdsForSlug($role->slug);

        // apply=true writes defaults to DB; otherwise return IDs for draft preview
        if (!empty($validated['apply'])) {
            $service->restoreDefaults(
                $validated['roleId'],
                $validated['positionId'] ?? null
            );
        }

        return response()->json([
            'message' => !empty($validated['apply'])
                ? 'Defaults restored and saved'
                : 'Defaults loaded for review',
            'permissionIds' => $defaultIds,
            'matrix' => $service->buildMatrix(),
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

        $user = User::find($userId);
        if ($user) {
            $csgRole = Role::where('slug', 'csg')->first();
            if ($csgRole) {
                $user->update(['role_id' => $csgRole->id]);
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

        $teacherId = $request->teacherId;

        $adviser = TeacherAdviser::where('user_id', $teacherId)
            ->where('archive', false)
            ->first();

        if (! $adviser) {
            return response()->json(['message' => 'Adviser record not found.'], 422);
        }

        $adviser->update(['is_adviser' => true]);

        $user = User::find($teacherId);
        if ($user) {
            $adminRole = \App\Models\Role::where('slug', 'admin')->first();
            if ($adminRole) {
                $user->update(['role_id' => $adminRole->id]);
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

        $officer = StudentCsgOfficer::where('user_id', $userId)
            ->where('archive', false)
            ->first();

        if (! $officer) {
            return response()->json(['message' => 'Officer record not found.'], 422);
        }

        $officer->update([
            'csg_position' => 'Member',
            'csg_is_active' => false,
            'is_csg' => false,
        ]);

        $user = User::find($userId);
        if ($user) {
            $studentRole = Role::where('slug', 'student')->first();
            if ($studentRole) {
                $user->update(['role_id' => $studentRole->id]);
            }
        }

        return back();
    }

    public function removeAdviser(\Illuminate\Http\Request $request)
    {
        $request->validate([
            'teacherId' => 'required|exists:teacher_adviser,user_id',
        ]);

        $teacherId = $request->teacherId;

        $adviser = TeacherAdviser::where('user_id', $teacherId)
            ->where('archive', false)
            ->first();

        if (! $adviser) {
            return response()->json(['message' => 'Adviser record not found.'], 422);
        }

        $adviser->update(['is_adviser' => false]);

        $user = User::find($teacherId);
        if ($user) {
            $teacherRole = Role::where('slug', 'teacher')->first();
            if ($teacherRole) {
                $user->update(['role_id' => $teacherRole->id]);
            }
        }

        return back();
    }

    public function assignSaduAdviser(\Illuminate\Http\Request $request)
    {
        $request->validate([
            'position' => 'required|string',
            'teacherId' => 'required|exists:teacher_adviser,user_id',
        ]);

        $teacherId = $request->teacherId;

        $adviser = TeacherAdviser::where('user_id', $teacherId)
            ->where('archive', false)
            ->first();

        if (! $adviser) {
            return response()->json(['message' => 'Adviser record not found.'], 422);
        }

        $adviser->update(['is_adviser' => true]);

        $user = User::find($teacherId);
        if ($user) {
            $saduAdminRole = \App\Models\Role::where('slug', 'admin-sadu')->first();
            if ($saduAdminRole) {
                $user->update(['role_id' => $saduAdminRole->id]);
            }
        }

        // return response()->json(['message' => 'SADU Admin assigned successfully']);
    }

    public function removeSaduAdviser(\Illuminate\Http\Request $request)
    {
        $request->validate([
            'teacherId' => 'required|exists:teacher_adviser,user_id',
        ]);

        $teacherId = $request->teacherId;

        $adviser = TeacherAdviser::where('user_id', $teacherId)
            ->where('archive', false)
            ->first();

        if (! $adviser) {
            return response()->json(['message' => 'Adviser record not found.'], 422);
        }

        $adviser->update(['is_adviser' => false]);

        $user = User::find($teacherId);
        if ($user) {
            $teacherRole = Role::where('slug', 'teacher')->first();
            if ($teacherRole) {
                $user->update(['role_id' => $teacherRole->id]);
            }
        }

        return back();
    }

    public function getPositions()
    {
        $positions = CsgPosition::orderBy('position_name')
            ->get()
            ->map(function ($position) {
                return [
                    'id' => $position->id,
                    'name' => $position->position_name,
                ];
            });

        return response()->json(['positions' => $positions]);
    }

    public function addCouncilPosition(\Illuminate\Http\Request $request)
    {
        $request->validate([
            'positionName' => 'required|string|max:255|unique:position,position_name',
        ]);

        try {
            $position = CsgPosition::create([
                'id' => str_replace('-', '', (string) Str::uuid()),
                'position_name' => trim($request->positionName),
            ]);
        } catch (\Throwable $e) {
            return response()->json([
                'message' => 'Failed to add position. Please try again.',
            ], 500);
        }

        return response()->json([
            'message' => 'Position added successfully',
            'position' => [
                'id' => $position->id,
                'name' => $position->position_name,
            ],
        ]);
    }

    public function editCouncilPosition(\Illuminate\Http\Request $request, $id)
    {
        $request->validate([
            'positionName' => 'required|string|max:255|unique:position,position_name,' . $id . ',id',
        ]);

        try {
            $position = CsgPosition::findOrFail($id);
            $position->update(['position_name' => trim($request->positionName)]);
        } catch (\Throwable $e) {
            return response()->json([
                'message' => 'Failed to update position. Please try again.',
            ], 500);
        }

        return response()->json([
            'message' => 'Position updated successfully',
            'position' => [
                'id' => $position->id,
                'name' => $position->position_name,
            ],
        ]);
    }

    public function deleteCouncilPosition($id)
    {
        try {
            $position = CsgPosition::findOrFail($id);
            
            $inUse = StudentCsgOfficer::where('csg_position', $position->position_name)
                ->where('archive', false)
                ->where('csg_is_active', true)
                ->exists();

            if ($inUse) {
                return response()->json([
                    'message' => 'Cannot delete position that is currently assigned to an officer.',
                ], 422);
            }

            $position->delete();
        } catch (\Throwable $e) {
            return response()->json([
                'message' => 'Failed to delete position. Please try again.',
            ], 500);
        }

        return response()->json(['message' => 'Position deleted successfully']);
    }
}