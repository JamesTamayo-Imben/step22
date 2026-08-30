<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

return new class extends Migration
{
    public function up(): void
    {
        Schema::create('audit_logs', function (Blueprint $table) {
            $table->uuid('id')->primary();
            $table->uuid('user_id')->nullable();
            $table->string('actionable_id', 100)->nullable();
            $table->string('actionable_type', 100)->nullable();
            $table->string('action')->nullable();
            $table->string('module', 100)->nullable();
            $table->string('action_type', 100)->nullable();
            $table->string('status', 50)->nullable();
            $table->text('details')->nullable();
            $table->string('ip_address', 45)->nullable();
            $table->text('browser_info')->nullable();
            $table->timestamp('created_at')->useCurrent();
            $table->boolean('archive')->default(false);

            $table->foreign('user_id')->references('id')->on('users')->nullOnDelete();
        });
    }

    public function down(): void
    {
        Schema::dropIfExists('audit_logs');
    }
};
