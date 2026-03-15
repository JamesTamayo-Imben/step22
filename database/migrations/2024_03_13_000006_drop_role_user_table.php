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
        // Drop the role_user pivot table since we're using role_id directly in users table
        Schema::dropIfExists('role_user');
    }

    /**
     * Reverse the migrations.
     */
    public function down(): void
    {
        Schema::create('role_user', function (Blueprint $table) {
            $table->id();
            $table->foreignId('user_id')->constrained('users')->onDelete('cascade');
            $table->foreignId('role_id')->constrained('roles')->onDelete('cascade');
            $table->timestamps();
            
            // Ensure each user-role combination is unique
            $table->unique(['user_id', 'role_id']);
        });
    }
};
