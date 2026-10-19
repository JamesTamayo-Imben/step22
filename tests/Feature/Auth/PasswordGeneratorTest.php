<?php

namespace Tests\Feature\Auth;

use App\Services\PasswordGeneratorService;
use Illuminate\Foundation\Testing\RefreshDatabase;
use Tests\TestCase;

class PasswordGeneratorTest extends TestCase
{
    use RefreshDatabase;

    public function test_the_generator_endpoint_returns_a_strong_password(): void
    {
        $response = $this->postJson('/api/password/generate');

        $response->assertOk();
        $response->assertJsonPath('success', true);
        $response->assertJsonStructure(['password', 'strength' => ['score', 'label', 'entropy']]);

        $password = $response->json('password');

        $this->assertIsString($password);
        $this->assertSame(16, strlen($password));
        $this->assertMatchesRegularExpression('/[a-z]/', $password);
        $this->assertMatchesRegularExpression('/[A-Z]/', $password);
        $this->assertMatchesRegularExpression('/\d/', $password);
        $this->assertMatchesRegularExpression('/[^A-Za-z0-9]/', $password);
    }

    public function test_the_generator_endpoint_honours_the_requested_length(): void
    {
        $response = $this->postJson('/api/password/generate', ['length' => 24]);

        $response->assertOk();
        $this->assertSame(24, strlen($response->json('password')));
    }

    public function test_the_generator_endpoint_rejects_out_of_range_lengths(): void
    {
        $this->postJson('/api/password/generate', ['length' => 4])->assertStatus(422);
        $this->postJson('/api/password/generate', ['length' => 500])->assertStatus(422);
    }

    public function test_the_generator_endpoint_can_build_a_passphrase(): void
    {
        $response = $this->postJson('/api/password/generate', [
            'type' => 'passphrase',
            'words' => 4,
        ]);

        $response->assertOk();

        $password = $response->json('password');

        $this->assertStringContainsString('-', $password);
        $this->assertCount(5, explode('-', $password));
    }

    public function test_generated_passwords_are_unique(): void
    {
        $generator = app(PasswordGeneratorService::class);

        $passwords = [];

        for ($i = 0; $i < 25; $i++) {
            $passwords[] = $generator->generate(16);
        }

        $this->assertCount(25, array_unique($passwords));
    }

    public function test_the_strength_estimator_flags_weak_passwords(): void
    {
        $generator = app(PasswordGeneratorService::class);

        $weak = $generator->strength('password');
        $this->assertLessThanOrEqual(1, $weak['score']);
        $this->assertNotEmpty($weak['warnings']);

        $strong = $generator->strength('Xk9!pQ2#vB7$mZ4&');
        $this->assertGreaterThanOrEqual(3, $strong['score']);
        $this->assertTrue($strong['requirements']['mixed_case']);
        $this->assertTrue($strong['requirements']['numbers']);
        $this->assertTrue($strong['requirements']['symbols']);
    }

    public function test_the_generator_endpoint_is_rate_limited(): void
    {
        for ($i = 0; $i < 30; $i++) {
            $this->postJson('/api/password/generate');
        }

        $this->postJson('/api/password/generate')->assertStatus(429);
    }
}
