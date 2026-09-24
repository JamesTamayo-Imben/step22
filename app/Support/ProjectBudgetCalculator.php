<?php

namespace App\Support;

class ProjectBudgetCalculator
{
    /**
     * Compute a project's budget total from approved ledger entries.
     *
     * Credits: Initial*, Income, Donation, Sponsorship
    * Debits: Expense, Asset purchase, Transfer (out) — but not Initial Transfer (destination credit)
     */
    public static function fromLedgerEntries(iterable $entries): float
    {
        $computed = 0.0;

        foreach ($entries as $entry) {
            $amount = (float) ($entry->amount ?? 0);
            $type = strtolower((string) ($entry->type ?? ''));

            $isCredit = str_contains($type, 'initial')
                || in_array($type, ['income', 'donation', 'sponsorship'], true);
            $isDebit = in_array($type, ['expense', 'asset'], true)
                || (str_contains($type, 'transfer') && ! str_contains($type, 'initial'));

            if ($isCredit) {
                $computed += $amount;
            } elseif ($isDebit) {
                $computed -= $amount;
            }
        }

        return round($computed, 2);
    }

    public static function hasMismatch(float $storedBudget, float $computedBudget, bool $hasApprovedEntries = true): bool
    {
        if (! $hasApprovedEntries) {
            return false;
        }

        return abs($storedBudget - $computedBudget) > 0.01;
    }
}
