<?php

namespace Database\Seeders;

use App\Models\Role;
use App\Models\User;
use Illuminate\Database\Seeder;
use Illuminate\Support\Str;

class SuperAdminSeeder extends Seeder
{
    public function run(): void
    {
        // Get or create superadmin role
        $role = Role::query()->firstOrCreate(
            ['slug' => 'superadmin'],
            ['name' => 'Super Admin']
        );

        // Get credentials from .env only - NO HARDCODED FALLBACKS
        $email = env('SEED_SUPERADMIN_EMAIL');
        $name = env('SEED_SUPERADMIN_NAME');
        $password = env('SEED_SUPERADMIN_PASSWORD');

        // Validate that all required env variables are set
        if (!$email || !$name || !$password) {
            throw new \Exception(
                'Missing superadmin credentials in .env file. Please set: ' .
                'SEED_SUPERADMIN_EMAIL, SEED_SUPERADMIN_NAME, SEED_SUPERADMIN_PASSWORD'
            );
        }

        $user = User::query()->where('email', $email)->first();

        if (!$user) {
            User::query()->create([
                'id' => (string) Str::uuid(),
                'role_id' => $role->id,
                'name' => $name,
                'email' => $email,
                'password' => $password,
                'status' => 'active',
                'archive' => false,
                'email_verified_at' => now(),
            ]);
            
            $this->command->info('Super Admin created successfully!');
        } else {
            $user->update([
                'role_id' => $role->id, 
                'name' => $name,
                'password' => $password,
                'status' => 'active', 
                'archive' => false
            ]);
            
            $this->command->info('Super Admin updated successfully!');
        }
    }
}