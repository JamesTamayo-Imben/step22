<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

return new class extends Migration
{
    public function up(): void
    {
        Schema::create('course', function (Blueprint $table) {
            $table->uuid('id')->primary();
            $table->uuid('institute_id')->nullable();
            $table->string('name')->nullable();
            $table->text('description')->nullable();
            $table->timestamps();
            $table->boolean('archive')->default(false);

            $table->foreign('institute_id')->references('id')->on('institute')->cascadeOnDelete();
        });
    }

    public function down(): void
    {
        Schema::dropIfExists('course');
    }
};
