<?php

namespace Database\Seeders;

use App\Models\Role;
use Illuminate\Database\Seeder;
use Illuminate\Support\Facades\DB;
use Illuminate\Support\Str;

class RolePermissionSeeder extends Seeder
{
    public function run(): void
    {
        $permissions = [
            ['Projects', 'view'], ['Projects', 'create'], ['Projects', 'edit'], ['Projects', 'delete'], ['Projects', 'approve'], ['Projects', 'rate'],
            ['Ledger', 'view'], ['Ledger', 'create'], ['Ledger', 'edit'], ['Ledger', 'delete'], ['Ledger', 'approve'], ['Ledger', 'submit'],
            ['Proof Documents', 'view'], ['Proof Documents', 'upload'], ['Proof Documents', 'delete'], ['Proof Documents', 'approve'], ['Proof Documents', 'validate'],
            ['Meetings', 'view'], ['Meetings', 'create'], ['Meetings', 'edit'], ['Meetings', 'delete'], ['Meetings', 'upload minutes'], ['Meetings', 'approve minutes'],
            ['Ratings', 'view'], ['Ratings', 'submit'], ['Ratings', 'moderate'], ['Ratings', 'analytics'],
            ['Notifications', 'view'], ['Notifications', 'send'], ['Notifications', 'manage'],
            ['User Management', 'view'], ['User Management', 'create'], ['User Management', 'edit'], ['User Management', 'suspend'], ['User Management', 'delete'],
            ['Organizations', 'view'], ['Organizations', 'create'], ['Organizations', 'edit'], ['Organizations', 'archive'],
            ['System Settings', 'view'], ['System Settings', 'configure'], ['System Settings', 'backup'], ['System Settings', 'logs'],
        ];

        $permissionIds = [];
        foreach ($permissions as $index => [$module, $action]) {
            $slug = Str::slug($module) . '.' . Str::slug($action);
            $id = sprintf('a1b100%02d-0000-4000-8000-000000000%03d', $index + 1, $index + 1);
            $existingId = DB::table('permission')->where('permission', $slug)->value('id');
            $id = $existingId ?: $id;

            DB::table('permission')->updateOrInsert(
                ['id' => $id],
                [
                    'module' => $module,
                    'action' => $action,
                    'permission' => $slug,
                    'description' => Str::title($action) . " access for {$module}",
                    'archive' => false,
                    'created_at' => now(),
                    'updated_at' => now(),
                ]
            );

            $permissionIds[$slug] = $id;
        }

        $roles = [
            'superadmin' => ['Super Admin', 'Full system access with all permissions', range(1, 43), 5],
            'admin' => ['Admin/Adviser', 'Oversight and approvals of projects and transactions', [1, 5, 6, 7, 11, 13, 16, 17, 18, 23, 24, 26, 27, 28, 29, 31, 36, 38, 40], 5],
            'admin-sadu' => ['Admin/SADU', 'Administrator with SADU responsibilities', [1, 5, 7, 11, 13, 16, 17, 18, 23, 24, 26, 27, 28, 29, 30, 31, 32, 33, 34, 36, 38, 39, 40, 43], 5],
            'csg' => ['CSG Officer', 'Organization operations and submissions', [1, 2, 3, 4, 7, 8, 9, 12, 13, 14, 15, 18, 19, 20, 22, 24, 25, 28, 36], 5],
            'student' => ['Student', 'View, rate, and engage in projects', [1, 6, 18, 24, 25, 28], 1],
            'teacher' => ['Ordinary Teacher', 'Teaching staff without advisory responsibilities', [1, 6, 18, 24, 25, 28], 1],
        ];

        foreach ($roles as $slug => [$name, $description, $grantIndexes, $primaryPermissionIndex]) {
            $role = Role::query()->updateOrCreate(
                ['slug' => $slug],
                [
                    'id' => Role::query()->where('slug', $slug)->value('id') ?? (string) Str::uuid(),
                    'permission_id' => $permissionIds[$this->permissionSlug($permissions[$primaryPermissionIndex - 1])] ?? null,
                    'name' => $name,
                    'description' => $description,
                    'archive' => false,
                ]
            );

            foreach ($grantIndexes as $grantIndex) {
                $permission = $permissions[$grantIndex - 1];
                $slugKey = $this->permissionSlug($permission);

                DB::table('role_permission')->updateOrInsert(
                    ['role_id' => $role->id, 'permission_id' => $permissionIds[$slugKey], 'user_id' => null, 'position_id' => null],
                    ['id' => (string) Str::uuid(), 'created_at' => now()]
                );
            }
        }
    }

    private function permissionSlug(array $permission): string
    {
        return Str::slug($permission[0]) . '.' . Str::slug($permission[1]);
    }
}