<?php

namespace Tests\Feature;

use App\Http\Controllers\CSG\LedgerEntryController;
use App\Http\Controllers\Adviser\AdviserAssetDisposalController;
use App\Models\CSG\Asset;
use App\Models\CSG\AssetDisposal;
use App\Models\CSG\AssetUsage;
use App\Models\CSG\LedgerEntry;
use App\Models\CSG\Project;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Auth;
use Illuminate\Support\Facades\Schema;
use Illuminate\Support\Str;
use Illuminate\Validation\ValidationException;
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

        if (!Schema::hasTable('asset_disposals')) {
            Schema::create('asset_disposals', function ($table) {
                $table->uuid('id')->primary();
                $table->uuid('asset_id')->nullable();
                $table->uuid('source_ledger_entry_id')->nullable();
                $table->string('asset_name');
                $table->string('asset_category')->nullable();
                $table->string('project_name')->nullable();
                $table->unsignedInteger('quantity');
                $table->text('reason');
                $table->uuid('disposed_by')->nullable();
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

    public function test_adviser_can_dispose_available_quantity_and_preserve_purchase_total(): void
    {
        [$project, $entry, $asset] = $this->createApprovedAssetPurchase();
        $secondEntry = LedgerEntry::create([
            'id' => (string) Str::uuid(),
            'project_id' => $project->id,
            'type' => 'Asset',
            'amount' => 80,
            'description' => 'Second approved chair purchase',
            'approval_status' => 'Approved',
        ]);
        $secondAsset = Asset::create([
            'source_ledger_entry_id' => $secondEntry->id,
            'project_id' => $project->id,
            'name' => 'Chair',
            'asset_category' => 'Furniture',
            'description' => 'Second purchase of four chairs',
            'quantity' => 4,
            'available_quantity' => 2,
            'unit_cost' => 20,
            'status' => 'available',
        ]);
        $actorId = (string) Str::uuid();
        $request = Request::create('/adviser/assets/disposals', 'POST', [
            'asset_ids' => [$asset->id, $secondAsset->id],
            'quantity' => 4,
            'reason' => 'Two chairs are broken beyond repair.',
        ]);
        $request->setUserResolver(fn () => (object) ['id' => $actorId]);

        $response = app(AdviserAssetDisposalController::class)->store($request);

        $this->assertSame(302, $response->getStatusCode());
        $asset->refresh();
        $secondAsset->refresh();
        $this->assertSame(5, $asset->quantity);
        $this->assertSame(4, $secondAsset->quantity);
        $this->assertSame(1, $asset->available_quantity + $secondAsset->available_quantity);
        $this->assertSame(4, AssetDisposal::query()->sum('quantity'));
        $this->assertSame(2, AssetDisposal::query()->count());
        $this->assertDatabaseHas('asset_disposals', [
            'asset_id' => $asset->id,
            'source_ledger_entry_id' => $entry->id,
            'reason' => 'Two chairs are broken beyond repair.',
            'disposed_by' => $actorId,
        ]);
    }

    public function test_disposal_cannot_exceed_available_quantity(): void
    {
        [, $entry, $asset] = $this->createApprovedAssetPurchase();
        $request = Request::create('/adviser/assets/disposals', 'POST', [
            'asset_ids' => [$asset->id],
            'quantity' => 4,
            'reason' => 'Attempted disposal exceeds stock.',
        ]);
        $request->setUserResolver(fn () => (object) ['id' => (string) Str::uuid()]);

        try {
            app(AdviserAssetDisposalController::class)->store($request);
            $this->fail('Expected the disposal quantity to be rejected.');
        } catch (ValidationException $exception) {
            $this->assertArrayHasKey('quantity', $exception->errors());
        }

        $asset->refresh();
        $this->assertSame(3, $asset->available_quantity);
        $this->assertSame(5, $asset->quantity);
        $this->assertSame(0, AssetDisposal::query()->count());
    }

    private function createApprovedAssetPurchase(): array
    {
        $project = Project::create([
            'id' => (string) Str::uuid(),
            'title' => 'Disposal test project',
            'description' => 'Test project',
            'objective' => 'Objective',
            'venue' => 'Venue',
            'category' => 'Social',
            'budget' => 100,
            'proposed_by' => 'Tester',
            'approval_status' => 'Approved',
            'status' => 'Approved',
        ]);
        $entry = LedgerEntry::create([
            'id' => (string) Str::uuid(),
            'project_id' => $project->id,
            'type' => 'Asset',
            'amount' => 100,
            'description' => 'Approved chair purchase',
            'approval_status' => 'Approved',
        ]);
        $asset = Asset::create([
            'source_ledger_entry_id' => $entry->id,
            'project_id' => $project->id,
            'name' => 'Chair',
            'asset_category' => 'Furniture',
            'description' => 'Purchase of five chairs',
            'quantity' => 5,
            'available_quantity' => 3,
            'unit_cost' => 20,
            'status' => 'available',
        ]);

        return [$project, $entry, $asset];
    }
}