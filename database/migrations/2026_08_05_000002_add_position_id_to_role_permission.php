<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

return new class extends Migration
{
    public function up(): void
    {
        if (!Schema::hasTable('role_permission')) {
            return;
        }

        Schema::table('role_permission', function (Blueprint $table) {
            if (!Schema::hasColumn('role_permission', 'position_id')) {
                $table->char('position_id', 32)->nullable()->after('permission_id');
                $table->index('position_id');
            }
        });
    }

    public function down(): void
    {
        if (!Schema::hasTable('role_permission')) {
            return;
        }

        Schema::table('role_permission', function (Blueprint $table) {
            if (Schema::hasColumn('role_permission', 'position_id')) {
                $table->dropIndex(['position_id']);
                $table->dropColumn('position_id');
            }
        });
    }
};
