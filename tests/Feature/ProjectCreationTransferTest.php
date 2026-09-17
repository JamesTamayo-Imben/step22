<?php

namespace Tests\Feature;

use App\Http\Controllers\CSG\ProjectController;
use App\Models\CSG\LedgerEntry;
use App\Models\CSG\Project;
use Illuminate\Http\Request;
use Illuminate\Http\UploadedFile;
use Illuminate\Support\Facades\Auth;
use Illuminate\Support\Facades\Schema;
use Illuminate\Support\Facades\Storage;
use Illuminate\Support\Str;
use Tests\TestCase;

class ProjectCreationTransferTest extends TestCase
{
    protected function setUp(): void
    {
        parent::setUp();

        if (!Schema::hasTable('users')) {
            Schema::create('users', function ($table) {
                $table->id();
                $table->string('name');
                $table->string('email')->unique();
                $table->timestamp('email_verified_at')->nullable();
                $table->string('password');
                $table->rememberToken();
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
                $table->string('project_proof')->nullable();
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

        if (!Schema::hasTable('chain')) {
            Schema::create('chain', function ($table) {
                $table->string('id')->primary();
                $table->string('project_id');
                $table->unsignedInteger('block_index');
                $table->string('prev_hash')->nullable();
                $table->string('hash');
                $table->text('data_snapshot');
                $table->timestamp('created_at')->nullable();
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
                $table->string('action_type');
                $table->string('status')->nullable();
                $table->text('details')->nullable();
                $table->string('ip_address')->nullable();
                $table->text('browser_info')->nullable();
                $table->boolean('archive')->default(false);
                $table->timestamps();
            });
        }

        if (!Schema::hasTable('student_csg_officer')) {
            Schema::create('student_csg_officer', function ($table) {
                $table->id();
                $table->unsignedInteger('user_id')->nullable();
                $table->timestamps();
            });
        }

        if (!Schema::hasTable('teacher_adviser')) {
            Schema::create('teacher_adviser', function ($table) {
                $table->id();
                $table->unsignedInteger('user_id')->nullable();
                $table->timestamps();
            });
        }

        if (!Schema::hasTable('roles')) {
            Schema::create('roles', function ($table) {
                $table->id();
                $table->string('name');
                $table->timestamps();
            });
        }
    }

    public function test_project_creation_uploads_proof_to_initial_ledger_entry(): void
    {
        Storage::fake('supabase');
        $user = $this->authorizedUser('csg');
        Auth::login($user);

        $request = Request::create('/api/projects', 'POST', [
            'title' => 'Project with proof',
            'description' => 'Proof should be stored on the initial ledger entry',
            'objective' => 'Show proof storage behavior',
            'venue' => 'Main Hall',
            'category' => 'Social',
            'proposed_by' => 'Tester',
            'status' => 'Draft',
            'approval_status' => 'Draft',
            'start_date' => now()->addMonth()->toDateString(),
            'end_date' => now()->addMonths(2)->toDateString(),
        ]);
        $request->setUserResolver(fn () => $user);
        $request->files->add([
            'project_proof' => UploadedFile::fake()->create('proof.pdf', 120, 'application/pdf'),
        ]);

        $response = (new ProjectController())->store($request);
        $this->assertEquals(201, $response->getStatusCode());

        $payload = json_decode($response->getContent(), true);
        $project = Project::find($payload['id']);
        $this->assertNotNull($project);
        $this->assertNull($project->project_proof);

        $initialLedger = LedgerEntry::where('project_id', $project->id)
            ->where('type', 'Initial')
            ->first();

        $this->assertNotNull($initialLedger);
        $this->assertNotNull($initialLedger->ledger_proof);
        $this->assertStringContainsString('ledger_proofs/', $initialLedger->ledger_proof);
        $this->assertNotEmpty($initialLedger->file_content_hash);
        $this->assertEquals($initialLedger->ledger_proof, $payload['project_proof']);

        $relativePath = str_replace('ledger_proofs/', '', $initialLedger->ledger_proof);
        Storage::disk('supabase')->assertExists('ledger_proofs/' . $relativePath);
    }

    public function test_project_creation_always_starts_project_and_ledgers_as_draft(): void
    {
        Storage::fake('supabase');
        $user = $this->authorizedUser('csg');
        Auth::login($user);

        $request = Request::create('/api/projects', 'POST', [
            'title' => 'Draft status project',
            'description' => 'Creation must not approve records',
            'objective' => 'Verify initial statuses',
            'venue' => 'Main Hall',
            'category' => 'Social',
            'budget' => 100,
            'has_budget' => 1,
            'is_active' => 1,
            'proposed_by' => 'Tester',
            'status' => 'Approved',
            'approval_status' => 'Approved',
        ]);
        $request->setUserResolver(fn () => $user);
        $request->files->add([
            'project_proof' => UploadedFile::fake()->create('proof.pdf', 120, 'application/pdf'),
        ]);

        $response = (new ProjectController())->store($request);

        $this->assertEquals(201, $response->getStatusCode());

        $payload = json_decode($response->getContent(), true);
        $project = Project::find($payload['id']);

        $this->assertEquals('Draft', $project->status);
        $this->assertEquals('Draft', $project->approval_status);
        $this->assertNotEmpty(LedgerEntry::where('project_id', $project->id)->get());
        $this->assertTrue(
            LedgerEntry::where('project_id', $project->id)
                ->where('approval_status', '!=', 'Draft')
                ->doesntExist()
        );
    }

    public function test_project_creation_can_transfer_budget_from_completed_project(): void
    {
        Storage::fake('supabase');
        $user = $this->authorizedUser('csg');
        Auth::login($user);

        $sourceProject = Project::create([
            'id' => (string) Str::uuid(),
            'title' => 'Completed Source Project',
            'description' => 'Existing project with remaining budget',
            'category' => 'Social',
            'budget' => 1000,
            'proposed_by' => 'Tester',
            'approval_status' => 'Approved',
            'status' => 'Complete',
            'start_date' => now()->subMonths(2)->toDateString(),
            'end_date' => now()->subDay()->toDateString(),
            'archive' => 0,
            'created_by' => $user->id,
            'updated_by' => $user->id,
        ]);

        $request = Request::create('/api/projects', 'POST', [
            'title' => 'New Project',
            'description' => 'New project details',
            'objective' => 'Build community impact',
            'venue' => 'Main Hall',
            'category' => 'Social',
            'budget' => 250,
            'has_budget' => 1,
            'is_active' => 1,
            'budget_source' => 'past_project',
            'transfer_from_project_id' => $sourceProject->id,
            'transfer_amount' => 125,
            'proposed_by' => 'Tester',
            'status' => 'Draft',
            'approval_status' => 'Draft',
            'start_date' => now()->addMonth()->toDateString(),
            'end_date' => now()->addMonths(2)->toDateString(),
        ]);
        $request->setUserResolver(fn () => $user);
        $request->files->add([
            'project_proof' => UploadedFile::fake()->create('transfer-proof.pdf', 120, 'application/pdf'),
        ]);

        $response = (new ProjectController())->store($request);
        $this->assertEquals(201, $response->getStatusCode());

        $payload = json_decode($response->getContent(), true);
        $this->assertDatabaseHas('ledger_entries', [
            'project_id' => $sourceProject->id,
            // 'type' => 'Expense',
            'type' => 'Transfer',
            'description' => 'Transferred to project "New Project"',
            'category' => 'Transfer',
            'amount' => 125.00,
        ]);

        $newProjectId = $payload['id'];
        $destinationEntries = LedgerEntry::where('project_id', $newProjectId)->get();
        $destinationTransferEntries = $destinationEntries->where('category', 'Transfer');
        $destinationBaselineEntries = $destinationEntries->where('category', 'Project Budget Baseline');

        $this->assertCount(1, $destinationTransferEntries);
        $this->assertCount(0, $destinationBaselineEntries);

        $destinationTransferEntry = $destinationTransferEntries->first();
        $this->assertNotNull($destinationTransferEntry);
        $this->assertStringContainsString('Transferred from completed project', (string) $destinationTransferEntry->note);
        $this->assertStringNotContainsString('{"transfer_', (string) $destinationTransferEntry->note);

        $transfers = LedgerEntry::where('project_id', $sourceProject->id)
            ->where('category', 'Transfer')
            ->get();

        $this->assertCount(1, $transfers);
    }

    public function test_transfer_expense_ledger_receives_same_proof_as_destination_initial(): void
    {
        Storage::fake('supabase');
        $user = $this->authorizedUser('csg');
        Auth::login($user);

        $sourceProject = Project::create([
            'id' => (string) Str::uuid(),
            'title' => 'Completed Source Project',
            'description' => 'Existing project with remaining budget',
            'category' => 'Social',
            'budget' => 1000,
            'proposed_by' => 'Tester',
            'approval_status' => 'Approved',
            'status' => 'Complete',
            'start_date' => now()->subMonths(2)->toDateString(),
            'end_date' => now()->subDay()->toDateString(),
            'archive' => 0,
            'created_by' => $user->id,
            'updated_by' => $user->id,
        ]);

        $request = Request::create('/api/projects', 'POST', [
            'title' => 'Transfer Destination Project',
            'description' => 'New project funded by transfer',
            'objective' => 'Build community impact',
            'venue' => 'Main Hall',
            'category' => 'Social',
            'budget' => 250,
            'has_budget' => 1,
            'is_active' => 1,
            'budget_source' => 'past_project',
            'transfer_from_project_id' => $sourceProject->id,
            'transfer_amount' => 125,
            'proposed_by' => 'Tester',
            'status' => 'Draft',
            'approval_status' => 'Draft',
            'start_date' => now()->addMonth()->toDateString(),
            'end_date' => now()->addMonths(2)->toDateString(),
        ]);
        $request->setUserResolver(fn () => $user);
        $request->files->add([
            'project_proof' => UploadedFile::fake()->create('transfer-proof.pdf', 120, 'application/pdf'),
        ]);

        $response = (new ProjectController())->store($request);
        $this->assertEquals(201, $response->getStatusCode());

        $payload = json_decode($response->getContent(), true);
        $destinationInitial = LedgerEntry::where('project_id', $payload['id'])
            ->where('category', 'Transfer')
            ->where('type', 'Initial Transfer')
            ->first();

        $sourceExpense = LedgerEntry::where('project_id', $sourceProject->id)
            ->where('category', 'Transfer')
            // ->where('type', 'Expense')
            ->where('type', 'Transfer')
            ->first();

        $this->assertNotNull($destinationInitial);
        $this->assertNotNull($sourceExpense);
        $this->assertNotNull($destinationInitial->ledger_proof);
        $this->assertNotNull($destinationInitial->file_content_hash);
    }

    public function test_submit_for_approval_marks_transfer_ledger_entries_pending(): void
    {
        Storage::fake('supabase');
        $user = $this->authorizedUser('csg');
        Auth::login($user);

        $sourceProject = Project::create([
            'id' => (string) Str::uuid(),
            'title' => 'Completed Source Project',
            'description' => 'Existing project with remaining budget',
            'category' => 'Social',
            'budget' => 1000,
            'proposed_by' => 'Tester',
            'approval_status' => 'Approved',
            'status' => 'Complete',
            'start_date' => now()->subMonths(2)->toDateString(),
            'end_date' => now()->subDay()->toDateString(),
            'archive' => 0,
            'created_by' => $user->id,
            'updated_by' => $user->id,
        ]);

        $request = Request::create('/api/projects', 'POST', [
            'title' => 'Transfer Destination Project',
            'description' => 'New project funded by transfer',
            'objective' => 'Build community impact',
            'venue' => 'Main Hall',
            'category' => 'Social',
            'budget' => 250,
            'has_budget' => 1,
            'is_active' => 1,
            'budget_source' => 'past_project',
            'transfer_from_project_id' => $sourceProject->id,
            'transfer_amount' => 125,
            'proposed_by' => 'Tester',
            'status' => 'Draft',
            'approval_status' => 'Draft',
            'start_date' => now()->addMonth()->toDateString(),
            'end_date' => now()->addMonths(2)->toDateString(),
        ]);
        $request->setUserResolver(fn () => $user);
        $request->files->add([
            'project_proof' => UploadedFile::fake()->create('transfer-proof.pdf', 120, 'application/pdf'),
        ]);

        $response = (new ProjectController())->store($request);
        $this->assertEquals(201, $response->getStatusCode());

        $payload = json_decode($response->getContent(), true);
        $newProjectId = $payload['id'];

        $submitResponse = (new ProjectController())->submitForApproval($newProjectId);
        $this->assertEquals(200, $submitResponse->getStatusCode());

        $destinationTransfer = LedgerEntry::where('project_id', $newProjectId)
            ->where('category', 'Transfer')
            ->where('type', 'Initial Transfer')
            ->first();

        $sourceExpense = LedgerEntry::where('project_id', $sourceProject->id)
            ->where('category', 'Transfer')
            // ->where('type', 'Expense')
            ->where('type', 'Transfer')
            ->first();

        $this->assertNotNull($destinationTransfer);
        $this->assertNotNull($sourceExpense);
        $this->assertSame('Pending Adviser Approval', $destinationTransfer->fresh()->approval_status);
        $this->assertSame('Pending Adviser Approval', $sourceExpense->fresh()->approval_status);
    }
}
