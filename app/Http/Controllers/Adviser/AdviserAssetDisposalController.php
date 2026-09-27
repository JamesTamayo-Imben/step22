<?php

namespace App\Http\Controllers\Adviser;

use App\Http\Controllers\Controller;
use App\Models\CSG\Asset;
use App\Models\CSG\AssetDisposal;
use App\Models\CSG\LedgerEntry;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\DB;
use Illuminate\Validation\ValidationException;

class AdviserAssetDisposalController extends Controller
{
    public function store(Request $request)
    {
        $validated = $request->validate([
            'asset_ids' => ['required', 'array', 'min:1', 'max:100'],
            'asset_ids.*' => ['required', 'uuid', 'distinct'],
            'quantity' => ['required', 'integer', 'min:1'],
            'reason' => ['required', 'string', 'max:2000'],
        ]);

        DB::transaction(function () use ($request, $validated): void {
            $assets = Asset::query()
                ->with('project:id,title')
                ->whereIn('id', $validated['asset_ids'])
                ->where('archive', false)
                ->orderBy('id')
                ->lockForUpdate()
                ->get();

            if ($assets->count() !== count($validated['asset_ids'])) {
                abort(404);
            }

            $sourceEntryIds = $assets->pluck('source_ledger_entry_id')->unique()->values();
            $approvedEntries = LedgerEntry::query()
                ->whereIn('id', $sourceEntryIds)
                ->where('type', 'Asset')
                ->where('approval_status', 'Approved')
                ->where('archive', false)
                ->lockForUpdate()
                ->get();

            if ($approvedEntries->count() !== $sourceEntryIds->count()) {
                abort(404);
            }

            $groupKeys = $assets->map(fn (Asset $asset) => strtolower(trim($asset->name)) . '|'
                . strtolower(trim($asset->asset_category ?: 'Other')))->unique();

            if ($groupKeys->count() !== 1) {
                throw ValidationException::withMessages([
                    'asset_ids' => 'Only matching asset inventory rows can be disposed together.',
                ]);
            }

            $availableQuantity = $assets->sum('available_quantity');
            if ($validated['quantity'] > $availableQuantity) {
                throw ValidationException::withMessages([
                    'quantity' => 'The disposal quantity cannot exceed the available quantity.',
                ]);
            }

            $remainingQuantity = $validated['quantity'];
            foreach ($assets as $asset) {
                $disposedQuantity = min($remainingQuantity, $asset->available_quantity);
                if ($disposedQuantity < 1) {
                    continue;
                }

                $asset->available_quantity -= $disposedQuantity;
                $asset->status = $asset->available_quantity > 0 ? 'available' : 'unavailable';
                $asset->save();

                AssetDisposal::create([
                    'asset_id' => $asset->id,
                    'source_ledger_entry_id' => $asset->source_ledger_entry_id,
                    'asset_name' => $asset->name,
                    'asset_category' => $asset->asset_category,
                    'project_name' => $asset->project?->title,
                    'quantity' => $disposedQuantity,
                    'reason' => trim($validated['reason']),
                    'disposed_by' => $request->user()->id,
                ]);

                $remainingQuantity -= $disposedQuantity;
                if ($remainingQuantity === 0) {
                    break;
                }
            }
        });

        return back()->with('success', 'Asset disposal recorded.');
    }
}