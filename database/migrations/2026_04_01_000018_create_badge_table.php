<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

return new class extends Migration
{
    public function up(): void
    {
        Schema::create('badge', function (Blueprint $table) {
            $table->uuid('id')->primary();
            $table->string('name');
            $table->text('description')->nullable();
            $table->string('icon')->nullable();
            $table->string('category', 100)->nullable();
            $table->timestamps();
            $table->boolean('archive')->default(false);

            $table->index('category', 'idx_category');
        });
    }

    public function down(): void
    {
        Schema::dropIfExists('badge');
    }
};
