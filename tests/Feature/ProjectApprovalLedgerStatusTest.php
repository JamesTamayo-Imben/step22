<?php

namespace Tests\Feature;

use App\Http\Controllers\Adviser\AdviserApprovalController;
use App\Http\Controllers\CSG\ProjectController;
use App\Models\CSG\LedgerEntry;
use App\Models\CSG\Project;
use App\Models\User;
use Illuminate\Http\Request;
use Illuminate\Http\UploadedFile;
use Illuminate\Support\Facades\Schema;
use Illuminate\Support\Facades\Storage;
use Ramsey\Uuid\Uuid;
use Tests\TestCase;

class ProjectApprovalLedgerStatusTest extends TestCase
{
    protected function setUp(): void
    {
        parent::setUp();

        if (!Schema::hasTable('users')) {
            Schema::create('users', function ($table) {
                $table->id();
                $table->string('name');
                $table->string('email')->unique();
                $table->string('password');
                $table->timestamps();
            });
        }

        if (!Schema::hasTable('projects')) {
            Schema::create('projects', function ($table) {
                $table->string('id')->primary();
                $table->string('title');
                $table->text('description')->nullable();
                $table->text('objective')->nullable();
                $table->text('venue')->nullable();
                $table->string('category')->nullable();
                $table->decimal('budget', 12, 2)->default(0);
                $table->string('proposed_by')->nullable();
                $table->string('status')->nullable();
                $table->string('approval_status')->nullable();
                $table->string('approve_by')->nullable();
                $table->timestamp('approved_at')->nullable();
                $table->text('note')->nullable();
                $table->string('project_proof')->nullable();
                $table->string('file_content_hash')->nullable();
                $table->date('start_date')->nullable();
                $table->date('end_date')->nullable();
                $table->boolean('archive')->default(false);
                $table->boolean('is_initial')->default(false);
                $table->unsignedInteger('created_by')->nullable();
                $table->unsignedInteger('updated_by')->nullable();
                $table->timestamps();
            });
        }

        if (!Schema::hasTable('ledger_entries')) {
            Schema::create('ledger_entries', function ($table) {
                $table->string('id')->primary();
                $table->string('project_id');
                $table->string('type');
                $table->decimal('amount', 12, 2)->default(0);
                $table->text('budget_breakdown')->nullable();
                $table->string('description')->nullable();
                $table->string('category')->nullable();
                $table->string('approval_status')->default('Draft');
                $table->string('ledger_proof')->nullable();
                $table->string('file_content_hash')->nullable();
                $table->text('note')->nullable();
                $table->string('approved_by')->nullable();
                $table->timestamp('approved_at')->nullable();
                $table->timestamp('rejected_at')->nullable();
                $table->unsignedInteger('created_by')->nullable();
                $table->unsignedInteger('updated_by')->nullable();
                $table->boolean('archive')->default(false);
                $table->timestamps();
            });
        }

        if (!Schema::hasTable('audit_logs')) {
            Schema::create('audit_logs', function ($table) {
                $table->string('id')->primary();
                $table->unsignedInteger('user_id')->nullable();
                $table->string('actionable_id')->nullable();
                $table->string('actionable_type')->nullable();
                $table->string('action');
                $table->string('module');
                $table->string('action_type')->nullable();
                $table->string('status')->nullable();
                $table->text('details')->nullable();
                $table->string('ip_address')->nullable();
                $table->text('browser_info')->nullable();
                $table->boolean('archive')->default(false);
                $table->timestamps();
            });
        }

        if (!Schema::hasTable('notifications')) {
            Schema::create('notifications', function ($table) {
                $table->string('id')->primary();
                $table->unsignedInteger('user_id')->nullable();
                $table->string('title');
                $table->text('message');
                $table->string('type')->nullable();
                $table->boolean('is_read')->default(false);
                $table->boolean('archive')->default(false);
                $table->timestamps();
            });
        }
    }

