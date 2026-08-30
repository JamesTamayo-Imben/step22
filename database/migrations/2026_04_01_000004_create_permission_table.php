<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

return new class extends Migration
{
    public function up(): void
    {
        Schema::create('permission', function (Blueprint $table) {
            $table->uuid('id')->primary();
            $table->string('module')->nullable();
            $table->string('action')->nullable();
            $table->string('permission')->nullable();
            $table->text('description')->nullable();
            $table->timestamps();
            $table->boolean('archive')->default(false);
        });
    }

    public function down(): void
    {
        Schema::dropIfExists('permission');
    }
};
