<?php

namespace Database\Seeders;

use App\Models\Role;
use Illuminate\Database\Seeder;

class RoleSeeder extends Seeder
{
    /**
     * Run the database seeds.
     */
    public function run(): void
    {
        Role::create([
            'name' => 'Student',
            'slug' => 'student',
            'description' => 'Regular student user',
        ]);

        Role::create([
            'name' => 'Adviser',
            'slug' => 'adviser',
            'description' => 'Faculty adviser or counselor',
        ]);

        Role::create([
            'name' => 'CSG Officer',
            'slug' => 'csg_officer',
            'description' => 'CSG Leadership Officer',
        ]);

        Role::create([
            'name' => 'Superadmin',
            'slug' => 'superadmin',
            'description' => 'System administrator with full access',
        ]);
    }
}
