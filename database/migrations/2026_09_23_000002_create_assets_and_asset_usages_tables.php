<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\DB;
use Illuminate\Support\Facades\Schema;

return new class extends Migration
{
    public function up(): void
    {
        Schema::create('assets', function (Blueprint $table) {
            $table->uuid('id')->primary();
            $table->uuid('source_ledger_entry_id');
            $table->uuid('project_id');
            $table->string('name');
            $table->string('asset_category')->nullable()->after('name');
            $table->text('description')->nullable();
            $table->unsignedInteger('quantity');
            $table->unsignedInteger('available_quantity');
            $table->decimal('unit_cost', 15, 2)->default(0);
            $table->enum('status', ['available', 'unavailable', 'archived'])->default('available');
            $table->boolean('archive')->default(false);
            $table->timestamps();
            $table->foreign('source_ledger_entry_id')->references('id')->on('ledger_entries')->cascadeOnDelete();
            $table->foreign('project_id')->references('id')->on('projects')->cascadeOnDelete();
            $table->index(['status', 'archive']);
        });

        Schema::create('asset_usages', function (Blueprint $table) {
            $table->uuid('id')->primary();
            $table->uuid('asset_id');
            $table->uuid('project_id')->nullable();
            $table->uuid('ledger_entry_id');
            $table->unsignedInteger('quantity');
            $table->enum('status', ['assigned', 'returned'])->default('assigned');
            $table->timestamp('assigned_at')->nullable();
            $table->unsignedInteger('returned_quantity')->default(0);
            $table->timestamp('returned_at')->nullable();
            $table->uuid('returned_by')->nullable();
            $table->timestamps();
            $table->foreign('asset_id')->references('id')->on('assets')->cascadeOnDelete();
            $table->foreign('project_id')->references('id')->on('projects')->nullOnDelete();
            $table->foreign('ledger_entry_id')->references('id')->on('ledger_entries')->cascadeOnDelete();
            $table->foreign('returned_by')->references('id')->on('users')->nullOnDelete();
            $table->unique(['asset_id', 'ledger_entry_id']);
            $table->index(['project_id', 'status']);
        });

        DB::statement("ALTER TABLE ledger_entries MODIFY type ENUM('Income','Expense','Asset','Canvas','Donation','Sponsorship','Initial','Transfer','Initial Transfer') NOT NULL");
    }

    public function down(): void
    {
        DB::statement("ALTER TABLE ledger_entries MODIFY type ENUM('Income','Expense','Canvas','Donation','Sponsorship','Initial','Transfer','Initial Transfer') NOT NULL");
        Schema::dropIfExists('asset_usages');
        Schema::dropIfExists('assets');
    }
};
