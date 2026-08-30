<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

return new class extends Migration
{
    public function up(): void
    {
        Schema::create('teacher_adviser', function (Blueprint $table) {
            $table->string('id', 100)->primary();
            $table->uuid('user_id')->nullable();
            $table->uuid('institute_id')->nullable();
            $table->boolean('is_adviser')->default(false);
            $table->timestamps();
            $table->boolean('archive')->default(false);

            $table->foreign('user_id')->references('id')->on('users')->cascadeOnDelete();
            $table->foreign('institute_id')->references('id')->on('institute')->nullOnDelete();
        });
    }

    public function down(): void
    {
        Schema::dropIfExists('teacher_adviser');
    }
};
