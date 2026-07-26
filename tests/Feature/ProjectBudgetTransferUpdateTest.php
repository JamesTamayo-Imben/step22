<?php

namespace Tests\Feature;

use App\Http\Controllers\CSG\ProjectController;
use App\Models\CSG\LedgerEntry;
use App\Models\CSG\Project;
use Tests\TestCase;

class ProjectBudgetTransferUpdateTest extends TestCase
{
    public function test_existing_transfer_baseline_is_inferred_when_editing_budget(): void
    {
        $controller = new class extends ProjectController {
            protected function findTransferSourceEntry(string $destinationProjectId): ?LedgerEntry
            {
                $entry = new LedgerEntry();
                $entry->note = json_encode([
                    'transfer_source_project_id' => 'source-project-id',
                    'transfer_destination_project_id' => $destinationProjectId,
                ]);

                return $entry;
            }

            public function resolveBudgetUpdateContextForTest(
                Project $project,
                ?LedgerEntry $baseline,
                string $budgetSource,
                ?string $transferFromProjectId,
                float $transferAmount,
                float $newBudget
            ): array {
                return $this->resolveBudgetUpdateContext($project, $baseline, $budgetSource, $transferFromProjectId, $transferAmount, $newBudget);
            }
        };

        $project = new Project();
        $project->id = 'project-1';
        $project->title = 'Demo Project';

        $baseline = new LedgerEntry();
        $baseline->id = 'ledger-1';
        $baseline->project_id = 'project-1';
        $baseline->type = 'Initial';
        $baseline->category = 'Transfer';
        $baseline->amount = 500;
        $baseline->note = 'Transferred from completed project "Source Project"';

        $result = $controller->resolveBudgetUpdateContextForTest(
            $project,
            $baseline,
            'none',
            null,
            0,
            750
        );

        $this->assertSame('past_project', $result['budgetSource']);
        $this->assertSame('source-project-id', $result['transferFromProjectId']);
        $this->assertSame(750.0, $result['transferAmount']);
    }
}