    public function test_project_submission_updates_related_transfer_ledger_entries(): void
    {
        $user = User::create([
            'name' => 'Tester',
            'email' => 'tester' . uniqid() . '@example.com',
            'password' => bcrypt('password'),
        ]);

        $this->actingAs($user);

        $project = Project::create([
            'id' => (string) Uuid::uuid4(),
            'title' => 'Approval Flow Project',
            'description' => 'Test project',
            'objective' => 'Objective',
            'venue' => 'Venue',
            'category' => 'Social',
            'budget' => 500,
            'proposed_by' => 'Tester',
            'approval_status' => 'Draft',
            'status' => 'Draft',
            'archive' => 0,
            'created_by' => $user->id,
            'updated_by' => $user->id,
        ]);

        LedgerEntry::create([
            'id' => (string) Uuid::uuid4(),
            'project_id' => $project->id,
            'type' => 'Initial Transfer',
            'amount' => 500,
            'description' => 'Transferred from completed project',
            'category' => 'Transfer',
            'approval_status' => 'Draft',
            'note' => 'Transferred from completed project "Source Project" to project "Approval Flow Project"',
            'created_by' => $user->id,
            'updated_by' => $user->id,
            'archive' => 0,
        ]);

        LedgerEntry::create([
            'id' => (string) Uuid::uuid4(),
            'project_id' => $project->id,
            'type' => 'Transfer',
            'amount' => 500,
            'description' => 'Transfer proposal',
            'category' => 'Transfer',
            'approval_status' => 'Draft',
            'note' => json_encode([
                'transfer_source_project_id' => 'source-project-id',
                'transfer_destination_project_id' => $project->id,
            ]),
            'created_by' => $user->id,
            'updated_by' => $user->id,
            'archive' => 0,
        ]);

        $request = Request::create('/projects/' . $project->id, 'PUT', [
            'approval_status' => 'Pending Adviser Approval',
        ]);

        $response = (new ProjectController())->update($request, $project->id);

        $this->assertEquals(200, $response->getStatusCode());
        $this->assertDatabaseHas('ledger_entries', [
            'project_id' => $project->id,
            'type' => 'Initial Transfer',
            'approval_status' => 'Pending Adviser Approval',
        ]);
        $this->assertDatabaseHas('ledger_entries', [
            'project_id' => $project->id,
            'type' => 'Transfer',
            'approval_status' => 'Pending Adviser Approval',
        ]);
    }

    public function test_transfer_linked_projects_sync_approval_status_with_project_update(): void
    {
        $user = User::create([
            'name' => 'Tester',
            'email' => 'tester' . uniqid() . '@example.com',
            'password' => bcrypt('password'),
        ]);

        $this->actingAs($user);

        $sourceProject = Project::create([
            'id' => (string) Uuid::uuid4(),
            'title' => 'Source Project',
            'description' => 'Transfer source',
            'objective' => 'Objective',
            'venue' => 'Venue',
            'category' => 'Social',
            'budget' => 500,
            'proposed_by' => 'Tester',
            'approval_status' => 'Draft',
            'status' => 'Draft',
            'archive' => 0,
            'created_by' => $user->id,
            'updated_by' => $user->id,
        ]);

        $destinationProject = Project::create([
            'id' => (string) Uuid::uuid4(),
            'title' => 'Destination Project',
            'description' => 'Transfer destination',
            'objective' => 'Objective',
            'venue' => 'Venue',
            'category' => 'Social',
            'budget' => 500,
            'proposed_by' => 'Tester',
            'approval_status' => 'Draft',
            'status' => 'Draft',
            'archive' => 0,
            'created_by' => $user->id,
            'updated_by' => $user->id,
        ]);

        LedgerEntry::create([
            'id' => (string) Uuid::uuid4(),
            'project_id' => $sourceProject->id,
            'type' => 'Transfer',
            'amount' => 500,
            'description' => 'Transfer proposal',
            'category' => 'Transfer',
            'approval_status' => 'Draft',
            'note' => json_encode([
                'transfer_source_project_id' => $sourceProject->id,
                'transfer_destination_project_id' => $destinationProject->id,
            ]),
            'created_by' => $user->id,
            'updated_by' => $user->id,
            'archive' => 0,
        ]);

        $request = Request::create('/projects/' . $sourceProject->id, 'PUT', [
            'approval_status' => 'Pending Adviser Approval',
        ]);

        $response = (new ProjectController())->update($request, $sourceProject->id);

        $this->assertEquals(200, $response->getStatusCode());
        $sourceProject->refresh();
        $destinationProject->refresh();
        $this->assertSame('Pending Adviser Approval', $sourceProject->approval_status);
        $this->assertSame('Pending Adviser Approval', $destinationProject->approval_status);
        $this->assertDatabaseHas('ledger_entries', [
            'project_id' => $sourceProject->id,
            'type' => 'Transfer',
            'approval_status' => 'Pending Adviser Approval',
        ]);
    }

