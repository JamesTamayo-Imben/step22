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
        $verification = BlockchainService::verifyChain($projectId);

        return Inertia::render('Blockchain/Show', [
            'project' => [
                'id' => $project->id,
                'title' => $project->title,
                'status' => $project->approval_status,
                'amount' => $project->budget,
            ],
            'chain' => $chain,
            'verification' => $verification,
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
        $verification = BlockchainService::verifyChain($projectId);

        return response()->json([
            'project_id' => $projectId,
            'project_title' => $project->title,
            'verification' => $verification,
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
        $verification = BlockchainService::verifyChain($projectId);

        return response()->json([
            'project' => [
                'id' => $project->id,
                'title' => $project->title,
                'status' => $project->approval_status,
            ],
            'chain' => $chain,
            'verification' => $verification,
            'exported_at' => now()->toIso8601String(),
        ]);
    }
}
