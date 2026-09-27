<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

return new class extends Migration
{
    public function up(): void
    {
        Schema::create('asset_disposals', function (Blueprint $table) {
            $table->uuid('id')->primary();
            $table->uuid('asset_id')->nullable()->index();
            $table->uuid('source_ledger_entry_id')->nullable()->index();
            $table->string('asset_name');
            $table->string('asset_category')->nullable();
            $table->string('project_name')->nullable();
            $table->unsignedInteger('quantity');
            $table->text('reason');
            $table->uuid('disposed_by')->nullable();
            $table->timestamps();
            $table->foreign('disposed_by')->references('id')->on('users')->nullOnDelete();
        });
    }

    public function down(): void
    {
        Schema::dropIfExists('asset_disposals');
    }
};