<?php

namespace Tests\Feature\Auth;

use App\Mail\OTPMail;
use App\Models\Role;
use App\Models\User;
use Illuminate\Foundation\Testing\RefreshDatabase;
use Illuminate\Support\Facades\Cache;
use Illuminate\Support\Facades\Mail;
use Illuminate\Support\Str;
use Tests\TestCase;

class SuperAdminLoginOtpTest extends TestCase
{
    use RefreshDatabase;

    protected function createSuperAdminUser(): User
    {
        $role = Role::create([
            'id' => (string) Str::uuid(),
            'name' => 'Super Admin',
            'slug' => 'superadmin',
            'description' => 'System administrator',
            'archive' => false,
        ]);

        return User::factory()->create([
            'role_id' => $role->id,
            'name' => 'Super Admin',
            'email' => 'superadmin@example.com',
            'password' => bcrypt('password123'),
            'status' => 'active',
            'archive' => false,
        ]);
    }

    public function test_superadmin_can_request_login_otp(): void
    {
        Mail::fake();
        $this->createSuperAdminUser();

        $response = $this->postJson('/api/superadmin/login/send-otp', [
            'email' => 'superadmin@example.com',
            'password' => 'password123',
        ]);

        $response->assertOk();
        $response->assertJsonPath('success', true);
        $this->assertNotNull(Cache::get('superadmin_login_otp_superadmin@example.com'));
        Mail::assertSent(OTPMail::class);
    }

    public function test_superadmin_login_is_verified_with_otp(): void
    {
        Mail::fake();
        $user = $this->createSuperAdminUser();

        $this->postJson('/api/superadmin/login/send-otp', [
            'email' => $user->email,
            'password' => 'password123',
        ]);

        $otpData = Cache::get("superadmin_login_otp_{$user->email}");

        $response = $this->postJson('/api/superadmin/login/verify-otp', [
            'email' => $user->email,
            'password' => 'password123',
            'otp' => $otpData['otp'],
        ]);

        $response->assertOk();
        $response->assertJsonPath('success', true);
        $response->assertJsonPath('redirect', '/sadmin/dashboard');
        $this->assertAuthenticated();
    }
}
