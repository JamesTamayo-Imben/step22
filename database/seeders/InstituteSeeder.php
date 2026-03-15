<?php

namespace Database\Seeders;

use Illuminate\Database\Console\Seeds\WithoutModelEvents;
use Illuminate\Database\Seeder;
use Illuminate\Support\Facades\DB;

class InstituteSeeder extends Seeder
{
    /**
     * Run the database seeds.
     */
    public function run(): void
    {
        DB::table('institutes')->insert([
            [
                'name' => 'College of Engineering',
                'description' => 'Department focused on engineering disciplines and technology',
                'created_at' => now(),
                'updated_at' => now(),
            ],
            [
                'name' => 'College of Business Administration',
                'description' => 'Department focused on business and management studies',
                'created_at' => now(),
                'updated_at' => now(),
            ],
            [
                'name' => 'College of Liberal Arts',
                'description' => 'Department focused on arts, humanities, and social sciences',
                'created_at' => now(),
                'updated_at' => now(),
            ],
            [
                'name' => 'College of Science',
                'description' => 'Department focused on natural and applied sciences',
                'created_at' => now(),
                'updated_at' => now(),
            ],
        ]);
    }
}
