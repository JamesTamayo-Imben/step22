<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

return new class extends Migration
{
    public function up(): void
    {
        Schema::create('approval', function (Blueprint $table) {
            $table->uuid('id')->primary();
            $table->string('employee_id', 100)->nullable();
            $table->uuid('project_id')->nullable();
            $table->uuid('approvable_id')->nullable();
            $table->string('reference_type', 100)->nullable();
            $table->string('approvable_type', 100)->nullable();
            $table->string('status', 50)->nullable();
            $table->text('rejection_reason')->nullable();
            $table->timestamp('reviewed_at')->nullable();
            $table->text('officers_approved')->nullable();
            $table->timestamps();

            $table->foreign('employee_id')->references('id')->on('teacher_adviser')->nullOnDelete();
            $table->foreign('project_id')->references('id')->on('projects')->cascadeOnDelete();
        });
    }

    public function down(): void
    {
        Schema::dropIfExists('approval');
    }
};
