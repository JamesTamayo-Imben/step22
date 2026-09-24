<?php

namespace Tests\Feature;

use App\Http\Controllers\CSG\LedgerEntryController;
use App\Models\CSG\Asset;
use App\Models\CSG\AssetUsage;
use App\Models\CSG\Project;
use Illuminate\Http\Request;
use Illuminate\Http\UploadedFile;
use Illuminate\Support\Facades\Auth;
use Illuminate\Support\Facades\Schema;
use Illuminate\Support\Facades\Storage;
use Illuminate\Support\Str;
use Tests\TestCase;

class AssetUsageInitialPurchaseTest extends TestCase
{
    protected function setUp(): void
    {
        parent::setUp();

        if (!Schema::hasTable('projects')) {
            Schema::create('projects', function ($table) {
                $table->uuid('id')->primary();
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
                $table->uuid('id')->primary();
                $table->uuid('project_id');
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

        if (!Schema::hasTable('assets')) {
            Schema::create('assets', function ($table) {
                $table->uuid('id')->primary();
                $table->uuid('source_ledger_entry_id');
                $table->uuid('project_id');
                $table->string('name');
                $table->string('asset_category')->nullable();
                $table->text('description')->nullable();
                $table->unsignedInteger('quantity');
                $table->unsignedInteger('available_quantity');
                $table->decimal('unit_cost', 15, 2)->default(0);
                $table->enum('status', ['available', 'unavailable', 'archived'])->default('available');
                $table->boolean('archive')->default(false);
                $table->timestamps();
            });
        } elseif (!Schema::hasColumn('assets', 'asset_category')) {
            Schema::table('assets', function ($table) {
                $table->string('asset_category')->nullable()->after('name');
            });
        }

        if (!Schema::hasTable('asset_usages')) {
            Schema::create('asset_usages', function ($table) {
                $table->uuid('id')->primary();
                $table->uuid('asset_id');
                $table->uuid('project_id')->nullable();
                $table->uuid('ledger_entry_id');
                $table->unsignedInteger('quantity');
                $table->enum('status', ['assigned', 'returned'])->default('assigned');
                $table->timestamp('assigned_at')->nullable();
                $table->unsignedInteger('returned_quantity')->default(0);
                $table->timestamp('returned_at')->nullable();
                $table->uuid('returned_by')->nullable();
                $table->timestamps();
            });
        }

        if (!Schema::hasTable('audit_logs')) {
            Schema::create('audit_logs', function ($table) {
                $table->uuid('id')->primary();
                $table->uuid('user_id')->nullable();
                $table->uuid('actionable_id')->nullable();
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

    public function test_purchasing_assets_records_initial_usage_for_the_project(): void
    {
        Storage::fake('supabase');

        $user = $this->authorizedUser('csg');
        Auth::login($user);

        $project = Project::create([
            'id' => (string) Str::uuid(),
            'title' => 'Project asset purchase',
            'description' => 'Asset must be tracked as in-use immediately',
            'objective' => 'Testing asset usage',
            'venue' => 'Main Hall',
            'category' => 'Social',
            'budget' => 5000,
            'proposed_by' => 'Test User',
            'status' => 'Draft',
            'approval_status' => 'Draft',
            'archive' => false,
            'is_initial' => false,
        ]);

        $request = Request::create('/api/ledger-entries', 'POST', [
            'project_id' => $project->id,
            'type' => 'Asset',
            'description' => 'Laptop purchase',
            'amount' => 0,
            'budget_breakdown' => json_encode([
                ['item' => 'Laptop', 'qty' => 2, 'unitPrice' => 1500, 'asset_category' => 'Electronic Devices'],
            ]),
            'asset_mode' => 'purchase',
            'approval_status' => 'Draft',
        ]);
        $request->setUserResolver(fn () => $user);
        $request->files->add([
            'proof_file' => UploadedFile::fake()->create('proof.pdf', 120, 'application/pdf'),
        ]);

        $response = (new LedgerEntryController())->store($request);

        $this->assertEquals(201, $response->getStatusCode());

        $asset = Asset::query()->where('project_id', $project->id)->first();
        $this->assertNotNull($asset);
        $this->assertEquals(2, $asset->quantity);
        $this->assertEquals(0, $asset->available_quantity);
        $this->assertEquals('Electronic Devices', $asset->asset_category);

        $this->assertDatabaseHas('asset_usages', [
            'asset_id' => $asset->id,
            'project_id' => $project->id,
            'quantity' => 2,
            'status' => 'assigned',
        ]);

        $inventoryResponse = (new LedgerEntryController())->assets(new Request([
            'mode' => 'return',
        ]));

        $inventory = json_decode($inventoryResponse->getContent(), true);
        $assetRow = collect($inventory)->firstWhere('name', 'Laptop');

        $this->assertNotNull($assetRow);
        $this->assertSame('Electronic Devices', $assetRow['asset_category']);
        $this->assertSame(0, $assetRow['available_quantity']);
        $this->assertSame('unavailable', strtolower((string) $assetRow['status']));
    }
}
