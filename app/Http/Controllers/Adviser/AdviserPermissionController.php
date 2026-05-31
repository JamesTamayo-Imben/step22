<?php

namespace App\Http\Controllers\Adviser;

use App\Http\Controllers\Controller;
use App\Models\CsgPosition;
use App\Models\Role;
use App\Models\StudentCsgOfficer;
use App\Models\User;
use Illuminate\Http\Request;
use Inertia\Inertia;

class AdviserPermissionController extends Controller
{
    public function index()
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
                    'studentId' => $user->id, // Using id as studentId for now
                    'avatar' => strtoupper(substr($user->name, 0, 2)),
                    'currentRole' => $user->role?->name ?? 'Student',
                ];
            });

        // Get current CSG officers
        $csgOfficers = StudentCsgOfficer::with('user')
            ->where('archive', false)
            ->where('csg_is_active', true)
            // ->where('csg_position', '!=', 'member')
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

        // Get positions from database
        $councilPositions = CsgPosition::orderBy('position_name')->get();
        $councilOfficers = [];
        foreach ($councilPositions as $pos) {
            $existing = collect($csgOfficers)->firstWhere('position', $pos->position_name);
            if ($existing) {
                $councilOfficers[] = $existing;
            } else {
                $councilOfficers[] = [
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
        'id' => $officer->user_id,  // User ID for React key
        'studentId' => $officer->id,  // Actual student ID (primary key of student_csg_officers)
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

        // Get CSG positions from database
        $csgPositions = CsgPosition::orderBy('position_name')
            ->get()
            ->map(function ($position) {
                return [
                    'id' => $position->position_name,
                    'name' => $position->position_name,
                    'sections' => [],
                ];
            })
            ->toArray();

        $roles = [
            [
                'name' => 'Superadmin',
                'description' => 'Full system access with all permissions',
                'totalPermissions' => 43,
                'isEditable' => false,
                'sections' => [
                    [
                        'category' => 'System',
                        'permissions' => [
                            ['id' => 'sys_view', 'label' => 'View', 'enabled' => true],
                            ['id' => 'sys_create', 'label' => 'Create', 'enabled' => true],
                            ['id' => 'sys_edit', 'label' => 'Edit', 'enabled' => true],
                            ['id' => 'sys_delete', 'label' => 'Delete', 'enabled' => true],
                            ['id' => 'sys_manage', 'label' => 'Manage Users', 'enabled' => true],
                        ],
                    ],
                    [
                        'category' => 'All Modules',
                        'permissions' => [['id' => 'all_access', 'label' => 'Full Access', 'enabled' => true]],
                    ],
                ],
            ],
            [
                'name' => 'Admin/Adviser',
                'description' => 'Approval authority and oversight capabilities',
                'totalPermissions' => 14,
                'isEditable' => false,
                'sections' => [
                    [
                        'category' => 'Projects',
                        'permissions' => [
                            ['id' => 'proj_view', 'label' => 'View', 'enabled' => true],
                            ['id' => 'proj_approve', 'label' => 'Approve', 'enabled' => true],
                        ],
                    ],
                    [
                        'category' => 'Ledger',
                        'permissions' => [
                            ['id' => 'ledger_view', 'label' => 'View', 'enabled' => true],
                            ['id' => 'ledger_approve', 'label' => 'Approve', 'enabled' => true],
                            ['id' => 'ledger_verify', 'label' => 'Verify', 'enabled' => true],
                        ],
                    ],
                    [
                        'category' => 'Permissions',
                        'permissions' => [
                            ['id' => 'perm_manage', 'label' => 'Manage CSG Permissions', 'enabled' => true],
                            ['id' => 'perm_delegate', 'label' => 'Delegate Authority', 'enabled' => true],
                        ],
                    ],
                ],
            ],
            [
                'name' => 'CSG Officer',
                'description' => 'Create projects, manage ledger, and upload proofs',
                'totalPermissions' => 234, // 13 positions × 18 permissions each
                'isEditable' => true,
                'sections' => [],
            ],
            [
                'name' => 'Student',
                'description' => 'Read-only access with engagement features',
                'totalPermissions' => 8,
                'isEditable' => true,
                'sections' => [
                    [
                        'category' => 'Projects',
                        'permissions' => [
                            ['id' => 'proj_view', 'label' => 'View', 'enabled' => true],
                            ['id' => 'proj_rate', 'label' => 'Rate', 'enabled' => true],
                        ],
                    ],
                    [
                        'category' => 'Engagement',
                        'permissions' => [
                            ['id' => 'engage_view', 'label' => 'View Points', 'enabled' => true],
                            ['id' => 'engage_badges', 'label' => 'View Badges', 'enabled' => true],
                            ['id' => 'engage_leaderboard', 'label' => 'View Leaderboard', 'enabled' => true],
                        ],
                    ],
                ],
            ],
        ];

        return Inertia::render('Adviser/Permission', [
            'users' => $users,
            'csgOfficerCandidates' => $csgOfficerCandidates,
            'councilOfficers' => $councilOfficers,
            'csgPositions' => $csgPositions,
            'roles' => $roles,
        ]);
    }

    public function assignOfficer(Request $request)
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

        // Update the user's role_id to admin (adviser) role
        $user = User::find($candidate->user_id);
        if ($user) {
            // Get the admin/adviser role ID (admin role slug)
            $csgRole = \App\Models\Role::where('slug', 'csg')->first();
            if ($csgRole) {
                $user->update([
                    'role_id' => $csgRole->id,
                ]);
            }
        }

        // return response()->json(['message' => 'Officer assigned successfully']);
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

    public function updatePermissions(Request $request)
    {
        // For now, just return success since permissions are not stored in DB yet
        // In future, implement permission storage
        return response()->json(['message' => 'Permissions updated successfully']);
    }

    public function setCouncilTerm(Request $request)
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

            // return response()->json([
            //     // 'message' => "Council term updated for {$updated} officers",
            //     // 'updated' => $updated,
            // ]);
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
}