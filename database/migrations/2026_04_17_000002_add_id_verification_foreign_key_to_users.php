<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Support\Facades\Schema;

return new class extends Migration
{
    public function up(): void
    {
        Schema::table('users', function ($table) {
            $table->foreign('id_verification_id')
                ->references('id')
                ->on('id_verifications')
                ->nullOnDelete();
        });
    }

    public function down(): void
    {
        Schema::table('users', function ($table) {
            $table->dropForeign(['id_verification_id']);
        });
    }
};