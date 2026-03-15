<?php

namespace Database\Seeders;

use App\Models\User;
use App\Models\Role;
use Illuminate\Database\Seeder;
use Illuminate\Support\Facades\Hash;

class CreateSupabaseUsersSeeder extends Seeder
{
    /**
     * Run the database seeds.
     * 
     * This seeder creates users from your Supabase accounts.
     * You can manually add users here or modify as needed.
     */
    public function run(): void
    {
        // Get the student role
        $studentRole = Role::where('slug', 'student')->first();
        $adviserRole = Role::where('slug', 'adviser')->first();
        $csgRole = Role::where('slug', 'csg_officer')->first();
        $adminRole = Role::where('slug', 'superadmin')->first();

        // Create users from Supabase
        // Example: ako jim from Supabase
        User::updateOrCreate(
            ['email' => 'jimj8731@gmail.com'],
            [
                'name' => 'ako jim',
                'password' => Hash::make('password123'), // Set a default password or leave null
                'provider' => 'google',
                'provider_id' => '724671fb-4142-40bf-a430-cc0530888f8', // From Supabase UID
                'avatar_url' => 'https://lh3.googleusercontent.com/a/default-user=s96-c', // Replace with actual avatar
                'department' => 'Computer Science',
                'year_level' => 'Junior',
                'role_id' => $adviserRole?->id,
                'is_active' => true,
            ]
        );

        // Add more users as needed
        // Example:
        // User::firstOrCreate(
        //     ['email' => 'email@example.com'],
        //     [
        //         'name' => 'User Name',
        //         'password' => Hash::make('password123'),
        //         'provider' => 'google',
        //         'provider_id' => 'google_uid_here',
        //         'avatar_url' => 'https://...',
        //         'department' => 'Computer Science',
        //         'year_level' => 'Junior',
        //         'role_id' => $studentRole?->id,
        //         'is_active' => true,
        //     ]
        // );
    }
}
