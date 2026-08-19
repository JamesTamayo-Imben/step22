<?php

namespace App\Services;

use App\Models\CsgPosition;
use App\Models\Permission;
use App\Models\Role;
use App\Models\User;
use Illuminate\Support\Facades\DB;
use Illuminate\Support\Facades\Schema;
use Illuminate\Support\Str;

class RolePermissionService
{
    /**
     * Full permission catalog (module → actions).
     */
    public static function catalog(): array
    {
        return [
            'Projects' => ['view', 'create', 'edit', 'delete', 'approve', 'rate', 'submit'],
            'Ledger' => ['view', 'create', 'edit', 'delete', 'approve', 'submit'],
            'Proof Documents' => ['view', 'upload', 'delete', 'approve'],
            'Meetings' => ['view', 'create', 'edit', 'delete', 'submit', 'upload minutes', 'approve minutes'],
            'Ratings' => ['view', 'submit', 'moderate'],
            'Notifications' => ['view', 'send'],
        ];
    }

    /**
     * Modules/actions shown for a specific role (hides irrelevant toggles).
     */
    public static function catalogForRole(string $slug): array
    {
        return match ($slug) {
            'admin', 'admin-sadu' => [
                'Projects' => ['view', 'approve'],
                'Ledger' => ['view', 'approve'],
                'Proof Documents' => ['view'],
                'Meetings' => ['view', 'approve minutes'],
                'Ratings' => ['view'],
                'Notifications' => ['view'],
            ],
            'csg' => [
                'Projects' => ['view', 'create', 'edit', 'delete', 'submit'],
                'Ledger' => ['view', 'create', 'edit', 'delete', 'submit'],
                'Proof Documents' => ['view', 'edit'],
                'Meetings' => ['view', 'create', 'edit', 'delete', 'submit'],
                'Ratings' => ['view'],
                'Notifications' => ['view'],
            ],
            'student', 'teacher' => [
                'Projects' => ['view'],
                'Meetings' => ['view'],
                'Ratings' => ['view', 'submit'],
                'Notifications' => ['view'],
            ],
            default => self::catalog(), // superadmin and unknown: full catalog
        };
    }

    /**
     * UI role keys mapped to DB role slugs / display labels.
     */
    public static function roleOptions(): array
    {
        return [
            [
                'key' => 'superadmin',
                'slug' => 'superadmin',
                'label' => 'Super Admin',
                'dbName' => 'Super Admin',
                'description' => 'Full system access with all permissions',
                'isEditable' => false,
            ],
            [
                'key' => 'admin',
                'slug' => 'admin',
                'label' => 'Council Adviser',
                'dbName' => 'Admin/Adviser',
                'description' => 'Oversight and approvals of projects and transactions',
                'isEditable' => true,
            ],
            [
                'key' => 'admin-sadu',
                'slug' => 'admin-sadu',
                'label' => 'SADU Admin',
                'dbName' => 'Admin/SADU',
                'description' => 'Student Affairs and Discipline Office administration',
                'isEditable' => true,
            ],
            [
                'key' => 'csg',
                'slug' => 'csg',
                'label' => 'CSG',
                'dbName' => 'CSG Officer',
                'description' => 'Organization operations and submissions',
                'isEditable' => true,
            ],
            [
                'key' => 'teacher',
                'slug' => 'teacher',
                'label' => 'Teacher/Professor',
                'dbName' => 'Ordinary Teacher',
                'description' => 'Faculty members who can review and submit ratings',
                'isEditable' => true,
            ],
            [
                'key' => 'student',
                'slug' => 'student',
                'label' => 'Ordinary Students',
                'dbName' => 'Student',
                'description' => 'View, rate, and engage in projects',
                'isEditable' => true,
            ],
        ];
    }

