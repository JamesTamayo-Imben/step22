<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

return new class extends Migration
{
    public function up(): void
    {
        Schema::create('meeting', function (Blueprint $table) {
            $table->uuid('id')->primary();
            $table->string('student_id', 100)->nullable();
            $table->string('title')->nullable();
            $table->text('description')->nullable();
            $table->dateTime('scheduled_date')->nullable();
            $table->timestamp('created_at')->useCurrent();
            $table->boolean('is_done')->default(false);
            $table->text('minutes_content')->nullable();
            $table->text('action_items')->nullable();
            $table->text('expected_attendees')->nullable();
            $table->text('attendees')->nullable();
            $table->string('meeting_proof')->nullable();
            $table->string('file_content_hash')->nullable();
            $table->timestamp('updated_at')->useCurrent()->useCurrentOnUpdate();
            $table->boolean('archive')->default(false);

            $table->foreign('student_id')->references('id')->on('student_csg_officers')->nullOnDelete();
        });
    }

    public function down(): void
    {
        Schema::dropIfExists('meeting');
    }
};
