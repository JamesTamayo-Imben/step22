<?php

namespace App\Console\Commands;

use App\Models\CSG\Asset;
use App\Models\CSG\AssetUsage;
use Illuminate\Console\Command;
use Illuminate\Support\Facades\DB;

class ReturnExpiredAssets extends Command
{
    protected $signature = 'assets:return-expired';
    protected $description = 'Return assets from approved projects whose end date has passed';

    public function handle(): int
    {
        $returned = 0;

        DB::transaction(function () use (&$returned): void {
            AssetUsage::query()
                ->where('status', 'assigned')
                ->whereColumn('returned_quantity', '<', 'quantity')
                ->whereHas('ledgerEntry', function ($query): void {
                    $query->where('approval_status', 'Approved')
                        ->whereHas('project', function ($projectQuery): void {
                            $projectQuery
                                ->whereNotNull('end_date')
                                ->whereDate('end_date', '<', today());
                        });
                })
                ->lockForUpdate()
                ->get()
                ->each(function (AssetUsage $usage) use (&$returned): void {
                    $outstanding = $usage->quantity - $usage->returned_quantity;
                    $asset = Asset::whereKey($usage->asset_id)->lockForUpdate()->first();

                    if (!$asset || $outstanding <= 0) {
                        return;
                    }

                    $asset->increment('available_quantity', $outstanding);
                    $asset->update(['status' => 'available']);
                    $usage->update([
                        'returned_quantity' => $usage->quantity,
                        'returned_at' => now(),
                        'returned_by' => null,
                        'status' => 'returned',
                    ]);
                    $returned++;
                });
        });

        $this->info("Returned {$returned} asset allocation(s).");
        return self::SUCCESS;
    }
}