    /**
     * Default permission slugs enabled per role slug.
     * Use ['*'] for every permission in the full catalog.
     */
    public static function defaultGrants(): array
    {
        return [
            'superadmin' => ['*'],
            'admin' => [
                'projects.view', 'projects.approve',
                'ledger.view', 'ledger.approve',
                'proof-documents.view',
                'meetings.view', 'meetings.approve-minutes',
                'ratings.view',
                'notifications.view',
            ],
            'admin-sadu' => [
                'projects.view', 'projects.approve',
                'ledger.view', 'ledger.approve',
                'proof-documents.view',
                'meetings.view', 'meetings.approve-minutes',
                'ratings.view',
                'notifications.view',
            ],
            'csg' => [
                'projects.view', 'projects.create', 'projects.edit', 'projects.delete', 'projects.submit',
                'ledger.view', 'ledger.create', 'ledger.edit', 'ledger.delete', 'ledger.submit',
                'proof-documents.view', 'proof-documents.edit',
                'meetings.view', 'meetings.create', 'meetings.edit', 'meetings.delete', 'meetings.submit',
                'ratings.view',
                'notifications.view',
            ],
            'student' => [
                'projects.view', 'projects.rate',
                'meetings.view',
                'ratings.view', 'ratings.submit',
                'notifications.view',
            ],
            'teacher' => [
                'projects.view', 'projects.rate',
                'meetings.view',
                'ratings.view', 'ratings.submit',
                'notifications.view',
            ],
        ];
    }

    public static function slugify(string $module, string $action): string
    {
        $moduleSlug = Str::slug($module);
        $actionSlug = Str::slug($action);

        return "{$moduleSlug}.{$actionSlug}";
    }

    public static function labelAction(string $action): string
    {
        return Str::title($action);
    }

    public function supportsPositionScope(): bool
    {
        return Schema::hasColumn('role_permission', 'position_id');
    }

    /**
     * Ensure catalog permissions exist and roles/positions have default grants when empty.
     */
    public function syncCatalog(): void
    {
        $permissionIdsBySlug = $this->ensurePermissionRows();
        $defaults = self::defaultGrants();
        $hasPosition = $this->supportsPositionScope();

        foreach (Role::query()->where('archive', false)->get() as $role) {
            $existingQuery = DB::table('role_permission')
                ->where('role_id', $role->id)
                ->whereNull('user_id');

            if ($hasPosition) {
                $existingQuery->whereNull('position_id');
            }

            if ($existingQuery->count() === 0) {
                $this->insertGrants($role->id, $defaults[$role->slug] ?? [], $permissionIdsBySlug, null);
            }

            // CSG: seed each council position with its own permission set when empty
            if ($role->slug === 'csg' && $hasPosition) {
                $csgDefaults = $defaults['csg'] ?? [];
                foreach (CsgPosition::query()->orderBy('position_name')->get() as $position) {
                    $positionCount = DB::table('role_permission')
                        ->where('role_id', $role->id)
                        ->whereNull('user_id')
                        ->where('position_id', $position->id)
                        ->count();

                    if ($positionCount === 0) {
                        $this->insertGrants($role->id, $csgDefaults, $permissionIdsBySlug, $position->id);
                    }
                }
            }
        }
    }

    /**
     * @return array<string, string> slug => permission id
     */
    protected function ensurePermissionRows(): array
    {
        $permissionIdsBySlug = [];

        foreach (self::catalog() as $module => $actions) {
            foreach ($actions as $action) {
                $slug = self::slugify($module, $action);

                $permission = Permission::query()
                    ->where(function ($q) use ($slug, $module, $action) {
                        $q->where('permission', $slug)
                            ->orWhere(function ($inner) use ($module, $action) {
                                $inner->where('module', $module)->where('action', $action);
                            });
                    })
                    ->first();

                if (!$permission) {
                    $permission = Permission::create([
                        'id' => (string) Str::uuid(),
                        'module' => $module,
                        'action' => $action,
                        'permission' => $slug,
                        'description' => self::labelAction($action) . " access for {$module}",
                        'archive' => false,
                    ]);
                } else {
                    $permission->update([
                        'module' => $module,
                        'action' => $action,
                        'permission' => $slug,
                        'archive' => false,
                    ]);
                }

                $permissionIdsBySlug[$slug] = $permission->id;
            }
        }

        return $permissionIdsBySlug;
    }

    /**
     * @param  array<int, string>  $grants
     * @param  array<string, string>  $permissionIdsBySlug
     */
    protected function insertGrants(string $roleId, array $grants, array $permissionIdsBySlug, ?string $positionId): void
    {
        if ($grants === ['*'] || (count($grants) === 1 && ($grants[0] ?? null) === '*')) {
            $grants = array_keys($permissionIdsBySlug);
        }

        $hasPosition = $this->supportsPositionScope();

        foreach ($grants as $slug) {
            if (!isset($permissionIdsBySlug[$slug])) {
                continue;
            }

            $row = [
                'id' => (string) Str::uuid(),
                'user_id' => null,
                'role_id' => $roleId,
                'permission_id' => $permissionIdsBySlug[$slug],
                'created_at' => now(),
            ];

            if ($hasPosition) {
                $row['position_id'] = $positionId;
            }

            DB::table('role_permission')->insert($row);
        }
    }

