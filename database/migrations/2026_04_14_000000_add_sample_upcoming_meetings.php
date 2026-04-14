<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\DB;
use Illuminate\Support\Str;
use Carbon\Carbon;

return new class extends Migration
{
    /**
     * Run the migrations.
     */
    public function up(): void
    {
        // Add sample upcoming meetings with future dates
        $now = Carbon::now();
        
        DB::table('meeting')->insert([
            [
                'id' => Str::uuid(),
                'student_id' => 'STU001',
                'title' => 'HR Budget Planning Session',
                'description' => 'Quarterly budget review and planning for HR department',
                'scheduled_date' => $now->copy()->addDays(5)->setHour(14)->setMinute(0),
                'is_done' => false,
                'archive' => false,
                'created_at' => $now,
                'updated_at' => $now,
            ],
            [
                'id' => Str::uuid(),
                'student_id' => 'STU002',
                'title' => 'CSG Officer Meeting',
                'description' => 'Monthly CSG officers coordination meeting',
                'scheduled_date' => $now->copy()->addDays(3)->setHour(10)->setMinute(0),
                'is_done' => false,
                'archive' => false,
                'created_at' => $now,
                'updated_at' => $now,
            ],
            [
                'id' => Str::uuid(),
                'student_id' => 'STU003',
                'title' => 'Project Review Meeting',
                'description' => 'Review of ongoing projects and progress',
                'scheduled_date' => $now->copy()->addDays(7)->setHour(15)->setMinute(30),
                'is_done' => false,
                'archive' => false,
                'created_at' => $now,
                'updated_at' => $now,
            ],
            [
                'id' => Str::uuid(),
                'student_id' => 'STU004',
                'title' => 'Event Planning Session',
                'description' => 'Plan upcoming student events and activities',
                'scheduled_date' => $now->copy()->addDays(10)->setHour(13)->setMinute(45),
                'is_done' => false,
                'archive' => false,
                'created_at' => $now,
                'updated_at' => $now,
            ],
        ]);
    }

    /**
     * Reverse the migrations.
     */
    public function down(): void
    {
        // Remove the sample meetings by their titles
        DB::table('meeting')->whereIn('title', [
            'HR Budget Planning Session',
            'CSG Officer Meeting',
            'Project Review Meeting',
            'Event Planning Session',
        ])->delete();
    }
};
