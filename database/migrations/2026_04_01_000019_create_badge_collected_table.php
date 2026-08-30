<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

return new class extends Migration
{
    public function up(): void
    {
        Schema::create('badge_collected', function (Blueprint $table) {
            $table->uuid('id')->primary();
            $table->uuid('badge_id');
            $table->uuid('user_id');
            $table->timestamp('earned_date')->useCurrent();
            $table->timestamp('created_at')->useCurrent();
            $table->boolean('archive')->default(false);

            $table->unique(['badge_id', 'user_id'], 'unique_user_badge');
            $table->index('user_id', 'idx_user_id');
            $table->index('badge_id', 'idx_badge_id');
            $table->index('earned_date', 'idx_earned_date');

            $table->foreign('badge_id')->references('id')->on('badge')->cascadeOnDelete();
            $table->foreign('user_id')->references('id')->on('users')->cascadeOnDelete();
        });
    }

    public function down(): void
    {
        Schema::dropIfExists('badge_collected');
    }
};
