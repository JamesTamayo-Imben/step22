<?php

namespace Tests\Feature;

use App\Http\Controllers\CSG\ProjectController;
use App\Models\CSG\LedgerEntry;
use App\Models\CSG\Project;
use Illuminate\Http\Request;
use Illuminate\Http\UploadedFile;
use Illuminate\Support\Facades\Auth;
use Illuminate\Support\Facades\Storage;
use Illuminate\Support\Str;
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
        $this->assertNull($result['transferFromProjectId']);
        $this->assertSame(750.0, $result['transferAmount']);
    }

    public function test_editing_transfer_budget_recalculates_ledger_amount_when_lowered(): void
    {
        Storage::fake('supabase');
        $user = $this->authorizedUser('csg');
        Auth::login($user);

        $sourceProject = Project::create([
            'id' => (string) Str::uuid(),
            'title' => 'Completed Source Project',
            'description' => 'Existing project with remaining budget',
            'category' => 'Social',
            'budget' => 1000,
            'proposed_by' => 'Tester',
            'approval_status' => 'Approved',
            'status' => 'Complete',
            'start_date' => now()->subMonths(2)->toDateString(),
            'end_date' => now()->subDay()->toDateString(),
            'archive' => 0,
            'created_by' => $user->id,
            'updated_by' => $user->id,
        ]);

        $projectTitle = 'Transfer Destination Project ' . Str::uuid();

        $request = Request::create('/api/projects', 'POST', [
            'title' => $projectTitle,
            'description' => 'New project funded by transfer',
            'objective' => 'Build community impact',
            'venue' => 'Main Hall',
            'category' => 'Social',
            'budget' => 250,
            'has_budget' => 1,
            'is_active' => 1,
            'budget_source' => 'past_project',
            'transfer_from_project_id' => $sourceProject->id,
            'transfer_amount' => 125,
            'proposed_by' => 'Tester',
            'status' => 'Draft',
            'approval_status' => 'Draft',
            'start_date' => now()->addMonth()->toDateString(),
            'end_date' => now()->addMonths(2)->toDateString(),
        ]);
        $request->setUserResolver(fn () => $user);
        $request->files->add([
            'project_proof' => UploadedFile::fake()->create('transfer-proof.pdf', 120, 'application/pdf'),
        ]);

        $storeResponse = (new ProjectController())->store($request);
        $this->assertEquals(201, $storeResponse->getStatusCode());

        $project = Project::where('title', $projectTitle)->firstOrFail();
        $destinationTransfer = LedgerEntry::where('project_id', $project->id)
            ->where('category', 'Transfer')
            ->where('type', 'Initial Transfer')
            ->firstOrFail();

        $this->assertEquals(125.0, (float) $destinationTransfer->amount);

        $updateRequest = Request::create('/api/projects/' . $project->id, 'POST', [
            'title' => $projectTitle,
            'description' => 'Updated description',
            'objective' => 'Build community impact',
            'venue' => 'Main Hall',
            'category' => 'Social',
            'budget' => 50,
            'has_budget' => 1,
            'budget_source' => 'past_project',
            'transfer_from_project_id' => '',
            'transfer_amount' => 50,
            'proposed_by' => 'Tester',
            'status' => 'Draft',
            'approval_status' => 'Draft',
            'start_date' => now()->addMonth()->toDateString(),
            'end_date' => now()->addMonths(2)->toDateString(),
        ]);
        $updateRequest->setUserResolver(fn () => $user);

        $updateResponse = (new ProjectController())->update($updateRequest, $project->id);
        $this->assertEquals(200, $updateResponse->getStatusCode());

        $updatedDestinationTransfer = LedgerEntry::where('project_id', $project->id)
            ->where('category', 'Transfer')
            ->where('archive', 0)
            ->where('type', 'Initial Transfer')
            ->latest('updated_at')
            ->first();

        $this->assertNotNull($updatedDestinationTransfer);
        $this->assertEquals(50.0, (float) $updatedDestinationTransfer->amount);

        $sourceTransferEntries = LedgerEntry::where('category', 'Transfer')
            ->where('archive', 0)
            ->where('type', 'Transfer')
            ->get()
            ->filter(function (LedgerEntry $entry) use ($project) {
                $note = json_decode((string) $entry->note, true);

                return is_array($note)
                    && (string) ($note['transfer_destination_project_id'] ?? '') === (string) $project->id;
            });

        $this->assertNotEmpty($sourceTransferEntries);
        $this->assertEquals(50.0, (float) $sourceTransferEntries->sum('amount'));
        $sourceProject->refresh();
        $this->assertEquals(1000.0, (float) $sourceProject->budget);

        $revertRequest = Request::create('/api/projects/' . $project->id, 'POST', [
            'title' => $projectTitle,
            'description' => 'Updated description',
            'objective' => 'Build community impact',
            'venue' => 'Main Hall',
            'category' => 'Social',
            'budget' => 200,
            'has_budget' => 1,
            'budget_source' => 'past_project',
            'transfer_from_project_id' => '',
            'transfer_amount' => 200,
            'proposed_by' => 'Tester',
            'status' => 'Draft',
            'approval_status' => 'Draft',
            'start_date' => now()->addMonth()->toDateString(),
            'end_date' => now()->addMonths(2)->toDateString(),
        ]);
        $revertRequest->setUserResolver(fn () => $user);

        $revertResponse = (new ProjectController())->update($revertRequest, $project->id);
        $this->assertEquals(200, $revertResponse->getStatusCode());

        $finalTransfer = LedgerEntry::where('project_id', $project->id)
            ->where('category', 'Transfer')
            ->where('archive', 0)
            ->where('type', 'Initial Transfer')
            ->latest('updated_at')
            ->first();

        $this->assertNotNull($finalTransfer);
        $this->assertEquals(200.0, (float) $finalTransfer->amount);
        $finalSourceTransferEntries = LedgerEntry::where('category', 'Transfer')
            ->where('archive', 0)
            ->where('type', 'Transfer')
            ->get()
            ->filter(function (LedgerEntry $entry) use ($project) {
                $note = json_decode((string) $entry->note, true);

                return is_array($note)
                    && (string) ($note['transfer_destination_project_id'] ?? '') === (string) $project->id;
            });
        $this->assertEquals(200.0, (float) $finalSourceTransferEntries->sum('amount'));
        $sourceProject->refresh();
        $this->assertEquals(1000.0, (float) $sourceProject->budget);

        $newBudgetRequest = Request::create('/api/projects/' . $project->id, 'POST', [
            'title' => $projectTitle,
            'description' => 'Updated description',
            'objective' => 'Build community impact',
            'venue' => 'Main Hall',
            'category' => 'Social',
            'budget' => 300,
            'has_budget' => 1,
            'budget_source' => 'none',
            'budget_source_details' => json_encode([
                'sponsorship' => [[
                    'name' => 'New Sponsor',
                    'amount' => 300,
                ]],
            ]),
            'transfer_from_project_id' => '',
            'transfer_amount' => '',
            'proposed_by' => 'Tester',
            'status' => 'Draft',
            'approval_status' => 'Draft',
            'start_date' => now()->addMonth()->toDateString(),
            'end_date' => now()->addMonths(2)->toDateString(),
        ]);
        $newBudgetRequest->setUserResolver(fn () => $user);

        $newBudgetResponse = (new ProjectController())->update($newBudgetRequest, $project->id);
        $this->assertEquals(200, $newBudgetResponse->getStatusCode());
        $this->assertSame(0, LedgerEntry::where('project_id', $project->id)
            ->where('category', 'Transfer')
            ->where('archive', 0)
            ->count());
        $this->assertSame(300.0, (float) LedgerEntry::where('project_id', $project->id)
            ->where('type', 'Initial')
            ->where('archive', 0)
            ->value('amount'));

        $pastBudgetRequest = Request::create('/api/projects/' . $project->id, 'POST', [
            'title' => $projectTitle,
            'description' => 'Updated description',
            'objective' => 'Build community impact',
            'venue' => 'Main Hall',
            'category' => 'Social',
            'budget' => 150,
            'has_budget' => 1,
            'budget_source' => 'past_project',
            'transfer_from_project_id' => '',
            'transfer_amount' => 150,
            'proposed_by' => 'Tester',
            'status' => 'Draft',
            'approval_status' => 'Draft',
            'start_date' => now()->addMonth()->toDateString(),
            'end_date' => now()->addMonths(2)->toDateString(),
        ]);
        $pastBudgetRequest->setUserResolver(fn () => $user);

        $pastBudgetResponse = (new ProjectController())->update($pastBudgetRequest, $project->id);
        $this->assertEquals(200, $pastBudgetResponse->getStatusCode());
        $this->assertSame(0, LedgerEntry::where('project_id', $project->id)
            ->where('type', 'Initial')
            ->where('archive', 0)
            ->count());
        $this->assertSame(150.0, (float) LedgerEntry::where('project_id', $project->id)
            ->where('type', 'Initial Transfer')
            ->where('archive', 0)
            ->value('amount'));
    }
}