    public function test_project_rejection_updates_related_transfer_ledger_entries(): void
    {
        $user = User::create([
            'name' => 'Tester',
            'email' => 'tester' . uniqid() . '@example.com',
            'password' => bcrypt('password'),
        ]);

        $this->actingAs($user);

        $project = Project::create([
            'id' => (string) Uuid::uuid4(),
            'title' => 'Rejected Project',
            'description' => 'Test project',
            'objective' => 'Objective',
            'venue' => 'Venue',
            'category' => 'Social',
            'budget' => 500,
            'proposed_by' => 'Tester',
            'approval_status' => 'Draft',
            'status' => 'Draft',
            'archive' => 0,
            'created_by' => $user->id,
            'updated_by' => $user->id,
        ]);

        LedgerEntry::create([
            'id' => (string) Uuid::uuid4(),
            'project_id' => $project->id,
            'type' => 'Initial Transfer',
            'amount' => 500,
            'description' => 'Transferred from completed project',
            'category' => 'Transfer',
            'approval_status' => 'Draft',
            'note' => 'Transferred from completed project "Source Project" to project "Rejected Project"',
            'created_by' => $user->id,
            'updated_by' => $user->id,
            'archive' => 0,
        ]);

        $request = Request::create('/projects/' . $project->id, 'PUT', [
            'approval_status' => 'Rejected',
        ]);

        $response = (new ProjectController())->update($request, $project->id);

        $this->assertEquals(200, $response->getStatusCode());
        $this->assertDatabaseHas('ledger_entries', [
            'project_id' => $project->id,
            'type' => 'Initial Transfer',
            'approval_status' => 'Rejected',
        ]);
    }

    public function test_project_approval_does_not_create_duplicate_initial_entry_for_transfer_projects(): void
    {
        $user = User::create([
            'name' => 'Tester',
            'email' => 'tester' . uniqid() . '@example.com',
            'password' => bcrypt('password'),
        ]);

        $this->actingAs($user);

        $project = Project::create([
            'id' => (string) Uuid::uuid4(),
            'title' => 'Transfer Project',
            'description' => 'Transfer funded project',
            'objective' => 'Objective',
            'venue' => 'Venue',
            'category' => 'Social',
            'budget' => 250,
            'proposed_by' => 'Tester',
            'approval_status' => 'Pending Adviser Approval',
            'status' => 'Draft',
            'archive' => 0,
            'created_by' => $user->id,
            'updated_by' => $user->id,
        ]);

        LedgerEntry::create([
            'id' => (string) Uuid::uuid4(),
            'project_id' => $project->id,
            'type' => 'Initial Transfer',
            'amount' => 250,
            'description' => 'Transferred from completed project',
            'category' => 'Transfer',
            'approval_status' => 'Pending Adviser Approval',
            'note' => 'Transferred from completed project "Source Project" to project "Transfer Project"',
            'created_by' => $user->id,
            'updated_by' => $user->id,
            'archive' => 0,
        ]);

        Storage::fake('public');
        $request = Request::create('/adviser/approvals', 'POST', [
            'type' => 'project',
            'id' => $project->id,
            'notes' => 'Approve transfer project',
        ]);
        $request->setUserResolver(fn () => $user);
        $request->files->add([
            'approval_copy' => UploadedFile::fake()->create('approval.pdf', 120, 'application/pdf'),
        ]);

        $response = (new AdviserApprovalController())->approve($request);

        $this->assertEquals(302, $response->getStatusCode());
        $this->assertSame(1, LedgerEntry::where('project_id', $project->id)->where('type', 'Initial Transfer')->count());
        $this->assertSame(0, LedgerEntry::where('project_id', $project->id)->where('type', 'Initial')->count());
    }

