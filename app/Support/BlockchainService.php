<?php

namespace App\Support;

use App\Models\Chain;
use App\Models\User\LedgerEntry;
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

        // Attempt to pull budget breakdown from the ledger record if not provided
        $entry = LedgerEntry::where('id', $ledgerId)->first();
        $budgetBreakdown = $ledgerData['budget_breakdown'] ?? ($entry->budget_breakdown ?? null);

        $dataSnapshot = [
            'type' => 'ledger',
            'ledger_id' => $ledgerId,
            'project_id' => $projectId,
            'description' => $ledgerData['description'] ?? ($entry->description ?? null),
            'budget_breakdown' => $budgetBreakdown,
            'amount' => $ledgerData['amount'] ?? ($entry->amount ?? null),
            'entry_type' => $ledgerData['type'] ?? ($entry->type ?? null),
            'approval_status' => 'Approved',
            'approved_at' => now()->toIso8601String(),
            // Add a cryptographically secure random nonce so external actors cannot predict or reproduce it
            'snapshot_nonce' => bin2hex(random_bytes(8)),
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
     * Returns detailed verification result
     */
    public static function verifyChain($projectId)
    {
        $blocks = Chain::where('project_id', $projectId)
            ->orderBy('block_index')
            ->get();

        if ($blocks->isEmpty()) {
            return [
                'isValid' => true,
                'status' => 'valid',
                'message' => 'No chain to verify',
                'tamperedBlocks' => [],
            ];
        }

        $tamperedBlocks = [];
        $chainBroken = false;

        foreach ($blocks as $i => $block) {
            $issues = [];

            // Verify block index sequence
            if ($block->block_index !== $i) {
                $issues[] = 'Invalid block index';
                $chainBroken = true;
            }

            // Verify hash
            $expectedHash = self::generateHash(
                json_decode($block->data_snapshot, true),
                $block->prev_hash
            );

            if ($block->hash !== $expectedHash) {
                $issues[] = 'Hash mismatch (chain tampered)';
                $chainBroken = true;
            }

            // Verify link to previous block
            if ($i === 0) {
                if ($block->prev_hash !== null) {
                    $issues[] = 'Genesis block has prev_hash';
                    $chainBroken = true;
                }
            } else {
                $prevBlock = $blocks[$i - 1];
                if ($block->prev_hash !== $prevBlock->hash) {
                    $issues[] = 'Broken link to previous block';
                    $chainBroken = true;
                }
            }

            // Verify snapshot matches current ledger data (for ledger blocks)
            $snapshot = json_decode($block->data_snapshot, true);
            if (is_array($snapshot) && isset($snapshot['type']) && $snapshot['type'] === 'ledger') {
                $currentEntry = LedgerEntry::where('id', $snapshot['ledger_id'])->first();
                if (!$currentEntry) {
                    $issues[] = 'Ledger entry deleted';
                    $chainBroken = true;
                } else {
                    // Check key fields for tampering
                    if ((float)$currentEntry->amount !== (float)($snapshot['amount'] ?? 0)) {
                        $snapshotAmount = $snapshot['amount'] ?? 'N/A';
                        $issues[] = "Amount tampered: snapshot {$snapshotAmount}, current {$currentEntry->amount}";
                        $chainBroken = true;
                    }
                    if ($currentEntry->description !== ($snapshot['description'] ?? '')) {
                        $issues[] = 'Description tampered';
                        $chainBroken = true;
                    }
                    if ($currentEntry->type !== ($snapshot['entry_type'] ?? '')) {
                        $issues[] = 'Type tampered';
                        $chainBroken = true;
                    }

                    // Normalize helper for comparing budget breakdowns stored as JSON string or arrays
                    $normalize = function ($val) {
                        if ($val === null) return null;
                        if (is_string($val)) {
                            $decoded = json_decode($val, true);
                            if (json_last_error() === JSON_ERROR_NONE) {
                                return json_encode($decoded);
                            }
                            return trim($val);
                        }
                        return json_encode($val);
                    };

                    $currentBudgetNorm = $normalize($currentEntry->budget_breakdown ?? null);
                    $snapshotBudgetNorm = $normalize($snapshot['budget_breakdown'] ?? null);
                    if ($currentBudgetNorm !== $snapshotBudgetNorm) {
                        $issues[] = 'Budget breakdown tampered';
                        $chainBroken = true;
                    }

                    // Verify presence and format of snapshot nonce
                    if (empty($snapshot['snapshot_nonce']) || !is_string($snapshot['snapshot_nonce']) || !preg_match('/^[0-9a-f]{16}$/', $snapshot['snapshot_nonce'])) {
                        $issues[] = 'Missing or invalid snapshot_nonce';
                        $chainBroken = true;
                    }
                }
            }

            if (!empty($issues)) {
                $tamperedBlocks[] = [
                    'blockIndex' => $block->block_index,
                    'blockId' => $block->id,
                    'ledgerId' => $snapshot['ledger_id'] ?? null,
                    'issues' => $issues,
                ];
            }
        }

        return [
            'isValid' => !$chainBroken,
            'status' => $chainBroken ? 'tampering_detected' : 'valid',
            'message' => $chainBroken ? 'Blockchain integrity compromised' : 'Blockchain is valid',
            'tamperedBlocks' => $tamperedBlocks,
        ];
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
