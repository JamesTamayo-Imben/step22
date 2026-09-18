<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Support\Facades\DB;

return new class extends Migration
{
    /**
     * Run the migrations.
     */
    public function up(): void
    {
        $permissions = [
            [
                'id' => 'a1b10001-0000-4000-8000-000000000001',
                'module' => 'Projects',
                'action' => 'view',
                'permission' => 'projects.view',
                'description' => 'View access for Projects',
                'created_at' => '2026-03-19 06:29:42',
                'updated_at' => '2026-03-19 06:29:42',
                'archive' => 0,
            ],
            [
                'id' => 'a1b10005-0000-4000-8000-000000000005',
                'module' => 'System Settings',
                'action' => 'configure',
                'permission' => 'system-settings.configure',
                'description' => 'Configure access for System Settings',
                'created_at' => '2026-03-19 06:29:42',
                'updated_at' => '2026-03-19 06:29:42',
                'archive' => 0,
            ],
        ];

        foreach ($permissions as $permission) {
            DB::table('permission')->updateOrInsert(['id' => $permission['id']], $permission);
        }

        $roles = [
            [
                'id' => '059ef3f9-235d-11f1-9647-10683825ce81',
                'permission_id' => 'a1b10005-0000-4000-8000-000000000005',
                'name' => 'Super Admin',
                'slug' => 'superadmin',
                'description' => 'Full system access with all permissions',
                'created_at' => '2026-03-19 06:29:42',
                'updated_at' => '2026-03-19 06:32:19',
                'archive' => 0,
            ],
            [
                'id' => '059ef712-235d-11f1-9647-10683825ce81',
                'permission_id' => 'a1b10005-0000-4000-8000-000000000005',
                'name' => 'Admin/Adviser',
                'slug' => 'admin',
                'description' => 'Oversight and approvals of projects and transactions',
                'created_at' => '2026-03-19 06:29:42',
                'updated_at' => '2026-03-19 06:32:48',
                'archive' => 0,
            ],
            [
                'id' => '059f4170-235d-11f1-9647-10683825ce81',
                'permission_id' => 'a1b10001-0000-4000-8000-000000000001',
                'name' => 'Student',
                'slug' => 'student',
                'description' => 'View, rate, and engage in projects',
                'created_at' => '2026-03-19 06:29:42',
                'updated_at' => '2026-03-19 06:33:29',
                'archive' => 0,
            ],
            [
                'id' => '059f4213-235d-11f1-9647-10683825ce81',
                'permission_id' => 'a1b10001-0000-4000-8000-000000000001',
                'name' => 'Ordinary Teacher',
                'slug' => 'teacher',
                'description' => 'Teaching staff without advisory responsibilities',
                'created_at' => '2026-03-19 06:29:42',
                'updated_at' => '2026-03-19 06:33:46',
                'archive' => 0,
            ],
        ];

        foreach ($roles as $role) {
            DB::table('roles')->updateOrInsert(['id' => $role['id']], $role);
        }

        $users = [
            [
                'id' => '6373498c-903e-43a9-bb1d-b67a496aee24',
                'role_id' => '059ef3f9-235d-11f1-9647-10683825ce81',
                'name' => 'LARENCE jhgjgh',
                'email' => 'jmsumulong@kld.edu.ph',
                'email_verified_at' => '2026-08-04 23:52:28',
                'invitation_token' => null,
                'token_expires_at' => null,
                'is_token_expired' => 0,
                'phone' => null,
                'password' => '$2y$12$f3.xbygNSC3HZnB.KZHEAe8/Is4sba5o5GvuXo0IaSN.tnEFjvaOi',
                'avatar_url' => null,
                'profile_completed' => 1,
                'id_verification_id' => null,
                'status' => 'active',
                'last_login_at' => '2026-09-04 20:08:16',
                'remember_token' => null,
                'created_at' => '2026-08-04 23:51:52',
                'updated_at' => '2026-09-04 20:08:16',
                'archive' => 0,
            ],
            [
                'id' => 'd1de808f-0522-4486-ae80-c82cba2a69e4',
                'role_id' => '059ef712-235d-11f1-9647-10683825ce81',
                'name' => 'LAWRENCE CALIBUSO',
                'email' => 'lpcalibuso@kld.edu.ph',
                'email_verified_at' => '2026-09-04 20:08:40',
                'invitation_token' => null,
                'token_expires_at' => null,
                'is_token_expired' => 0,
                'phone' => '09234234231',
                'password' => '$2y$12$DLUzPOQtLZX39HIGz2Ro1u7ZSSU4vYocNejzgCndhz5PgQhvmer4y',
                'avatar_url' => null,
                'profile_completed' => 1,
                'id_verification_id' => null,
                'status' => 'active',
                'last_login_at' => '2026-09-06 00:33:34',
                'remember_token' => null,
                'created_at' => '2026-09-04 20:07:38',
                'updated_at' => '2026-09-06 00:33:34',
                'archive' => 0,
            ],
            [
                'id' => 'e223d7d0-3ecf-4ddd-bda6-e558741fec26',
                'role_id' => '059f4170-235d-11f1-9647-10683825ce81',
                'name' => 'EDWARD QUINTOS',
                'email' => 'emdgquintos@kld.edu.ph',
                'email_verified_at' => '2026-09-04 20:14:19',
                'invitation_token' => null,
                'token_expires_at' => null,
                'is_token_expired' => 0,
                'phone' => '09345345325',
                'password' => '$2y$12$nUA6ArFjnCEkjXyevYZ0Z.ETaQkojcpwEPxlfexeE5x3XifZ69Uhy',
                'avatar_url' => null,
                'profile_completed' => 1,
                'id_verification_id' => null,
                'status' => 'active',
                'last_login_at' => '2026-09-06 00:33:52',
                'remember_token' => null,
                'created_at' => '2026-09-04 20:13:52',
                'updated_at' => '2026-09-06 03:02:05',
                'archive' => 0,
            ],
            [
                'id' => 'f6b776d6-8d77-43e3-976a-fbb0daffa325',
                'role_id' => '059f4213-235d-11f1-9647-10683825ce81',
                'name' => 'JAMES TAMAYO',
                'email' => 'jttamayo@kld.edu.ph',
                'email_verified_at' => null,
                'invitation_token' => null,
                'token_expires_at' => null,
                'is_token_expired' => 0,
                'phone' => null,
                'password' => '$2y$12$9MvKx3sc82BPlDGMYqxRaeybMw2Lwjp5GX3EsJY5nZ527Ahg528w6',
                'avatar_url' => null,
                'profile_completed' => 0,
                'id_verification_id' => null,
                'status' => 'active',
                'last_login_at' => '2026-05-28 01:33:53',
                'remember_token' => null,
                'created_at' => '2026-05-10 09:19:57',
                'updated_at' => '2026-05-28 01:33:53',
                'archive' => 0,
            ],
        ];

        foreach ($users as $user) {
            DB::table('users')->updateOrInsert(['id' => $user['id']], $user);
        }
    }

    /**
     * Reverse the migrations.
     */
    public function down(): void
    {
        DB::table('users')->whereIn('id', [
            '6373498c-903e-43a9-bb1d-b67a496aee24',
            'd1de808f-0522-4486-ae80-c82cba2a69e4',
            'e223d7d0-3ecf-4ddd-bda6-e558741fec26',
            'f6b776d6-8d77-43e3-976a-fbb0daffa325',
        ])->delete();
    }
};
