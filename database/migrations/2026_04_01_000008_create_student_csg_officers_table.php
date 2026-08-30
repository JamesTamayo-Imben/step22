<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

return new class extends Migration
{
    public function up(): void
    {
        Schema::create('student_csg_officers', function (Blueprint $table) {
            $table->string('id', 100)->primary();
            $table->uuid('user_id')->nullable();
            $table->string('course_id', 100)->nullable();
            $table->boolean('is_csg')->default(false);
            $table->string('csg_position', 100)->nullable();
            $table->date('csg_term_start')->nullable();
            $table->date('csg_term_end')->nullable();
            $table->boolean('csg_is_active')->default(true);
            $table->timestamps();
            $table->boolean('archive')->default(false);

            $table->foreign('user_id')->references('id')->on('users')->nullOnDelete();
            $table->foreign('course_id')->references('id')->on('course')->nullOnDelete();
        });
    }

    public function down(): void
    {
        Schema::dropIfExists('student_csg_officers');
    }
};