    /**
     * Build hierarchical matrix for Inertia (all configurable roles + CSG positions).
     */
    public function buildMatrix(): array
    {
        $this->syncCatalog();

        $hasPosition = $this->supportsPositionScope();
        $matrix = [];

        foreach (self::roleOptions() as $option) {
            $role = Role::query()->where('slug', $option['slug'])->first();
            if (!$role) {
                continue;
            }

            $roleCatalog = self::catalogForRole($option['slug']);
            $byModule = $this->permissionsGroupedByModule($roleCatalog);
            $defaultIds = $this->defaultPermissionIdsForSlug($option['slug']);

            $entry = [
                'key' => $option['key'],
                'id' => $role->id,
                'name' => $option['label'],
                'dbName' => $role->name,
                'slug' => $role->slug,
                'description' => $option['description'] ?: ($role->description ?? ''),
                'isEditable' => $option['isEditable'],
                'defaultPermissionIds' => $defaultIds,
                'positions' => [],
            ];

            if ($option['slug'] === 'csg' && $hasPosition) {
                $positions = [];
                foreach (CsgPosition::query()->orderBy('position_name')->get() as $position) {
                    $built = $this->buildSectionsForScope($role->id, $byModule, $position->id);
                    $positions[] = [
                        'id' => $position->id,
                        'name' => $position->position_name,
                        'enabledCount' => $built['enabledCount'],
                        'totalPermissions' => $built['totalCount'],
                        'sections' => $built['sections'],
                        'defaultPermissionIds' => $defaultIds,
                    ];
                }
                $entry['positions'] = $positions;
                $first = $positions[0] ?? null;
                $entry['sections'] = $first['sections'] ?? [];
                $entry['enabledCount'] = $first['enabledCount'] ?? 0;
                $entry['totalPermissions'] = $first['totalPermissions'] ?? 0;
            } else {
                $built = $this->buildSectionsForScope($role->id, $byModule, null);
                $entry['sections'] = $built['sections'];
                $entry['enabledCount'] = $built['enabledCount'];
                $entry['totalPermissions'] = $built['totalCount'];
            }

            $matrix[] = $entry;
        }

        return $matrix;
    }

    /**
     * Default permission IDs for a role slug (intersection with role catalog).
     *
     * @return array<int, string>
     */
    public function defaultPermissionIdsForSlug(string $slug): array
    {
        $permissionIdsBySlug = $this->ensurePermissionRows();
        $grants = self::defaultGrants()[$slug] ?? [];

        if ($grants === ['*'] || (count($grants) === 1 && ($grants[0] ?? null) === '*')) {
            $grants = [];
            foreach (self::catalogForRole($slug) as $module => $actions) {
                foreach ($actions as $action) {
                    $grants[] = self::slugify($module, $action);
                }
            }
        }

        $allowed = [];
        foreach (self::catalogForRole($slug) as $module => $actions) {
            foreach ($actions as $action) {
                $allowed[self::slugify($module, $action)] = true;
            }
        }

        $ids = [];
        foreach ($grants as $grantSlug) {
            if (!isset($allowed[$grantSlug])) {
                continue;
            }
            if (isset($permissionIdsBySlug[$grantSlug])) {
                $ids[] = $permissionIdsBySlug[$grantSlug];
            }
        }

        return array_values(array_unique($ids));
    }

    /**
     * Apply default grants into the DB for a role (optional CSG position).
     */
    public function restoreDefaults(string $roleId, ?string $positionId = null): void
    {
        $role = Role::query()->findOrFail($roleId);
        $option = collect(self::roleOptions())->firstWhere('slug', $role->slug);

        if ($option && empty($option['isEditable'])) {
            abort(403, 'This role cannot be modified.');
        }

        if ($role->slug === 'csg' && $this->supportsPositionScope() && !$positionId) {
            abort(422, 'A CSG position is required to restore CSG defaults.');
        }

        $ids = $this->defaultPermissionIdsForSlug($role->slug);
        $this->syncRolePermissions($roleId, $ids, $positionId);
    }

