<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

return new class extends Migration
{
    public function up(): void
    {
        Schema::create('ratings', function (Blueprint $table) {
            $table->uuid('id')->primary();
            $table->uuid('project_id')->nullable();
            $table->uuid('user_id')->nullable();
            $table->integer('satisfaction_rating')->nullable();
            $table->integer('completeness_rating')->nullable();
            $table->integer('engagement_rating')->nullable();
            $table->text('comments')->nullable();
            $table->integer('helpful_count')->default(0);
            $table->timestamp('created_at')->useCurrent();
            $table->boolean('archive')->default(false);

            $table->unique(['project_id', 'user_id'], 'unique_project_user_rating');

            $table->foreign('project_id')->references('id')->on('projects')->cascadeOnDelete();
            $table->foreign('user_id')->references('id')->on('users')->nullOnDelete();
        });
    }

    public function down(): void
    {
        Schema::dropIfExists('ratings');
    }
};
