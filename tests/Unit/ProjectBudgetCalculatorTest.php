<?php

namespace Tests\Unit;

use App\Support\ProjectBudgetCalculator;
use PHPUnit\Framework\TestCase;

class ProjectBudgetCalculatorTest extends TestCase
{
    public function test_initial_and_income_entries_add_to_budget(): void
    {
        $entries = [
            (object) ['type' => 'Initial', 'amount' => 1000],
            (object) ['type' => 'Income', 'amount' => 250],
        ];

        $this->assertSame(1250.0, ProjectBudgetCalculator::fromLedgerEntries($entries));
    }

    public function test_expense_entries_subtract_from_budget(): void
    {
        $entries = [
            (object) ['type' => 'Initial', 'amount' => 1000],
            (object) ['type' => 'Expense', 'amount' => 150],
        ];

        $this->assertSame(850.0, ProjectBudgetCalculator::fromLedgerEntries($entries));
    }

    public function test_transfer_out_subtracts_from_source_project_budget(): void
    {
        $entries = [
            (object) ['type' => 'Initial', 'amount' => 1000],
            (object) ['type' => 'Transfer', 'amount' => 125],
        ];

        $this->assertSame(875.0, ProjectBudgetCalculator::fromLedgerEntries($entries));
    }

    public function test_initial_transfer_credits_destination_project_budget(): void
    {
        $entries = [
            (object) ['type' => 'Initial Transfer', 'amount' => 125],
        ];

        $this->assertSame(125.0, ProjectBudgetCalculator::fromLedgerEntries($entries));
    }

    public function test_has_mismatch_detects_negative_stored_budgets(): void
    {
        $this->assertTrue(ProjectBudgetCalculator::hasMismatch(-188.0, 1000.0, true));
    }

    public function test_has_mismatch_skips_projects_without_ledger_entries(): void
    {
        $this->assertFalse(ProjectBudgetCalculator::hasMismatch(-188.0, 0.0, false));
    }
}