    public function test_project_approval_deducts_transfer_amount_from_source_project_budget(): void
    {
        $user = User::create([
            'name' => 'Tester',
            'email' => 'tester' . uniqid() . '@example.com',
            'password' => bcrypt('password'),
        ]);

        $this->actingAs($user);

        $sourceProject = Project::create([
            'id' => (string) Uuid::uuid4(),
            'title' => 'Source Project',
            'description' => 'Transfer source',
            'objective' => 'Objective',
            'venue' => 'Venue',
            'category' => 'Social',
            'budget' => 1000,
            'proposed_by' => 'Tester',
            'approval_status' => 'Approved',
            'status' => 'Complete',
            'archive' => 0,
            'created_by' => $user->id,
            'updated_by' => $user->id,
        ]);

        $destinationProject = Project::create([
            'id' => (string) Uuid::uuid4(),
            'title' => 'Destination Project',
            'description' => 'Transfer destination',
            'objective' => 'Objective',
            'venue' => 'Venue',
            'category' => 'Social',
            'budget' => 500,
            'proposed_by' => 'Tester',
            'approval_status' => 'Pending Adviser Approval',
            'status' => 'Draft',
            'archive' => 0,
            'created_by' => $user->id,
            'updated_by' => $user->id,
        ]);

        LedgerEntry::create([
            'id' => (string) Uuid::uuid4(),
            'project_id' => $sourceProject->id,
            'type' => 'Transfer',
            'amount' => 125,
            'description' => 'Transferred to project "Destination Project"',
            'category' => 'Transfer',
            'approval_status' => 'Pending Adviser Approval',
            'note' => json_encode([
                'transfer_source_project_id' => $sourceProject->id,
                'transfer_destination_project_id' => $destinationProject->id,
            ]),
            'created_by' => $user->id,
            'updated_by' => $user->id,
            'archive' => 0,
        ]);

        LedgerEntry::create([
            'id' => (string) Uuid::uuid4(),
            'project_id' => $destinationProject->id,
            'type' => 'Initial Transfer',
            'amount' => 125,
            'description' => 'Transferred from completed project',
            'category' => 'Transfer',
            'approval_status' => 'Pending Adviser Approval',
            'note' => 'Transferred from completed project "Source Project" to project "Destination Project"',
            'created_by' => $user->id,
            'updated_by' => $user->id,
            'archive' => 0,
        ]);

        Storage::fake('public');
        $request = Request::create('/adviser/approvals', 'POST', [
            'type' => 'project',
            'id' => $destinationProject->id,
            'notes' => 'Approve transfer',
        ]);
        $request->setUserResolver(fn () => $user);
        $request->files->add([
            'approval_copy' => UploadedFile::fake()->create('approval.pdf', 120, 'application/pdf'),
        ]);

        $response = (new AdviserApprovalController())->approve($request);

        $this->assertEquals(302, $response->getStatusCode());
        $sourceProject->refresh();
        $this->assertSame(875.0, (float) $sourceProject->budget);
    }
}
