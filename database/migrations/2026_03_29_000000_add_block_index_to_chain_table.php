<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;
use Illuminate\Support\Facades\DB;

return new class extends Migration
{
    /**
     * Run the migrations.
     */
    public function up(): void
    {
        Schema::table('chain', function (Blueprint $table) {
            // Drop the old foreign key constraint pointing to approval table
            try {
                $table->dropForeign(['approval_id']);
            } catch (\Exception $e) {
                // Foreign key might not exist
            }
        });

        // Rename approval_id to project_id using raw SQL for better compatibility
        try {
            DB::statement('ALTER TABLE `chain` CHANGE COLUMN `approval_id` `project_id` CHAR(36)');
        } catch (\Exception $e) {
            // Column might already be renamed
        }

        // Add block_index column if it doesn't exist
        Schema::table('chain', function (Blueprint $table) {
            if (!Schema::hasColumn('chain', 'block_index')) {
                $table->unsignedInteger('block_index')->default(0)->after('project_id');
            }
        });

        // Add the new foreign key constraint pointing to projects table
        Schema::table('chain', function (Blueprint $table) {
            try {
                $table->foreign('project_id')->references('id')->on('projects')->onDelete('cascade');
            } catch (\Exception $e) {
                // Foreign key might already exist
            }
        });
    }

    /**
     * Reverse the migrations.
     */
    public function down(): void
    {
        Schema::table('chain', function (Blueprint $table) {
            try {
                $table->dropForeign(['project_id']);
            } catch (\Exception $e) {
                // Ignore if doesn't exist
            }
        });

        try {
            DB::statement('ALTER TABLE `chain` CHANGE COLUMN `project_id` `approval_id` CHAR(36)');
        } catch (\Exception $e) {
            // Ignore if doesn't exist
        }

        Schema::table('chain', function (Blueprint $table) {
            try {
                $table->dropColumn('block_index');
            } catch (\Exception $e) {
                // Ignore if doesn't exist
            }
        });
    }
};
