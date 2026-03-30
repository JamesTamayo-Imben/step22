<?php

namespace App\Http\Controllers;

use App\Models\User\Project;
use App\Support\BlockchainService;
use Illuminate\Http\Request;
use Inertia\Inertia;

class BlockchainController extends Controller
{
    /**
     * Show the blockchain for a specific project
     */
    public function show(string $projectId)
    {
        $project = Project::where('id', $projectId)->where('archive', false)->firstOrFail();

        $chain = BlockchainService::getChainForProject($projectId);
        $isValid = BlockchainService::verifyChain($projectId);

        return Inertia::render('Blockchain/Show', [
            'project' => [
                'id' => $project->id,
                'title' => $project->title,
                'status' => $project->approval_status,
                'amount' => $project->budget,
            ],
            'chain' => $chain,
            'isValid' => $isValid,
            'integrity' => [
                'totalBlocks' => $chain->count(),
                'genesisHash' => $chain->first()?->hash,
                'latestHash' => $chain->last()?->hash,
            ],
        ]);
    }

    /**
     * Verify the blockchain integrity for a project
     */
    public function verify(Request $request)
    {
        $projectId = $request->get('project_id');
        
        $project = Project::where('id', $projectId)->where('archive', false)->firstOrFail();
        $isValid = BlockchainService::verifyChain($projectId);

        return response()->json([
            'project_id' => $projectId,
            'project_title' => $project->title,
            'is_valid' => $isValid,
            'verified_at' => now()->toIso8601String(),
        ]);
    }

    /**
     * Export blockchain as JSON
     */
    public function export(string $projectId)
    {
        $project = Project::where('id', $projectId)->where('archive', false)->firstOrFail();
        $chain = BlockchainService::getChainForProject($projectId);
        $isValid = BlockchainService::verifyChain($projectId);

        return response()->json([
            'project' => [
                'id' => $project->id,
                'title' => $project->title,
                'status' => $project->approval_status,
            ],
            'chain' => $chain,
            'integrity_verified' => $isValid,
            'exported_at' => now()->toIso8601String(),
        ]);
    }
}
