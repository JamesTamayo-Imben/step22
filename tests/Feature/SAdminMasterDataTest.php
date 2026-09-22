<?php

namespace Tests\Feature;

use App\Models\Role;
use App\Models\User;
use Illuminate\Foundation\Testing\RefreshDatabase;
use Illuminate\Support\Str;
use Tests\TestCase;

class SAdminMasterDataTest extends TestCase
{
    use RefreshDatabase;

    public function test_super_admin_can_load_master_data_page_with_live_catalogs(): void
    {
        $role = Role::create([
            'id' => (string) Str::uuid(),
            'name' => 'Super Admin',
            'slug' => 'superadmin',
            'description' => 'System administrator',
            'archive' => false,
        ]);

        $user = User::factory()->create([
            'role_id' => $role->id,
            'email' => 'superadmin@example.com',
        ]);

        $response = $this
            ->actingAs($user)
            ->get('/sadmin/master-data');

        $response->assertOk();
    }

    public function test_super_admin_can_create_an_institute_record(): void
    {
        $role = Role::create([
            'id' => (string) Str::uuid(),
            'name' => 'Super Admin',
            'slug' => 'superadmin',
            'description' => 'System administrator',
            'archive' => false,
        ]);

        $user = User::factory()->create([
            'role_id' => $role->id,
            'email' => 'superadmin2@example.com',
        ]);

        $response = $this
            ->actingAs($user)
            ->post('/sadmin/master-data/institutes', [
                'name' => 'College of Engineering',
                'description' => 'Engineering programs',
            ]);

        $response->assertRedirect();
    }
}