    /**
     * @param  array<string, array<int, string>>  $catalog
     * @return array<string, \Illuminate\Support\Collection>
     */
    protected function permissionsGroupedByModule(array $catalog): array
    {
        $permissions = Permission::query()
            ->where('archive', false)
            ->whereNotNull('permission')
            ->where('permission', 'like', '%.%')
            ->orderBy('module')
            ->orderBy('action')
            ->get();

        $byModule = [];
        foreach ($catalog as $module => $actions) {
            $byModule[$module] = collect();
            foreach ($actions as $action) {
                $slug = self::slugify($module, $action);
                $perm = $permissions->firstWhere('permission', $slug);
                if ($perm) {
                    $byModule[$module]->push($perm);
                }
            }
        }

        return $byModule;
    }

    /**
     * @param  array<string, \Illuminate\Support\Collection>  $byModule
     * @return array{sections: array, enabledCount: int, totalCount: int}
     */
    protected function buildSectionsForScope(string $roleId, array $byModule, ?string $positionId): array
    {
        $grantedQuery = DB::table('role_permission')
            ->where('role_id', $roleId)
            ->whereNull('user_id');

        if ($this->supportsPositionScope()) {
            if ($positionId) {
                $grantedQuery->where('position_id', $positionId);
            } else {
                $grantedQuery->whereNull('position_id');
            }
        }

        $grantedIds = $grantedQuery->pluck('permission_id')->all();

        $sections = [];
        $enabledCount = 0;
        $totalCount = 0;

        foreach ($byModule as $module => $modulePerms) {
            $sectionPerms = [];
            foreach ($modulePerms as $perm) {
                $enabled = in_array($perm->id, $grantedIds, true);
                if ($enabled) {
                    $enabledCount++;
                }
                $totalCount++;
                $sectionPerms[] = [
                    'id' => $perm->id,
                    'slug' => $perm->permission,
                    'label' => self::labelAction($perm->action),
                    'enabled' => $enabled,
                ];
            }

            if (!empty($sectionPerms)) {
                $sections[] = [
                    'category' => $module,
                    'permissions' => $sectionPerms,
                ];
            }
        }

        return compact('sections', 'enabledCount') + ['totalCount' => $totalCount];
    }

    /**
     * Toggle a single permission for a role (and optional CSG position).
     */
    public function updateRolePermission(string $roleId, string $permissionId, bool $enabled, ?string $positionId = null): void
    {
        $role = Role::query()->findOrFail($roleId);
        $option = collect(self::roleOptions())->firstWhere('slug', $role->slug);

        if ($option && empty($option['isEditable'])) {
            abort(403, 'This role cannot be modified.');
        }

        Permission::query()->findOrFail($permissionId);

        if ($role->slug === 'csg' && $this->supportsPositionScope() && !$positionId) {
            abort(422, 'A CSG position is required to update CSG permissions.');
        }

        if ($positionId) {
            CsgPosition::query()->findOrFail($positionId);
        }

        $query = DB::table('role_permission')
            ->where('role_id', $roleId)
            ->where('permission_id', $permissionId)
            ->whereNull('user_id');

        if ($this->supportsPositionScope()) {
            if ($positionId) {
                $query->where('position_id', $positionId);
            } else {
                $query->whereNull('position_id');
            }
        }

        $existing = $query->first();

        if ($enabled && !$existing) {
            $row = [
                'id' => (string) Str::uuid(),
                'user_id' => null,
                'role_id' => $roleId,
                'permission_id' => $permissionId,
                'created_at' => now(),
            ];
            if ($this->supportsPositionScope()) {
                $row['position_id'] = $positionId;
            }
            DB::table('role_permission')->insert($row);
        }

        if (!$enabled && $existing) {
            DB::table('role_permission')->where('id', $existing->id)->delete();
        }
    }

    /**
     * Replace all grants for a role (and optional CSG position).
     */
    public function syncRolePermissions(string $roleId, array $permissionIds, ?string $positionId = null): void
    {
        $role = Role::query()->findOrFail($roleId);
        $option = collect(self::roleOptions())->firstWhere('slug', $role->slug);

        if ($option && empty($option['isEditable'])) {
            abort(403, 'This role cannot be modified.');
        }

        if ($role->slug === 'csg' && $this->supportsPositionScope() && !$positionId) {
            abort(422, 'A CSG position is required to save CSG permissions.');
        }

        if ($positionId) {
            CsgPosition::query()->findOrFail($positionId);
        }

        $delete = DB::table('role_permission')
            ->where('role_id', $roleId)
            ->whereNull('user_id');

        if ($this->supportsPositionScope()) {
            if ($positionId) {
                $delete->where('position_id', $positionId);
            } else {
                $delete->whereNull('position_id');
            }
        }

        $delete->delete();

        $permissionIds = array_values(array_unique(array_filter($permissionIds)));
        $hasPosition = $this->supportsPositionScope();

        foreach ($permissionIds as $permissionId) {
            if (!Permission::query()->where('id', $permissionId)->exists()) {
                continue;
            }

            $row = [
                'id' => (string) Str::uuid(),
                'user_id' => null,
                'role_id' => $roleId,
                'permission_id' => $permissionId,
                'created_at' => now(),
            ];
            if ($hasPosition) {
                $row['position_id'] = $positionId;
            }
            DB::table('role_permission')->insert($row);
        }
    }

