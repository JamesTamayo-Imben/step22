<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

return new class extends Migration
{
    public function up(): void
    {
        Schema::create('users', function (Blueprint $table) {
            $table->uuid('id')->primary();
            $table->uuid('role_id')->nullable();
            $table->string('name')->nullable();
            $table->string('email')->nullable();
            $table->timestamp('email_verified_at')->nullable();
            $table->string('invitation_token', 64)->nullable()->unique();
            $table->timestamp('token_expires_at')->nullable();
            $table->boolean('is_token_expired')->default(false);
            $table->string('phone', 20)->nullable();
            $table->string('password')->nullable();
            $table->string('avatar_url')->nullable();
            $table->boolean('profile_completed')->default(false);
            $table->uuid('id_verification_id')->nullable();
            $table->enum('status', ['active', 'suspended', 'archived'])->default('active');
            $table->timestamp('last_login_at')->nullable();
            $table->rememberToken();
            $table->timestamps();
            $table->boolean('archive')->default(false);

            $table->foreign('role_id')->references('id')->on('roles')->nullOnDelete();
        });
    }

    public function down(): void
    {
        Schema::dropIfExists('users');
    }
};
