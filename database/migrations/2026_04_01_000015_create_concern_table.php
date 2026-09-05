<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

return new class extends Migration
{
    public function up(): void
    {
        Schema::create('concern', function (Blueprint $table) {
            $table->uuid('id')->primary();
            $table->string('user_id', 100)->nullable();
            $table->string('concern')->nullable();
            $table->boolean('favorite')->default(false);
            $table->timestamp('created_at')->nullable();

            $table->index('user_id');
        });
    }

    public function down(): void
    {
        Schema::dropIfExists('concern');
    }
};