    /**
     * Whether the user is allowed the given permission slug (e.g. projects.create).
     */
    public function userCan(?User $user, string $permissionSlug): bool
    {
        if (!$user) {
            return false;
        }

        if (!$user->relationLoaded('role')) {
            $user->load('role');
        }

        if (!$user->role) {
            return false;
        }

        if ($user->role->slug === 'superadmin') {
            return true;
        }

        $permission = Permission::query()
            ->where('permission', $permissionSlug)
            ->where('archive', false)
            ->first();

        if (!$permission) {
            return false;
        }

        $hasPosition = $this->supportsPositionScope();

        // CSG officers: use their council position grants when available
        if ($user->role->slug === 'csg' && $hasPosition) {
            if (!$user->relationLoaded('student')) {
                $user->load('student');
            }

            $positionName = $user->student?->csg_position;
            if ($positionName && strcasecmp($positionName, 'Member') !== 0) {
                $position = CsgPosition::query()
                    ->where('position_name', $positionName)
                    ->first();

                if ($position) {
                    $positionScopedCount = DB::table('role_permission')
                        ->where('role_id', $user->role_id)
                        ->whereNull('user_id')
                        ->where('position_id', $position->id)
                        ->count();

                    if ($positionScopedCount > 0) {
                        return DB::table('role_permission')
                            ->where('role_id', $user->role_id)
                            ->where('permission_id', $permission->id)
                            ->whereNull('user_id')
                            ->where('position_id', $position->id)
                            ->exists();
                    }
                }
            }
        }

        $query = DB::table('role_permission')
            ->where('role_id', $user->role_id)
            ->where('permission_id', $permission->id)
            ->whereNull('user_id');

        if ($hasPosition) {
            $query->whereNull('position_id');
        }

        return $query->exists();
    }

    /**
     * @return array<int, string>
     */
    public function permissionSlugsForUser(?User $user): array
    {
        if (!$user) {
            return [];
        }

        if (!$user->relationLoaded('role')) {
            $user->load('role');
        }

        if (!$user->role) {
            return [];
        }

        if ($user->role->slug === 'superadmin') {
            $slugs = [];
            foreach (self::catalog() as $module => $actions) {
                foreach ($actions as $action) {
                    $slugs[] = self::slugify($module, $action);
                }
            }

            return $slugs;
        }

        $this->syncCatalog();

        $permissionIds = null;
        $hasPosition = $this->supportsPositionScope();

        if ($user->role->slug === 'csg' && $hasPosition) {
            if (!$user->relationLoaded('student')) {
                $user->load('student');
            }
            $positionName = $user->student?->csg_position;
            if ($positionName && strcasecmp($positionName, 'Member') !== 0) {
                $position = CsgPosition::query()->where('position_name', $positionName)->first();
                if ($position) {
                    $ids = DB::table('role_permission')
                        ->where('role_id', $user->role_id)
                        ->whereNull('user_id')
                        ->where('position_id', $position->id)
                        ->pluck('permission_id');
                    if ($ids->isNotEmpty()) {
                        $permissionIds = $ids;
                    }
                }
            }
        }

        if ($permissionIds === null) {
            $q = DB::table('role_permission')
                ->where('role_id', $user->role_id)
                ->whereNull('user_id');
            if ($hasPosition) {
                $q->whereNull('position_id');
            }
            $permissionIds = $q->pluck('permission_id');
        }

        return Permission::query()
            ->whereIn('id', $permissionIds)
            ->where('archive', false)
            ->pluck('permission')
            ->filter()
            ->values()
            ->all();
    }

    /**
     * Abort with 403 unless the current user has the permission.
     */
    public function authorize(?User $user, string $permissionSlug, ?string $message = null): void
    {
        if (!$this->userCan($user, $permissionSlug)) {
            abort(403, $message ?: 'You do not have permission to perform this action.');
        }
    }
}
