<?php

use App\Services\RolePermissionService;
use Illuminate\Database\Migrations\Migration;
use Illuminate\Support\Facades\Schema;

return new class extends Migration
{
    public function up(): void
    {
        if (!Schema::hasTable('permission') || !Schema::hasTable('role_permission') || !Schema::hasTable('roles')) {
            return;
        }

        (new RolePermissionService())->syncCatalog();
    }

    public function down(): void
    {
        // Keep seeded permissions; do not destroy role grants on rollback.
    }
};
