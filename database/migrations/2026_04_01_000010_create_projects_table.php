<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

return new class extends Migration
{
    public function up(): void
    {
        Schema::create('projects', function (Blueprint $table) {
            $table->uuid('id')->primary();
            $table->string('student_id', 100)->nullable();
            $table->string('title')->nullable();
            $table->text('description')->nullable();
            $table->text('objective')->nullable();
            $table->string('category', 100)->nullable();
            $table->decimal('budget', 15, 2)->nullable();
            $table->boolean('is_initial')->default(false);
            $table->string('venue')->nullable();
            $table->string('status', 50)->nullable();
            $table->string('proposed_by')->nullable();
            $table->text('note')->nullable();
            $table->string('project_proof')->nullable();
            $table->string('file_content_hash', 64)->nullable();
            $table->date('start_date')->nullable();
            $table->date('end_date')->nullable();
            $table->string('approve_by')->nullable();
            $table->string('approval_status', 50)->nullable();
            $table->timestamp('approved_at')->nullable();
            $table->timestamps();
            $table->uuid('created_by')->nullable();
            $table->uuid('updated_by')->nullable();
            $table->boolean('archive')->default(false);

            $table->foreign('student_id')->references('id')->on('student_csg_officers')->nullOnDelete();
        });
    }

    public function down(): void
    {
        Schema::dropIfExists('projects');
    }
};
