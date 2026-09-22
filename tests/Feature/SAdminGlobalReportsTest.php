<?php

namespace Tests\Feature;

use App\Models\Role;
use App\Models\User;
use App\Models\User\LedgerEntry;
use App\Models\User\Project;
use App\Models\User\Rating;
use Illuminate\Foundation\Testing\RefreshDatabase;
use Illuminate\Support\Str;
use Tests\TestCase;

class SAdminGlobalReportsTest extends TestCase
{
    use RefreshDatabase;

    public function test_super_admin_global_reports_are_loaded_from_database(): void
    {
        $superAdminRole = Role::create([
            'id' => (string) Str::uuid(),
            'name' => 'Super Admin',
            'slug' => 'superadmin',
            'description' => 'System administrator',
            'archive' => false,
        ]);

        $studentRole = Role::create([
            'id' => (string) Str::uuid(),
            'name' => 'Student',
            'slug' => 'student',
            'description' => 'Student account',
            'archive' => false,
        ]);

        $user = User::factory()->create([
            'role_id' => $superAdminRole->id,
            'status' => 'active',
            'archive' => false,
        ]);

        User::factory()->count(2)->create([
            'role_id' => $studentRole->id,
            'status' => 'active',
            'archive' => false,
        ]);

        User::factory()->create([
            'role_id' => $studentRole->id,
            'status' => 'archived',
            'archive' => true,
        ]);

        $project = Project::create([
            'id' => (string) Str::uuid(),
            'student_id' => null,
            'title' => 'Community Outreach',
            'description' => 'Sample project',
            'category' => 'Academic',
            'budget' => 15000,
            'status' => 'Approved',
            'approval_status' => 'Approved',
            'approved_at' => now(),
            'archive' => false,
        ]);

        Project::create([
            'id' => (string) Str::uuid(),
            'student_id' => null,
            'title' => 'Pending Project',
            'description' => 'Pending project',
            'category' => 'Sports',
            'budget' => 5000,
            'status' => 'Pending',
            'approval_status' => 'Pending Adviser Approval',
            'archive' => false,
        ]);

        Project::create([
            'id' => (string) Str::uuid(),
            'student_id' => null,
            'title' => 'Rejected Project',
            'description' => 'Rejected project',
            'category' => 'Cultural',
            'budget' => 4000,
            'status' => 'Rejected',
            'approval_status' => 'Rejected',
            'archive' => false,
        ]);

        LedgerEntry::create([
            'id' => (string) Str::uuid(),
            'project_id' => $project->id,
            'type' => 'Income',
            'amount' => 15000,
            'description' => 'Initial fund',
            'category' => 'Initial',
            'approval_status' => 'Approved',
            'archive' => false,
        ]);

        LedgerEntry::create([
            'id' => (string) Str::uuid(),
            'project_id' => $project->id,
            'type' => 'Expense',
            'amount' => 5000,
            'description' => 'Supplies',
            'category' => 'Materials',
            'approval_status' => 'Pending Adviser Approval',
            'archive' => false,
        ]);

        Rating::create([
            'id' => (string) Str::uuid(),
            'project_id' => $project->id,
            'user_id' => $user->id,
            'satisfaction_rating' => 5,
            'engagement_rating' => 4,
            'helpful_count' => 3,
            'archive' => false,
        ]);

        $response = $this
            ->actingAs($user)
            ->get('/sadmin/global-reports');

        $response->assertOk();
        $response->assertInertia(fn ($page) => $page
            ->where('reports.totalUsers', User::where('archive', false)->count())
            ->where('reports.activeUsers', User::where('archive', false)->where('status', 'active')->count())
            ->where('reports.totalProjects', \App\Models\User\Project::where('archive', false)->count())
            ->where('reports.approvedProjects', \App\Models\User\Project::where('archive', false)->where('approval_status', 'Approved')->count())
            ->where('reports.totalLedgerEntries', \App\Models\User\LedgerEntry::where('archive', false)->count())
            ->where('reports.totalRatings', \App\Models\User\Rating::where('archive', false)->count())
            ->where('reports.byCategory.Social', 0)
            ->where('reports.byCategory.Sports', 1)
            ->where('reports.byCategory.Environmental', 0)
            ->where('reports.byCategory.Technology', 0)
            ->where('reports.byCategory.Cultural', 1)
            ->where('reports.byCategory.Education', 0)
            ->where('reports.byCategory.Health', 0)
        );
    }
}
