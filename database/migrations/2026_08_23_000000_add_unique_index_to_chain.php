<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

return new class extends Migration
{
    /**
     * Run the migrations.
     */
    public function up(): void
    {
        Schema::table('chain', function (Blueprint $table) {
            // Add a unique index to prevent duplicate block_index for the same project
            $table->unique(['project_id', 'block_index'], 'chain_project_block_unique');
        });
    }

    /**
     * Reverse the migrations.
     */
    public function down(): void
    {
        Schema::table('chain', function (Blueprint $table) {
            $table->dropUnique('chain_project_block_unique');
        });
    }
};
