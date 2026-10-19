<?php

namespace Tests\Feature\Auth;

use App\Models\Role;
use App\Models\User;
use Illuminate\Foundation\Testing\RefreshDatabase;
use Illuminate\Support\Str;
use Tests\TestCase;

class RateLimitingTest extends TestCase
{
    use RefreshDatabase;

    protected function createUser(string $email = 'student@kld.edu.ph'): User
    {
        $role = Role::create([
            'id' => (string) Str::uuid(),
            'name' => 'Student',
            'slug' => 'student',
            'description' => 'Student role',
            'archive' => false,
        ]);

        return User::factory()->create([
            'role_id' => $role->id,
            'email' => $email,
            'password' => bcrypt('password123'),
            'status' => 'active',
            'archive' => false,
        ]);
    }

    public function test_api_login_locks_the_account_after_too_many_failed_attempts(): void
    {
        $user = $this->createUser();

        // The first attempts are rejected as invalid credentials.
        for ($i = 0; $i < 5; $i++) {
            $this->postJson('/api/login', [
                'email' => $user->email,
                'password' => 'wrong-password',
            ])->assertStatus(401);
        }

        // The account is now locked, even with the correct password.
        $response = $this->postJson('/api/login', [
            'email' => $user->email,
            'password' => 'password123',
        ]);

        $response->assertStatus(429);
        $response->assertJsonPath('success', false);
        $this->assertGuest();
    }

    public function test_api_login_is_rate_limited_for_unknown_accounts(): void
    {
        for ($i = 0; $i < 5; $i++) {
            $this->postJson('/api/login', [
                'email' => 'ghost@kld.edu.ph',
                'password' => 'wrong-password',
            ])->assertStatus(401);
        }

        $this->postJson('/api/login', [
            'email' => 'ghost@kld.edu.ph',
            'password' => 'wrong-password',
        ])->assertStatus(429);
    }

    public function test_a_successful_login_clears_the_failed_attempt_counter(): void
    {
        $user = $this->createUser();

        for ($i = 0; $i < 3; $i++) {
            $this->postJson('/api/login', [
                'email' => $user->email,
                'password' => 'wrong-password',
            ])->assertStatus(401);
        }

        $this->postJson('/api/login', [
            'email' => $user->email,
            'password' => 'password123',
        ])->assertStatus(200);

        // The account is not locked out after a successful login.
        $this->postJson('/api/login', [
            'email' => $user->email,
            'password' => 'password123',
        ])->assertStatus(200);
    }

    public function test_web_login_is_rate_limited(): void
    {
        $user = $this->createUser();

        $response = $this->post('/login', [
            'email' => $user->email,
            'password' => 'wrong-password',
        ]);

        $response->assertSessionHasErrors('email');
        $this->assertGuest();
    }

    public function test_registration_endpoints_are_rate_limited(): void
    {
        // The same account is used for every attempt so the per account
        // limiter is the one under test.
        $this->postJson('/api/auth/register-student', [
            'firstName' => 'Test',
            'lastName' => 'Student',
            'email' => 'new.student@kld.edu.ph',
            'password' => 'password123',
            'studentId' => '2024-1-0001',
            'role' => 'student',
        ])->assertStatus(201);

        for ($i = 0; $i < 4; $i++) {
            $this->postJson('/api/auth/register-student', [
                'firstName' => 'Test',
                'lastName' => 'Student',
                'email' => 'new.student@kld.edu.ph',
                'password' => 'password123',
                'studentId' => '2024-1-0001',
                'role' => 'student',
            ]);
        }

        $this->postJson('/api/auth/register-student', [
            'firstName' => 'Test',
            'lastName' => 'Student',
            'email' => 'new.student@kld.edu.ph',
            'password' => 'password123',
            'studentId' => '2024-1-0001',
            'role' => 'student',
        ])->assertStatus(429);
    }

    public function test_the_rate_limited_response_contains_a_retry_after_header(): void
    {
        for ($i = 0; $i < 6; $i++) {
            $this->postJson('/api/login', [
                'email' => 'ghost2@kld.edu.ph',
                'password' => 'wrong-password',
            ]);
        }

        $response = $this->postJson('/api/login', [
            'email' => 'ghost2@kld.edu.ph',
            'password' => 'wrong-password',
        ]);

        $response->assertStatus(429);
        $response->assertHeader('Retry-After');
    }
}
