<?php

namespace Tests\Feature;

use App\Http\Controllers\CSG\LedgerEntryController;
use App\Models\CSG\Asset;
use App\Models\CSG\AssetUsage;
use App\Models\CSG\LedgerEntry;
use App\Models\CSG\Project;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Auth;
use Illuminate\Support\Facades\Schema;
use Illuminate\Support\Str;
use Tests\TestCase;

class LedgerEntryAssetEditTest extends TestCase
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
                $table->boolean('archive')->default(false);
                $table->uuid('created_by')->nullable();
                $table->uuid('updated_by')->nullable();
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
                $table->text('description')->nullable();
                $table->string('category')->nullable();
                $table->string('approval_status')->default('Draft');
                $table->string('ledger_proof')->nullable();
                $table->string('ledger_proof_original_name')->nullable();
                $table->string('file_content_hash')->nullable();
                $table->uuid('created_by')->nullable();
                $table->uuid('updated_by')->nullable();
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
                $table->string('status')->default('available');
                $table->boolean('archive')->default(false);
                $table->timestamps();
            });
        }

        if (!Schema::hasTable('asset_usages')) {
            Schema::create('asset_usages', function ($table) {
                $table->uuid('id')->primary();
                $table->uuid('asset_id');
                $table->uuid('project_id')->nullable();
                $table->uuid('ledger_entry_id');
                $table->unsignedInteger('quantity');
                $table->string('status')->default('assigned');
                $table->timestamp('assigned_at')->nullable();
                $table->unsignedInteger('returned_quantity')->default(0);
                $table->timestamp('returned_at')->nullable();
                $table->uuid('returned_by')->nullable();
                $table->timestamps();
            });
        }
    }

    public function test_draft_asset_purchase_can_be_changed_to_use_existing_inventory(): void
    {
        $actor = new class {
            public function hasPermission(string $permission): bool
            {
                return $permission === 'ledger.edit';
            }
        };
        Auth::shouldReceive('user')->once()->andReturn($actor);
        Auth::shouldReceive('id')->once()->andReturn(null);

        $project = Project::create([
            'id' => (string) Str::uuid(),
            'title' => 'Asset edit project',
            'description' => 'Test project',
            'objective' => 'Objective',
            'venue' => 'Venue',
            'category' => 'Social',
            'budget' => 100,
            'proposed_by' => 'Tester',
            'approval_status' => 'Draft',
            'status' => 'Draft',
        ]);
        $entry = LedgerEntry::create([
            'id' => (string) Str::uuid(),
            'project_id' => $project->id,
            'type' => 'Asset',
            'amount' => 40,
            'description' => 'Temporary purchase',
            'approval_status' => 'Draft',
            'budget_breakdown' => json_encode([
                ['item' => 'Temporary chair', 'qty' => 2, 'unitPrice' => 20, 'asset_category' => 'Furniture', 'asset_mode' => 'purchase'],
            ]),
        ]);
        $purchaseAsset = Asset::create([
            'source_ledger_entry_id' => $entry->id,
            'project_id' => $project->id,
            'name' => 'Temporary chair',
            'asset_category' => 'Furniture',
            'description' => 'Temporary purchase',
            'quantity' => 2,
            'available_quantity' => 0,
            'unit_cost' => 20,
            'status' => 'unavailable',
        ]);
        AssetUsage::create([
            'asset_id' => $purchaseAsset->id,
            'project_id' => $project->id,
            'ledger_entry_id' => $entry->id,
            'quantity' => 2,
            'status' => 'assigned',
            'returned_quantity' => 0,
        ]);

        $inventoryEntry = LedgerEntry::create([
            'id' => (string) Str::uuid(),
            'project_id' => $project->id,
            'type' => 'Asset',
            'amount' => 50,
            'description' => 'Approved inventory',
            'approval_status' => 'Approved',
        ]);
        $availableAsset = Asset::create([
            'source_ledger_entry_id' => $inventoryEntry->id,
            'project_id' => $project->id,
            'name' => 'Projector',
            'asset_category' => 'Electronic Devices',
            'description' => 'Available projector',
            'quantity' => 2,
            'available_quantity' => 2,
            'unit_cost' => 25,
            'status' => 'available',
        ]);

        $request = Request::create('/api/ledger-entries/' . $entry->id, 'PUT', [
            'type' => 'Asset',
            'project_id' => $project->id,
            'description' => 'Use existing projector',
            'amount' => 0,
            'asset_mode' => 'use',
            'asset_usages' => json_encode([
                ['asset_id' => $availableAsset->id, 'asset_name' => $availableAsset->name, 'quantity' => 1],
            ]),
            'budget_breakdown' => json_encode([
                ['asset_id' => $availableAsset->id, 'asset_name' => $availableAsset->name, 'asset_mode' => 'use', 'item' => $availableAsset->name, 'qty' => 1, 'quantity' => 1, 'unitPrice' => 0, 'amount' => 0],
            ]),
        ]);

        $response = (new LedgerEntryController())->update($request, $entry->id);

        $this->assertSame(200, $response->getStatusCode());
        $entry->refresh();
        $this->assertSame('0.00', $entry->amount);
        $this->assertSame('use', $entry->budget_breakdown[0]['asset_mode']);
        $this->assertSame($availableAsset->id, $entry->budget_breakdown[0]['asset_id']);
        $this->assertDatabaseMissing('assets', ['id' => $purchaseAsset->id]);
        $this->assertDatabaseMissing('asset_usages', ['asset_id' => $purchaseAsset->id]);
    }
}