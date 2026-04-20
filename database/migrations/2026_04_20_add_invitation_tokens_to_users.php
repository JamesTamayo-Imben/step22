<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

return new class extends Migration
{
    /**
     * Run the migrations.
     */
    public function up(): void
    {
        Schema::table('users', function (Blueprint $table) {
            // Add invitation token columns
            $table->string('invitation_token', 64)->nullable()->unique()->after('email_verified_at');
            $table->timestamp('token_expires_at')->nullable()->after('invitation_token');
            $table->boolean('is_token_expired')->default(false)->after('token_expires_at');
        });
    }

    /**
     * Reverse the migrations.
     */
    public function down(): void
    {
        Schema::table('users', function (Blueprint $table) {
            $table->dropUnique(['invitation_token']);
            $table->dropColumn(['invitation_token', 'token_expires_at', 'is_token_expired']);
        });
    }
};
