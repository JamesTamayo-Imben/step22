<?php

namespace Tests;

use App\Models\Permission;
use App\Models\Role;
use App\Models\User;
use Illuminate\Foundation\Testing\TestCase as BaseTestCase;
use Illuminate\Support\Facades\Schema;
use Illuminate\Support\Str;

abstract class TestCase extends BaseTestCase
{
    protected function authorizedUser(string $roleSlug): User
    {
        $this->ensureAuthorizationSchema();

        foreach (['slug' => fn ($table) => $table->string('slug')->nullable(), 'archive' => fn ($table) => $table->boolean('archive')->default(false)] as $column => $definition) {
            if (!Schema::hasColumn('roles', $column)) {
                Schema::table('roles', $definition);
            }
        }

        $role = Role::query()->where('slug', $roleSlug)->first();
        if (!$role) {
            $role = new Role([
                'name' => $roleSlug,
                'slug' => $roleSlug,
                'archive' => false,
            ]);
            if (in_array(Schema::getColumnType('roles', 'id'), ['integer', 'bigint', 'smallint'], true)) {
                $role->setIncrementing(true);
                $role->setKeyType('int');
            } else {
                $role->id = (string) Str::uuid();
            }
            $role->save();
        }

        $grants = [
            'admin' => ['projects.approve'],
            'csg' => ['projects.create', 'ledger.create', 'meetings.create'],
        ][$roleSlug] ?? [];

        foreach ($grants as $slug) {
            $permission = Permission::query()->firstOrCreate(
                ['permission' => $slug],
                [
                    'id' => (string) Str::uuid(),
                    'module' => Str::before($slug, '.'),
                    'action' => Str::after($slug, '.'),
                    'archive' => false,
                ]
            );

            $exists = Schema::hasColumn('role_permission', 'position_id')
                ? ['role_id' => $role->id, 'permission_id' => $permission->id, 'position_id' => null]
                : ['role_id' => $role->id, 'permission_id' => $permission->id];

            if (!\Illuminate\Support\Facades\DB::table('role_permission')->where($exists)->exists()) {
                \Illuminate\Support\Facades\DB::table('role_permission')->insert([
                    'id' => (string) Str::uuid(),
                    'user_id' => null,
                    ...$exists,
                    'created_at' => now(),
                ]);
            }
        }

        if (!Schema::hasColumn('users', 'role_id')) {
            Schema::table('users', fn ($table) => $table->uuid('role_id')->nullable());
        }

        $attributes = User::factory()->raw(['role_id' => $role->id]);
        $user = new User();
        if (in_array(Schema::getColumnType('users', 'id'), ['integer', 'bigint', 'smallint'], true)) {
            $user->setIncrementing(true);
            $user->setKeyType('int');
            unset($attributes['id']);
        }
        $user->fill($attributes);
        $user->save();

        return $user;
    }

    private function ensureAuthorizationSchema(): void
    {
        if (!Schema::hasTable('roles')) {
            Schema::create('roles', function ($table) {
                $table->uuid('id')->primary();
                $table->uuid('permission_id')->nullable();
                $table->string('name')->nullable();
                $table->string('slug')->nullable();
                $table->text('description')->nullable();
                $table->timestamps();
                $table->boolean('archive')->default(false);
            });
        }

        if (!Schema::hasTable('permission')) {
            Schema::create('permission', function ($table) {
                $table->uuid('id')->primary();
                $table->string('module')->nullable();
                $table->string('action')->nullable();
                $table->string('permission')->nullable();
                $table->text('description')->nullable();
                $table->timestamps();
                $table->boolean('archive')->default(false);
            });
        }
        if (!Schema::hasTable('users')) {
            Schema::create('users', function ($table) {
                $table->uuid('id')->primary();
                $table->uuid('role_id')->nullable();
                $table->string('name')->nullable();
                $table->string('email')->nullable();
                $table->timestamp('email_verified_at')->nullable();
                $table->string('password')->nullable();
                $table->string('remember_token')->nullable();
                $table->timestamps();
                $table->string('status')->default('active');
                $table->boolean('archive')->default(false);
            });
        }

        $roleIdColumn = in_array(Schema::getColumnType('roles', 'id'), ['integer', 'bigint', 'smallint'], true)
            ? fn ($table) => $table->unsignedBigInteger('role_id')->nullable()
            : fn ($table) => $table->uuid('role_id')->nullable();

        $userColumns = [
            'role_id' => $roleIdColumn,
            'email_verified_at' => fn ($table) => $table->timestamp('email_verified_at')->nullable(),
            'status' => fn ($table) => $table->string('status')->default('active'),
            'archive' => fn ($table) => $table->boolean('archive')->default(false),
        ];

        foreach ($userColumns as $column => $definition) {
            if (!Schema::hasColumn('users', $column)) {
                Schema::table('users', $definition);
            }
        }

        foreach (['student_csg_officers', 'teacher_adviser'] as $tableName) {
            if (!Schema::hasTable($tableName)) {
                Schema::create($tableName, function ($table) {
                    $table->string('id')->primary();
                    $table->uuid('user_id')->nullable();
                });
            }
        }


        if (!Schema::hasTable('notifications')) {
            Schema::create('notifications', function ($table) {
                $table->uuid('id')->primary();
                $table->uuid('user_id')->nullable();
                $table->string('title')->nullable();
                $table->text('message')->nullable();
                $table->string('type')->nullable();
                $table->boolean('is_read')->default(false);
                $table->timestamp('read_at')->nullable();
                $table->timestamps();
                $table->boolean('archive')->default(false);
            });
        }

        if (!Schema::hasTable('position')) {
            Schema::create('position', function ($table) {
                $table->char('id', 32)->primary();
                $table->string('position_name')->nullable();
                $table->date('created_at')->nullable();
                $table->date('updated_at')->nullable();
            });
        }

        if (!Schema::hasTable('chain')) {
            Schema::create('chain', function ($table) {
                $table->string('id')->primary();
                $table->string('project_id')->nullable();
                $table->integer('block_index')->default(0);
                $table->string('prev_hash')->nullable();
                $table->string('hash')->nullable();
                $table->text('data_snapshot')->nullable();
                $table->timestamp('created_at')->nullable();
            });
        }
        if (!Schema::hasTable('role_permission')) {
            Schema::create('role_permission', function ($table) {
                $table->uuid('id')->primary();
                $table->uuid('user_id')->nullable();
                $table->uuid('role_id')->nullable();
                $table->uuid('permission_id')->nullable();
                $table->char('position_id', 32)->nullable();
                $table->timestamp('created_at')->nullable();
            });
        }
    }
}
