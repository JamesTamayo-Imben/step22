<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

return new class extends Migration
{
    // NOTE: file_content_hash is intentionally left out — it is added by the existing
    // add_file_content_hash_to_ledger_entries migration already in this project.
    public function up(): void
    {
        Schema::create('ledger_entries', function (Blueprint $table) {
            $table->uuid('id')->primary();
            $table->uuid('project_id');
            $table->enum('type', [
                'Income', 'Expense', 'Donation', 'Sponsorship', 'Canvas',
                'Initial', 'Transfer', 'Initial Transfer',
            ]);
            $table->decimal('amount', 15, 2);
            $table->text('description');
            $table->string('category', 100)->nullable();
            $table->text('budget_breakdown')->nullable();
            $table->string('ledger_proof', 500)->nullable()->comment('Path to uploaded proof file');
            $table->enum('approval_status', ['Draft', 'Pending Adviser Approval', 'Approved', 'Rejected'])
                ->default('Draft');
            $table->boolean('is_initial_entry')->default(false);
            $table->text('note')->nullable()->comment('Approval/rejection notes');
            $table->uuid('approved_by')->nullable();
            $table->uuid('created_by')->nullable();
            $table->uuid('updated_by')->nullable();
            $table->timestamp('approved_at')->nullable();
            $table->timestamp('rejected_at')->nullable();
            $table->boolean('archive')->default(false);
            $table->timestamps();

            $table->foreign('project_id')->references('id')->on('projects')->cascadeOnDelete();
            $table->foreign('approved_by')->references('id')->on('users')->nullOnDelete();
            $table->foreign('created_by')->references('id')->on('users')->nullOnDelete();
            $table->foreign('updated_by')->references('id')->on('users')->nullOnDelete();
        });
    }

    public function down(): void
    {
        Schema::dropIfExists('ledger_entries');
    }
};
