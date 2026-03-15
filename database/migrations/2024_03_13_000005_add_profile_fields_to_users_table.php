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
            // Profile information
            $table->string('department')->nullable()->after('email');
            $table->string('year_level')->nullable()->after('department');
            $table->text('bio')->nullable()->after('year_level');
            
            // Role reference (direct foreign key instead of pivot table)
            $table->foreignId('role_id')->nullable()->after('year_level')->constrained('roles')->onDelete('set null');
            
            // Authentication provider info
            $table->string('provider')->nullable()->after('password'); // 'google', 'local', etc.
            $table->string('provider_id')->nullable()->unique()->after('provider'); // OAuth provider ID
            $table->string('avatar_url')->nullable()->after('provider_id'); // Profile picture URL from OAuth
            
            // Account status
            $table->timestamp('last_login_at')->nullable()->after('email_verified_at');
            $table->boolean('is_active')->default(true)->after('last_login_at');
            
            // Make password nullable for OAuth users who haven't set one yet
            $table->string('password')->nullable()->change();
        });
    }

    /**
     * Reverse the migrations.
     */
    public function down(): void
    {
        Schema::table('users', function (Blueprint $table) {
            $table->dropForeignKey(['role_id']);
            $table->dropColumn([
                'department',
                'year_level',
                'bio',
                'role_id',
                'provider',
                'provider_id',
                'avatar_url',
                'last_login_at',
                'is_active',
            ]);
            
            // Revert password back to non-nullable
            $table->string('password')->nullable(false)->change();
        });
    }
};
