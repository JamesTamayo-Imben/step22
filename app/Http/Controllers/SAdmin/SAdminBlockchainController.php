<?php

namespace App\Http\Controllers\SAdmin;

use App\Http\Controllers\Controller;
use App\Models\CSG\LedgerEntry;
use App\Models\CSG\Project;
use App\Support\BlockchainService;
use App\Support\ProjectBudgetCalculator;
use Illuminate\Http\JsonResponse;
use Inertia\Inertia;

class SAdminBlockchainController extends Controller
{
    public function index()
    {
        return Inertia::render('SAdmin/SystemSettings', [
            'blockchains' => $this->blockchains(),
        ]);
    }

    public function verify(): JsonResponse
    {
        $results = collect($this->blockchains())->map(function (array $blockchain) {
            $verification = BlockchainService::verifyChain($blockchain['project']['id']);

            return [
                'projectId' => $blockchain['project']['id'],
                'projectTitle' => $blockchain['project']['title'],
                'verification' => $verification,
                'budgetMismatch' => $blockchain['budgetMismatch'],
                'storedBudget' => $blockchain['storedBudget'],
                'computedBudget' => $blockchain['computedBudget'],
            ];
        })->values();

        return response()->json([
            'results' => $results,
            'scannedAt' => now()->toIso8601String(),
        ]);
    }

    private function blockchains(): array
    {
        return Project::query()
            ->where('archive', false)
            ->orderBy('title')
            ->get(['id', 'title', 'budget', 'approval_status'])
            ->map(function (Project $project) {
                $chain = BlockchainService::getChainForProject($project->id)->values();
                $approvedEntries = LedgerEntry::query()
                    ->where('project_id', $project->id)
                    ->where('archive', false)
                    ->where('approval_status', 'Approved')
                    ->orderBy('created_at')
                    ->get(['type', 'amount']);
                $computedBudget = ProjectBudgetCalculator::fromLedgerEntries($approvedEntries);
                $storedBudget = (float) ($project->budget ?? 0);

                return [
                    'project' => [
                        'id' => $project->id,
                        'title' => $project->title ?? 'Untitled Project',
                        'budget' => (float) ($project->budget ?? 0),
                        'status' => $project->approval_status ?? 'N/A',
                    ],
                    'genesis' => $chain->first(),
                    'chain' => $chain,
                    'verification' => BlockchainService::verifyChain($project->id),
                    'budgetMismatch' => ProjectBudgetCalculator::hasMismatch($storedBudget, $computedBudget, $approvedEntries->isNotEmpty()),
                    'storedBudget' => $storedBudget,
                    'computedBudget' => $computedBudget,
                ];
            })
            ->values()
            ->all();
    }
}