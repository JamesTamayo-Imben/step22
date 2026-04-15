<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\DB;
use Illuminate\Support\Facades\Schema;

return new class extends Migration
{
    /**
     * Run the migrations.
     */
    public function up(): void
    {
        // Drop the incorrect foreign key constraint
        DB::statement('ALTER TABLE `teacher_adviser` DROP FOREIGN KEY `teacher_adviser_ibfk_2`');

        // Create the correct foreign key constraint pointing to institute table
        DB::statement('ALTER TABLE `teacher_adviser` ADD CONSTRAINT `teacher_adviser_ibfk_2` FOREIGN KEY (`institute_id`) REFERENCES `institute` (`id`) ON DELETE SET NULL');
    }

    /**
     * Reverse the migrations.
     */
    public function down(): void
    {
        // Drop the correct foreign key constraint
        DB::statement('ALTER TABLE `teacher_adviser` DROP FOREIGN KEY `teacher_adviser_ibfk_2`');

        // Restore the old (incorrect) foreign key constraint
        DB::statement('ALTER TABLE `teacher_adviser` ADD CONSTRAINT `teacher_adviser_ibfk_2` FOREIGN KEY (`institute_id`) REFERENCES `permission` (`id`) ON DELETE SET NULL');
    }
};
