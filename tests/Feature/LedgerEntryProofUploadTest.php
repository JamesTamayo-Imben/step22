<?php

namespace Tests\Feature;

use App\Http\Controllers\CSG\LedgerEntryController;
use App\Models\CSG\LedgerEntry;
use App\Models\CSG\Project;
use App\Models\User;
use Illuminate\Http\Request;
use Illuminate\Http\UploadedFile;
use Illuminate\Support\Facades\Schema;
use Illuminate\Support\Facades\Storage;
use Illuminate\Support\Str;
use Tests\TestCase;

class LedgerEntryProofUploadTest extends TestCase
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
                $table->string('project_proof')->nullable();
                $table->string('file_content_hash')->nullable();
                $table->boolean('archive')->default(false);
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
    }

    public function test_store_persists_uploaded_proof_path_to_ledger_entry(): void
    {
        Storage::fake('public');

        $user = User::create([
            'name' => 'Tester',
            'email' => 'tester' . Str::random(4) . '@example.com',
            'password' => bcrypt('password'),
        ]);

        $project = Project::create([
            'id' => (string) Str::uuid(),
            'title' => 'Proof Project',
            'description' => 'Test project',
            'objective' => 'Objective',
            'venue' => 'Venue',
            'category' => 'Social',
            'budget' => 100,
            'proposed_by' => 'Tester',
            'approval_status' => 'Draft',
            'status' => 'Draft',
            'archive' => 0,
            'created_by' => $user->id,
            'updated_by' => $user->id,
        ]);

        $request = Request::create('/api/ledger-entries', 'POST', [
            'project_id' => $project->id,
            'type' => 'Expense',
            'description' => 'Test ledger entry',
            'amount' => 50,
            'approval_status' => 'Draft',
        ]);
        $request->setUserResolver(fn () => $user);
        $request->files->add([
            'proof_file' => UploadedFile::fake()->create('receipt.pdf', 120, 'application/pdf'),
        ]);

        $response = (new LedgerEntryController())->store($request);

        $this->assertEquals(201, $response->getStatusCode());

        $entry = LedgerEntry::query()->where('project_id', $project->id)->latest('created_at')->first();
        $this->assertNotNull($entry);
        $this->assertNotNull($entry->ledger_proof);
        $this->assertStringContainsString('storage/ledger_proofs/', $entry->ledger_proof);
        $this->assertNotNull($entry->file_content_hash);
    }
}
