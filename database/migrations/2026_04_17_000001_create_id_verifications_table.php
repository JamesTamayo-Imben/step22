<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

return new class extends Migration
{
    public function up(): void
    {
        Schema::create('id_verifications', function (Blueprint $table) {
            $table->uuid('id')->primary();
            $table->uuid('user_id');
            $table->enum('role_type', ['student', 'teacher']);
            $table->string('student_id')->nullable();
            $table->string('teacher_id')->nullable();
            $table->string('proof_file_path');
            $table->string('original_filename');
            $table->string('file_mime_type');
            $table->bigInteger('file_size');
            $table->enum('status', ['pending', 'approved', 'rejected'])->default('pending');
            $table->longText('admin_notes')->nullable();
            $table->uuid('verified_by')->nullable();
            $table->timestamp('verified_at')->nullable();
            $table->integer('rejection_count')->default(0);
            $table->timestamp('last_rejection_at')->nullable();
            $table->timestamps();
            $table->softDeletes();

            $table->index('student_id');
            $table->index('teacher_id');
            $table->index('user_id');
            $table->index('role_type');
            $table->index('status');
            $table->index('verified_by');
            $table->index('created_at');
            $table->foreign('student_id')->references('id')->on('student_csg_officers')->nullOnDelete();
            $table->foreign('teacher_id')->references('id')->on('teacher_adviser')->nullOnDelete();
            $table->foreign('user_id')->references('id')->on('users')->cascadeOnDelete();
            $table->foreign('verified_by')->references('id')->on('users')->nullOnDelete();
        });
    }

    public function down(): void
    {
        Schema::dropIfExists('id_verifications');
    }
};