<?php

namespace App\Support;

use App\Models\Chain;
use Illuminate\Support\Str;

class BlockchainService
{
    /**
     * Create a genesis block for a newly approved project
     * 
     * @param string $projectId The ID of the project
     * @param array $projectData Project data to store in the block
     */
    public static function createGenesisBlock($projectId, $projectData)
    {
        $dataSnapshot = [
            'type' => 'project',
            'project_id' => $projectId,
            'title' => $projectData['title'] ?? null,
            'description' => $projectData['description'] ?? null,
            'amount' => $projectData['amount'] ?? null,
            'approval_status' => 'Approved',
            'approved_at' => now()->toIso8601String(),
        ];

        $hash = self::generateHash($dataSnapshot, null);
        $blockId = Str::uuid();

        $block = Chain::create([
            'id' => $blockId,
            'project_id' => $projectId,
            'block_index' => 0,
            'prev_hash' => null,
            'hash' => $hash,
            'data_snapshot' => json_encode($dataSnapshot),
        ]);

        return $block;
    }

    /**
     * Add a block to the chain for a ledger entry belonging to a project
     * 
     * @param string $ledgerId The ID of the ledger entry
     * @param string $projectId The ID of the project
     * @param array $ledgerData Ledger entry data to store in the block
     */
    public static function addBlockToChain($ledgerId, $projectId, $ledgerData)
    {
        // Find the latest block in the chain for this project
        $lastBlock = Chain::where('project_id', $projectId)
            ->orderByDesc('block_index')
            ->first();

        if (!$lastBlock) {
            throw new \Exception("Genesis block not found for project: {$projectId}");
        }

        $blockIndex = ($lastBlock->block_index ?? 0) + 1;

        $dataSnapshot = [
            'type' => 'ledger',
            'ledger_id' => $ledgerId,
            'project_id' => $projectId,
            'description' => $ledgerData['description'] ?? null,
            'amount' => $ledgerData['amount'] ?? null,
            'entry_type' => $ledgerData['type'] ?? null,
            'approval_status' => 'Approved',
            'approved_at' => now()->toIso8601String(),
        ];

        // Hash includes the previous block's hash
        $hash = self::generateHash($dataSnapshot, $lastBlock->hash);
        $blockId = Str::uuid();

        $block = Chain::create([
            'id' => $blockId,
            'project_id' => $projectId,
            'block_index' => $blockIndex,
            'prev_hash' => $lastBlock->hash,
            'hash' => $hash,
            'data_snapshot' => json_encode($dataSnapshot),
        ]);

        return $block;
    }

    /**
     * Generate hash for a block
     * Uses SHA-256 for secure hashing
     */
    private static function generateHash($data, $prevHash = null)
    {
        $dataString = json_encode($data);
        
        if ($prevHash) {
            $dataString = $prevHash . '|' . $dataString;
        }

        return hash('sha256', $dataString);
    }

    /**
     * Verify the integrity of the blockchain for a project
     */
    public static function verifyChain($projectId)
    {
        $blocks = Chain::where('project_id', $projectId)
            ->orderBy('block_index')
            ->get();

        if ($blocks->isEmpty()) {
            return true; // No chain to verify
        }

        foreach ($blocks as $i => $block) {
            // Verify block index sequence
            if ($block->block_index !== $i) {
                return false;
            }

            // Verify hash
            $expectedHash = self::generateHash(
                json_decode($block->data_snapshot, true),
                $block->prev_hash
            );

            if ($block->hash !== $expectedHash) {
                return false;
            }

            // Verify link to previous block
            if ($i === 0) {
                if ($block->prev_hash !== null) {
                    return false;
                }
            } else {
                $prevBlock = $blocks[$i - 1];
                if ($block->prev_hash !== $prevBlock->hash) {
                    return false;
                }
            }
        }

        return true;
    }

    /**
     * Get the complete chain for a project
     */
    public static function getChainForProject($projectId)
    {
        return Chain::where('project_id', $projectId)
            ->orderBy('block_index')
            ->get()
            ->map(function ($block) {
                return [
                    'id' => $block->id,
                    'block_index' => $block->block_index,
                    'prev_hash' => $block->prev_hash,
                    'hash' => $block->hash,
                    'data' => json_decode($block->data_snapshot, true),
                    'created_at' => $block->created_at,
                ];
            });
    }
}
