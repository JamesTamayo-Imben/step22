<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\DB;
use Illuminate\Support\Facades\Schema;

return new class extends Migration
{
    public function up(): void
    {
        Schema::create('chain', function (Blueprint $table) {
            $table->uuid('id')->primary();
            $table->uuid('project_id')->nullable();
            $table->integer('block_index')->default(0);
            $table->string('prev_hash')->nullable();
            $table->string('hash')->nullable();
            $table->text('data_snapshot')->nullable();
            $table->timestamp('created_at')->useCurrent();

            $table->foreign('project_id')->references('id')->on('projects')->cascadeOnDelete();
        });

        if (DB::connection()->getDriverName() === 'mysql') {
            // Chain records are append-only on MySQL/MariaDB.
            DB::unprepared('
                CREATE TRIGGER prevent_chain_deletes BEFORE DELETE ON chain FOR EACH ROW BEGIN
                    SIGNAL SQLSTATE \'45000\' SET MESSAGE_TEXT = \'Chain records cannot be deleted\';
                END
            ');

            DB::unprepared('
                CREATE TRIGGER prevent_chain_updates BEFORE UPDATE ON chain FOR EACH ROW BEGIN
                    SIGNAL SQLSTATE \'45000\' SET MESSAGE_TEXT = \'Chain records cannot be updated\';
                END
            ');
        }
    }

    public function down(): void
    {
        if (DB::connection()->getDriverName() === 'mysql') {
            DB::unprepared('DROP TRIGGER IF EXISTS prevent_chain_deletes');
            DB::unprepared('DROP TRIGGER IF EXISTS prevent_chain_updates');
        }
        Schema::dropIfExists('chain');
    }
};
