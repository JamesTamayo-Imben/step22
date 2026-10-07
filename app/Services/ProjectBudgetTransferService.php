<?php

namespace App\Services;

use App\Models\CSG\LedgerEntry;
use App\Models\CSG\Project;
use Illuminate\Support\Facades\DB;
use Illuminate\Validation\ValidationException;

class ProjectBudgetTransferService
{
    public function debitSourceBudgets(string $destinationProjectId, $userId): void
    {
        if (DB::transactionLevel() === 0) {
            throw new \LogicException('Transfer source debits must run inside a database transaction.');
        }

        $allocations = [];
        $sourceEntries = LedgerEntry::query()
            ->where('category', 'Transfer')
            ->where('type', 'Transfer')
            ->where('archive', 0)
            ->get();

        foreach ($sourceEntries as $entry) {
            $metadata = json_decode((string) $entry->note, true);
            if (!is_array($metadata)
                || (string) ($metadata['transfer_destination_project_id'] ?? '') !== $destinationProjectId) {
                continue;
            }

            $sourceProjectId = (string) ($metadata['transfer_source_project_id'] ?? '');
            if ($sourceProjectId === '' || (string) $entry->project_id !== $sourceProjectId) {
                throw ValidationException::withMessages([
                    'transfer_amount' => ['A transfer ledger entry has invalid source-project metadata.'],
                ]);
            }

            $allocations[$sourceProjectId] = ($allocations[$sourceProjectId] ?? 0) + (float) $entry->amount;
        }

        $destinationEntry = LedgerEntry::query()
            ->where('project_id', $destinationProjectId)
            ->where('category', 'Transfer')
            ->where('type', 'Initial Transfer')
            ->where('archive', 0)
            ->first();

        if ($destinationEntry && (float) $destinationEntry->amount > 0 && $allocations === []) {
            throw ValidationException::withMessages([
                'transfer_amount' => ['The destination transfer has no matching source ledger entries.'],
            ]);
        }

        if ($allocations === []) {
            return;
        }

        $allocatedAmount = array_sum($allocations);
        if (!$destinationEntry || abs((float) $destinationEntry->amount - $allocatedAmount) > 0.01) {
            throw ValidationException::withMessages([
                'transfer_amount' => ['The destination and source transfer ledger amounts do not match.'],
            ]);
        }

        $sources = Project::query()
            ->whereIn('id', array_keys($allocations))
            ->where('archive', 0)
            ->orderBy('id')
            ->lockForUpdate()
            ->get()
            ->keyBy(fn (Project $source): string => (string) $source->id);

        foreach ($allocations as $sourceProjectId => $amount) {
            $source = $sources->get($sourceProjectId);
            if (!$source || (float) $source->budget + 0.009 < $amount) {
                throw ValidationException::withMessages([
                    'transfer_amount' => [
                        'The source project no longer has enough available budget to approve this transfer.',
                    ],
                ]);
            }
        }

        foreach ($allocations as $sourceProjectId => $amount) {
            $source = $sources->get($sourceProjectId);
            $source->budget = max(0, (float) $source->budget - $amount);
            $source->updated_by = $userId;
            $source->updated_at = now();
            $source->save();
        }
    }
}
