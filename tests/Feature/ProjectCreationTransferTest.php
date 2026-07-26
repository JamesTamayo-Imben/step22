<?php

namespace Tests\Feature;

use App\Models\CSG\LedgerEntry;
use App\Models\CSG\Project;
use App\Models\User;
use Illuminate\Foundation\Testing\RefreshDatabase;
use Illuminate\Support\Facades\Schema;
use Illuminate\Support\Str;
use Tests\TestCase;

class ProjectCreationTransferTest extends TestCase
{
    use RefreshDatabase;

    protected function setUp(): void
    {
        parent::setUp();

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
                $table->text('note')->nullable();
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
                $table->string('action_type');
                $table->string('status')->nullable();
                $table->text('details')->nullable();
                $table->string('ip_address')->nullable();
                $table->text('browser_info')->nullable();
                $table->boolean('archive')->default(false);
                $table->timestamps();
            });
        }
    }

    public function test_project_creation_can_transfer_budget_from_completed_project(): void
    {
        $user = User::factory()->create();

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

        $response = $this->actingAs($user)->postJson('/api/projects', [
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

        $response->assertStatus(201);

        $this->assertDatabaseHas('ledger_entries', [
            'project_id' => $sourceProject->id,
            'type' => 'Expense',
            'description' => 'Budget transferred to project New Project',
            'category' => 'Transfer',
            'amount' => 125.00,
        ]);

        $newProjectId = $response->json('id');
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
}
