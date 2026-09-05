<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

return new class extends Migration
{
    public function up(): void
    {
        Schema::create('push_subscriptions', function (Blueprint $table) {
            $table->uuid('id')->primary();
            $table->uuid('user_id');
            $table->string('endpoint', 2048);
            $table->text('auth_key');
            $table->text('public_key');
            $table->boolean('is_active')->default(true);
            $table->timestamps();
            $table->boolean('archive')->default(false);

            $table->unique('endpoint');
            $table->index(['user_id', 'is_active']);
            $table->index('is_active');
            $table->foreign('user_id')->references('id')->on('users')->cascadeOnDelete();
        });
    }

    public function down(): void
    {
        Schema::dropIfExists('push_subscriptions');
    }
};