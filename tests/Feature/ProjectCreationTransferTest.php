<?php

namespace Tests\Feature;

use App\Http\Controllers\Adviser\AdviserApprovalController;
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
                $table->string('type')->nullable();
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

    private function grantProjectEditPermission($user): void
    {
        $permission = \App\Models\Permission::query()->firstOrCreate(
            ['permission' => 'projects.edit'],
            [
                'id' => (string) Str::uuid(),
                'module' => 'projects',
                'action' => 'edit',
                'archive' => false,
            ]
        );
        $pivot = [
            'role_id' => $user->role_id,
            'permission_id' => $permission->id,
        ];
        if (Schema::hasColumn('role_permission', 'position_id')) {
            $pivot['position_id'] = null;
        }

        if (!\Illuminate\Support\Facades\DB::table('role_permission')->where($pivot)->exists()) {
            \Illuminate\Support\Facades\DB::table('role_permission')->insert([
                'id' => (string) Str::uuid(),
                'user_id' => null,
                ...$pivot,
                'created_at' => now(),
            ]);
        }
    }

    public function test_project_creation_uploads_proof_to_initial_ledger_entry(): void
    {
        $user = $this->authorizedUser('csg');
        Auth::login($user);

        $request = Request::create('/api/projects', 'POST', [
            'title' => 'Project with proof',
            'description' => 'Proof should be stored on the initial ledger entry',
            'objective' => 'Show proof storage behavior',
            'venue' => 'Main Hall',
            'category' => 'Social',
            'type' => 'event',
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
            'type' => 'event',
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

    public function test_project_creation_includes_new_budget_source_details_in_initial_ledger_description(): void
    {
        Storage::fake('supabase');
        $user = $this->authorizedUser('csg');
        Auth::login($user);

        $request = Request::create('/api/projects', 'POST', [
            'title' => 'Funding source project',
            'description' => 'This project supports student wellness activities.',
            'objective' => 'Support student wellness activities',
            'venue' => 'Main Hall',
            'category' => 'Health',
            'type' => 'event',
            'budget' => 2500,
            'has_budget' => 1,
            'budget_source' => 'none',
            'budget_source_type' => 'sponsorship',
            'budget_source_details' => 'ABC Corporation',
            'proposed_by' => 'Tester',
            'status' => 'Draft',
            'approval_status' => 'Draft',
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
        $this->assertStringNotContainsString('Sponsorship', (string) $project->description);

        $initialLedger = LedgerEntry::where('project_id', $project->id)
            ->where('type', 'Initial')
            ->first();

        $this->assertNotNull($initialLedger);
        $this->assertStringContainsString('Sponsorship', (string) $initialLedger->description);
        $this->assertStringContainsString('ABC Corporation', (string) $initialLedger->description);
    }

    public function test_project_creation_accepts_multiple_budget_source_entries_for_initial_ledger_description(): void
    {
        Storage::fake('supabase');
        $user = $this->authorizedUser('csg');
        Auth::login($user);

        $request = Request::create('/api/projects', 'POST', [
            'title' => 'Multiple funding sources project',
            'description' => 'This project supports multiple funding sources.',
            'objective' => 'Support all project needs',
            'venue' => 'Main Hall',
            'category' => 'Health',
            'type' => 'event',
            'budget' => 2000,
            'has_budget' => 1,
            'budget_source' => 'none',
            'budget_source_type' => 'sponsorship,donation',
            'budget_source_details' => json_encode([
                'sponsorship' => [
                    ['name' => 'ABC Corporation', 'amount' => 1200],
                    ['name' => 'Student Council', 'amount' => 300],
                ],
                'donation' => [
                    ['name' => 'Community Donors', 'amount' => 500],
                ],
            ]),
            'proposed_by' => 'Tester',
            'status' => 'Draft',
            'approval_status' => 'Draft',
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

        $initialLedger = LedgerEntry::where('project_id', $project->id)
            ->where('type', 'Initial')
            ->first();

        $this->assertNotNull($initialLedger);
        $this->assertStringContainsString('Sponsorship came from:', (string) $initialLedger->description);
        $this->assertStringContainsString('Donation came from:', (string) $initialLedger->description);
        $this->assertStringContainsString('ABC Corporation', (string) $initialLedger->description);
        $this->assertStringContainsString('Community Donors', (string) $initialLedger->description);

        $breakdown = json_decode((string) $initialLedger->budget_breakdown, true);
        $this->assertIsArray($breakdown);
        $this->assertNotEmpty($breakdown);
        $this->assertContains('Sponsorship', array_column($breakdown, 'source'));
        $this->assertContains('Donation', array_column($breakdown, 'source'));
        $this->assertContains('ABC Corporation', array_column($breakdown, 'name'));
        $this->assertContains('Community Donors', array_column($breakdown, 'name'));
    }

    public function test_adviser_project_serialization_includes_initial_budget_breakdown(): void
    {
        Storage::fake('supabase');
        $user = $this->authorizedUser('csg');
        Auth::login($user);

        $request = Request::create('/api/projects', 'POST', [
            'title' => 'Project with sponsor breakdown',
            'description' => 'This project is funded by sponsors.',
            'objective' => 'Support upcoming activities',
            'venue' => 'Main Hall',
            'category' => 'Community',
            'type' => 'event',
            'budget' => 2500,
            'has_budget' => 1,
            'budget_source' => 'none',
            'budget_source_type' => 'sponsorship,donation',
            'budget_source_details' => json_encode([
                'sponsorship' => [
                    ['name' => 'ABC Corporation', 'amount' => 1500],
                ],
                'donation' => [
                    ['name' => 'Community Donors', 'amount' => 1000],
                ],
            ]),
            'proposed_by' => 'Tester',
            'status' => 'Draft',
            'approval_status' => 'Draft',
        ]);
        $request->setUserResolver(fn () => $user);
        $request->files->add([
            'project_proof' => UploadedFile::fake()->create('proof.pdf', 120, 'application/pdf'),
        ]);

        $response = (new ProjectController())->store($request);
        $this->assertEquals(201, $response->getStatusCode());

        $project = \App\Models\User\Project::query()->where('title', 'Project with sponsor breakdown')->first();
        $this->assertNotNull($project);

        $method = new \ReflectionMethod(AdviserApprovalController::class, 'serializeProject');
        $method->setAccessible(true);
        $serialized = $method->invoke(new AdviserApprovalController(), $project, 'Pending Approval');

        $this->assertNotEmpty($serialized['budget_breakdown']);
        $this->assertContains('Sponsorship', array_column($serialized['budget_breakdown'], 'source'));
        $this->assertContains('Donation', array_column($serialized['budget_breakdown'], 'source'));
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
            'type' => 'event',
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

    public function test_fundraiser_budget_scope_only_transfers_from_completed_fundraiser_projects(): void
    {
        Storage::fake('supabase');
        $user = $this->authorizedUser('csg');
        Auth::login($user);

        $fundraiserProject = Project::create([
            'id' => (string) Str::uuid(),
            'title' => 'Completed Fundraiser',
            'description' => 'Fundraiser source project',
            'category' => 'Social',
            'type' => 'fundraiser',
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
        $otherProject = Project::create([
            'id' => (string) Str::uuid(),
            'title' => 'Another Completed Fundraiser',
            'description' => 'Another fundraiser source project',
            'category' => 'Social',
            'type' => 'fundraiser',
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
            'title' => 'Fundraiser-Funded Project',
            'description' => 'New project funded from fundraiser remaining funds',
            'objective' => 'Use fundraiser funds only',
            'venue' => 'Main Hall',
            'category' => 'Social',
            'type' => 'merchandise',
            'budget' => 100,
            'has_budget' => 1,
            'budget_source' => 'past_project',
            'remaining_budget_scope' => 'fundraiser',
            'transfer_from_project_id' => $fundraiserProject->id,
            'transfer_amount' => 100,
            'proposed_by' => 'Tester',
        ]);
        $request->setUserResolver(fn () => $user);
        $request->files->add([
            'project_proof' => UploadedFile::fake()->create('transfer-proof.pdf', 120, 'application/pdf'),
        ]);

        $response = (new ProjectController())->store($request);

        $this->assertEquals(201, $response->getStatusCode());
        $this->assertDatabaseHas('ledger_entries', [
            'project_id' => $fundraiserProject->id,
            'type' => 'Transfer',
            'amount' => 100,
        ]);
        $this->assertDatabaseMissing('ledger_entries', [
            'project_id' => $otherProject->id,
            'type' => 'Transfer',
        ]);
        $this->assertDatabaseHas('projects', [
            'title' => 'Fundraiser-Funded Project',
            'type' => 'merchandise',
        ]);

        $overLimitRequest = Request::create('/api/projects', 'POST', [
            'title' => 'Over-limit Fundraiser Transfer',
            'description' => 'Must not combine multiple fundraiser sources',
            'objective' => 'Use only the chosen fundraiser',
            'venue' => 'Main Hall',
            'category' => 'Social',
            'type' => 'merchandise',
            'budget' => 1001,
            'has_budget' => 1,
            'budget_source' => 'past_project',
            'remaining_budget_scope' => 'fundraiser',
            'transfer_from_project_id' => $fundraiserProject->id,
            'transfer_amount' => 1001,
            'proposed_by' => 'Tester',
        ]);
        $overLimitRequest->setUserResolver(fn () => $user);
        $overLimitRequest->files->add([
            'project_proof' => UploadedFile::fake()->create('over-limit-transfer-proof.pdf', 120, 'application/pdf'),
        ]);

        $overLimitResponse = (new ProjectController())->store($overLimitRequest);

        $this->assertEquals(422, $overLimitResponse->getStatusCode());
        $this->assertDatabaseMissing('projects', [
            'title' => 'Over-limit Fundraiser Transfer',
        ]);
        $this->assertDatabaseMissing('ledger_entries', [
            'project_id' => $otherProject->id,
            'type' => 'Transfer',
        ]);
    }

    public function test_editing_project_to_fundraiser_clears_venue_and_budget(): void
    {
        $user = $this->authorizedUser('csg');
        $this->grantProjectEditPermission($user);
        Auth::login($user);

        $project = Project::create([
            'id' => (string) Str::uuid(),
            'title' => 'Existing Event Project',
            'description' => 'Existing project details',
            'category' => 'Social',
            'type' => 'event',
            'venue' => 'Main Hall',
            'budget' => 250,
            'proposed_by' => 'Tester',
            'approval_status' => 'Draft',
            'status' => 'Draft',
            'start_date' => now()->addMonth()->toDateString(),
            'end_date' => now()->addMonths(2)->toDateString(),
            'archive' => 0,
            'created_by' => $user->id,
            'updated_by' => $user->id,
        ]);
        LedgerEntry::create([
            'id' => (string) Str::uuid(),
            'project_id' => $project->id,
            'type' => 'Initial',
            'amount' => 250,
            'category' => 'Initial',
            'approval_status' => 'Draft',
            'archive' => 0,
            'created_by' => $user->id,
            'updated_by' => $user->id,
        ]);

        $request = Request::create('/api/projects/' . $project->id, 'POST', [
            'title' => 'School Fundraiser',
            'description' => 'Fundraising activity',
            'objective' => 'Raise funds',
            'venue' => '',
            'category' => 'Social',
            'type' => 'fundraiser',
            'budget' => 250,
            'has_budget' => 1,
            'budget_source' => 'none',
            'proposed_by' => 'Tester',
        ]);
        $request->setUserResolver(fn () => $user);

        $response = (new ProjectController())->update($request, $project->id);

        $this->assertEquals(200, $response->getStatusCode());
        $project->refresh();
        $this->assertSame('fundraiser', $project->type);
        $this->assertNull($project->venue);
        $this->assertSame(0.0, (float) $project->budget);
        $this->assertSame(0.0, (float) LedgerEntry::where('project_id', $project->id)
            ->where('type', 'Initial')
            ->where('archive', 0)
            ->value('amount'));
    }

    public function test_editing_fundraiser_preserves_balance_from_approved_ledger_entries(): void
    {
        $user = $this->authorizedUser('csg');
        $this->grantProjectEditPermission($user);
        Auth::login($user);

        $project = Project::create([
            'id' => (string) Str::uuid(),
            'title' => 'Established Fundraiser',
            'description' => 'Raised funds must remain available',
            'category' => 'Social',
            'type' => 'fundraiser',
            'budget' => 700,
            'proposed_by' => 'Tester',
            'approval_status' => 'Approved',
            'status' => 'Approved',
            'archive' => 0,
            'created_by' => $user->id,
            'updated_by' => $user->id,
        ]);

        foreach ([
            ['Initial', 500],
            ['Donation', 300],
            ['Expense', 100],
        ] as [$type, $amount]) {
            LedgerEntry::create([
                'id' => (string) Str::uuid(),
                'project_id' => $project->id,
                'type' => $type,
                'amount' => $amount,
                'category' => $type === 'Initial' ? 'Initial' : 'Ledger',
                'approval_status' => 'Approved',
                'archive' => 0,
                'created_by' => $user->id,
                'updated_by' => $user->id,
            ]);
        }

        $request = Request::create('/api/projects/' . $project->id, 'PUT', [
            'title' => 'Established Fundraiser Updated',
            'type' => 'fundraiser',
            'has_budget' => 0,
            'budget' => 0,
            'budget_source' => 'none',
        ]);
        $request->setUserResolver(fn () => $user);

        $response = (new ProjectController())->update($request, $project->id);

        $this->assertEquals(200, $response->getStatusCode());
        $this->assertSame(700.0, (float) $project->fresh()->budget);
        $this->assertSame(500.0, (float) LedgerEntry::where('project_id', $project->id)
            ->where('type', 'Initial')
            ->where('archive', 0)
            ->value('amount'));
    }

    public function test_later_competing_transfer_is_rejected_without_changing_source_balance(): void
    {
        $user = $this->authorizedUser('csg');
        $source = Project::create([
            'id' => (string) Str::uuid(),
            'title' => 'Completed Source',
            'type' => 'event',
            'budget' => 1000,
            'approval_status' => 'Approved',
            'archive' => 0,
        ]);
        $destinations = [];

        foreach ([700, 500] as $amount) {
            $destination = Project::create([
                'id' => (string) Str::uuid(),
                'title' => 'Transfer Destination',
                'type' => 'event',
                'budget' => $amount,
                'approval_status' => 'Pending Adviser Approval',
                'archive' => 0,
            ]);
            $destinations[] = $destination;

            LedgerEntry::create([
                'id' => (string) Str::uuid(),
                'project_id' => $destination->id,
                'type' => 'Initial Transfer',
                'amount' => $amount,
                'category' => 'Transfer',
                'approval_status' => 'Pending Adviser Approval',
                'archive' => 0,
            ]);
            LedgerEntry::create([
                'id' => (string) Str::uuid(),
                'project_id' => $source->id,
                'type' => 'Transfer',
                'amount' => $amount,
                'category' => 'Transfer',
                'approval_status' => 'Pending Adviser Approval',
                'note' => json_encode([
                    'transfer_source_project_id' => $source->id,
                    'transfer_destination_project_id' => $destination->id,
                ]),
                'archive' => 0,
            ]);
        }

        $service = app(\App\Services\ProjectBudgetTransferService::class);
        \Illuminate\Support\Facades\DB::transaction(function () use ($service, $destinations, $user): void {
            $service->debitSourceBudgets((string) $destinations[0]->id, $user->id);
        });

        try {
            \Illuminate\Support\Facades\DB::transaction(function () use ($service, $destinations, $user): void {
                $service->debitSourceBudgets((string) $destinations[1]->id, $user->id);
            });
            $this->fail('The second transfer should be rejected when funds are insufficient.');
        } catch (\Illuminate\Validation\ValidationException $exception) {
            $this->assertArrayHasKey('transfer_amount', $exception->errors());
        }

        $this->assertSame(300.0, (float) $source->fresh()->budget);
        $this->assertSame('Pending Adviser Approval', $destinations[1]->fresh()->approval_status);
    }

    public function test_csg_approval_path_rejects_transfer_when_source_balance_is_insufficient(): void
    {
        $user = $this->authorizedUser('csg');
        $this->grantProjectEditPermission($user);
        Auth::login($user);

        $source = Project::create([
            'id' => (string) Str::uuid(),
            'title' => 'Low-balance Source',
            'type' => 'event',
            'budget' => 300,
            'approval_status' => 'Approved',
            'archive' => 0,
        ]);
        $destination = Project::create([
            'id' => (string) Str::uuid(),
            'title' => 'Pending Destination',
            'type' => 'event',
            'budget' => 500,
            'approval_status' => 'Pending Adviser Approval',
            'archive' => 0,
        ]);

        LedgerEntry::create([
            'id' => (string) Str::uuid(),
            'project_id' => $destination->id,
            'type' => 'Initial Transfer',
            'amount' => 500,
            'category' => 'Transfer',
            'approval_status' => 'Pending Adviser Approval',
            'archive' => 0,
        ]);
        LedgerEntry::create([
            'id' => (string) Str::uuid(),
            'project_id' => $source->id,
            'type' => 'Transfer',
            'amount' => 500,
            'category' => 'Transfer',
            'approval_status' => 'Pending Adviser Approval',
            'note' => json_encode([
                'transfer_source_project_id' => $source->id,
                'transfer_destination_project_id' => $destination->id,
            ]),
            'archive' => 0,
        ]);

        $request = Request::create('/api/projects/' . $destination->id, 'PUT', [
            'approval_status' => 'Approved',
            'venue' => 'Main Hall',
        ]);
        $request->setUserResolver(fn () => $user);

        try {
            (new ProjectController())->update($request, $destination->id);
            $this->fail('Approval should fail when the source cannot cover the transfer.');
        } catch (\Illuminate\Validation\ValidationException $exception) {
            $this->assertArrayHasKey('transfer_amount', $exception->errors());
        }

        $this->assertSame(300.0, (float) $source->fresh()->budget);
        $this->assertSame('Pending Adviser Approval', $destination->fresh()->approval_status);
    }

    public function test_editing_approved_transfer_project_does_not_restore_its_original_allocation(): void
    {
        $user = $this->authorizedUser('csg');
        $this->grantProjectEditPermission($user);
        Auth::login($user);

        $project = Project::create([
            'id' => (string) Str::uuid(),
            'title' => 'Approved Transfer Project',
            'description' => 'Current balance is below initial allocation',
            'category' => 'Social',
            'type' => 'event',
            'budget' => 350,
            'proposed_by' => 'Tester',
            'approval_status' => 'Approved',
            'status' => 'Ongoing',
            'archive' => 0,
            'created_by' => $user->id,
            'updated_by' => $user->id,
        ]);

        LedgerEntry::create([
            'id' => (string) Str::uuid(),
            'project_id' => $project->id,
            'type' => 'Initial Transfer',
            'amount' => 500,
            'category' => 'Transfer',
            'approval_status' => 'Approved',
            'ledger_proof' => 'existing-proof.pdf',
            'archive' => 0,
        ]);
        LedgerEntry::create([
            'id' => (string) Str::uuid(),
            'project_id' => $project->id,
            'type' => 'Expense',
            'amount' => 150,
            'category' => 'Ledger',
            'approval_status' => 'Approved',
            'archive' => 0,
        ]);

        $request = Request::create('/api/projects/' . $project->id, 'PUT', [
            'title' => 'Approved Transfer Project Updated',
            'type' => 'event',
            'venue' => 'Main Hall',
            'has_budget' => 1,
            'budget' => 500,
            'budget_source' => 'past_project',
            'transfer_amount' => 500,
            'remaining_budget_scope' => 'overall',
        ]);
        $request->setUserResolver(fn () => $user);

        $response = (new ProjectController())->update($request, $project->id);

        $this->assertEquals(200, $response->getStatusCode());
        $this->assertSame(350.0, (float) $project->fresh()->budget);
        $this->assertSame(500.0, (float) LedgerEntry::where('project_id', $project->id)
            ->where('type', 'Initial Transfer')
            ->where('archive', 0)
            ->value('amount'));
    }

    public function test_edit_fundraiser_scope_transfers_only_from_selected_fundraiser(): void
    {
        Storage::fake('supabase');
        $user = $this->authorizedUser('csg');
        $this->grantProjectEditPermission($user);
        Auth::login($user);

        $targetProject = Project::create([
            'id' => (string) Str::uuid(),
            'title' => 'Transfer Destination',
            'description' => 'Destination project',
            'category' => 'Social',
            'type' => 'event',
            'venue' => 'Main Hall',
            'budget' => 0,
            'project_proof' => 'existing-project-proof.pdf',
            'proposed_by' => 'Tester',
            'approval_status' => 'Draft',
            'status' => 'Draft',
            'archive' => 0,
            'created_by' => $user->id,
            'updated_by' => $user->id,
        ]);
        $selectedFundraiser = Project::create([
            'id' => (string) Str::uuid(),
            'title' => 'Selected Fundraiser',
            'description' => 'Eligible source',
            'category' => 'Social',
            'type' => 'fundraiser',
            'budget' => 100,
            'proposed_by' => 'Tester',
            'approval_status' => 'Approved',
            'status' => 'Complete',
            'start_date' => now()->subMonths(2)->toDateString(),
            'end_date' => now()->subDay()->toDateString(),
            'archive' => 0,
            'created_by' => $user->id,
            'updated_by' => $user->id,
        ]);
        $otherFundraiser = Project::create([
            'id' => (string) Str::uuid(),
            'title' => 'Other Fundraiser',
            'description' => 'Must not be used as a fallback',
            'category' => 'Social',
            'type' => 'fundraiser',
            'budget' => 500,
            'proposed_by' => 'Tester',
            'approval_status' => 'Approved',
            'status' => 'Complete',
            'start_date' => now()->subMonths(2)->toDateString(),
            'end_date' => now()->subDay()->toDateString(),
            'archive' => 0,
            'created_by' => $user->id,
            'updated_by' => $user->id,
        ]);

        $request = Request::create('/api/projects/' . $targetProject->id, 'POST', [
            'title' => 'Transfer Destination',
            'description' => 'Destination project',
            'objective' => 'Use one chosen fundraiser',
            'venue' => 'Main Hall',
            'category' => 'Social',
            'type' => 'event',
            'budget' => 75,
            'has_budget' => 1,
            'budget_source' => 'past_project',
            'remaining_budget_scope' => 'fundraiser',
            'transfer_from_project_id' => $selectedFundraiser->id,
            'transfer_amount' => 75,
            'proposed_by' => 'Tester',
        ]);
        $request->setUserResolver(fn () => $user);

        $response = (new ProjectController())->update($request, $targetProject->id);

        $this->assertEquals(200, $response->getStatusCode());
        $this->assertDatabaseHas('ledger_entries', [
            'project_id' => $selectedFundraiser->id,
            'type' => 'Transfer',
            'amount' => 75,
        ]);
        $this->assertDatabaseMissing('ledger_entries', [
            'project_id' => $otherFundraiser->id,
            'type' => 'Transfer',
        ]);
    }

    public function test_fundraiser_project_starts_with_zero_budget_without_a_venue(): void
    {
        $user = $this->authorizedUser('csg');
        Auth::login($user);

        $request = Request::create('/api/projects', 'POST', [
            'title' => 'School Fundraiser',
            'description' => 'Fundraising project without an event venue',
            'objective' => 'Raise funds for student activities',
            'category' => 'Social',
            'type' => 'fundraiser',
            'budget' => 5000,
            'has_budget' => 1,
            'budget_source' => 'past_project',
            'transfer_amount' => 5000,
            'proposed_by' => 'Tester',
        ]);
        $request->setUserResolver(fn () => $user);

        $response = (new ProjectController())->store($request);

        $this->assertEquals(201, $response->getStatusCode());
        $payload = json_decode($response->getContent(), true);
        $project = Project::findOrFail($payload['id']);

        $this->assertSame('fundraiser', $project->type);
        $this->assertNull($project->venue);
        $this->assertSame(0.0, (float) $project->budget);
        $this->assertSame(0, LedgerEntry::where('project_id', $project->id)->count());
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
            'type' => 'event',
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
            'type' => 'event',
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
