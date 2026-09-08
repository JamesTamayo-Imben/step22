<?php

namespace App\Support;

use App\Models\User\LedgerEntry;
use Illuminate\Support\Facades\Storage;

class AdviserLedgerFormatter
{
    public const CORRECTION_PREFIX = 'Correction requested:';

    // Deprecated: hashes now come from the chain table
    // public static function ledgerHash(LedgerEntry $entry): string
    // {
    //     return hash('sha256', $entry->id . '|' . ($entry->updated_at?->timestamp ?? ''));
    // }

    public static function displayStatus(LedgerEntry $entry): string
    {
        $status = $entry->approval_status ?? 'Draft';
        if ($status === 'Pending Adviser Approval') {
            $note = (string) ($entry->note ?? '');
            if (str_starts_with($note, self::CORRECTION_PREFIX)) {
                return 'Corrected';
            }

            return 'Pending';
        }
        if ($status === 'Approved') {
            return 'Approved';
        }
        if ($status === 'Rejected') {
            return 'Rejected';
        }
        if ($status === 'Draft') {
            return 'Draft';
        }

        return 'Pending';
    }

    public static function correctionNoteReason(?string $note): ?string
    {
        if (! $note || ! str_starts_with($note, self::CORRECTION_PREFIX)) {
            return null;
        }

        return trim(substr($note, strlen(self::CORRECTION_PREFIX)));
    }

    public static function proofUrl(?string $path): ?string
    {
        if (! $path) {
            return null;
        }

        if (str_starts_with($path, 'http')) {
            return $path;
        }

        $key = str_starts_with($path, 'storage/')
            ? substr($path, strlen('storage/'))
            : $path;

        return Storage::disk('supabase')->exists($key)
            ? Storage::disk('supabase')->temporaryUrl($key, now()->addMinutes(15))
            : null;
    }

    public static function toFrontendRow(
        LedgerEntry $entry,
        ?LedgerEntry $predecessor,
        ?string $enteredByName,
        string $roleLabel,
        $chainBlock = null,
        $predecessorChainBlock = null,
        array $verification = [],
        bool $isSpecificLedgerTampered = false
    ): array
    {
        // For Initial entries, use project_proof; otherwise use ledger_proof
        $proofPath = ($entry->type === 'Initial') ? $entry->project?->project_proof : $entry->ledger_proof;
        $proofAttached = ! empty($proofPath);

        $proofFiles = [];
        if ($proofAttached) {
            $proofFiles[] = [
                'id' => '1',
                'name' => basename($proofPath),
                'hash' => substr(hash('sha256', $proofPath), 0, 40),
                'url' => self::proofUrl($proofPath) ?? '#',
            ];
        }

        $status = self::displayStatus($entry);
        $correctionReason = self::correctionNoteReason($entry->note);

        // Use chain block hashes if available, otherwise fallback to empty strings
        $ledgerHash = $chainBlock?->hash ?? '';
        $predecessorHash = $predecessorChainBlock?->hash ?? '';

        $verificationState = [
            'submitted' => optional($entry->created_at)->format('Y-m-d h:i A') ?? '',
        ];
        if ($entry->approved_at) {
            $verificationState['reviewed'] = $entry->approved_at->format('Y-m-d h:i A');
            $verificationState['approvedRejected'] = $entry->approved_at->format('Y-m-d h:i A');
        } elseif ($entry->rejected_at) {
            $verificationState['reviewed'] = $entry->rejected_at->format('Y-m-d h:i A');
            $verificationState['approvedRejected'] = $entry->rejected_at->format('Y-m-d h:i A');
        }

        if ($status === 'Corrected' && $correctionReason) {
            $verificationState['corrected'] = optional($entry->updated_at)->format('Y-m-d h:i A') ?? '';
        }

        // Add blockchain verification status
        $verification = $verification ?: [];
        $verificationState['blockchainStatus'] = $verification['status'] ?? 'no_chain';
        $verificationState['blockchainValid'] = !$isSpecificLedgerTampered && ($verification['isValid'] ?? false);
        $verificationState['tampered'] = $isSpecificLedgerTampered;

        $allowAdviserActions = ($entry->approval_status === 'Pending Adviser Approval');

        return [
            'id' => $entry->id,
            'allowAdviserActions' => $allowAdviserActions,
            'ledgerHash' => $ledgerHash,
            'predecessorHash' => $predecessorHash,
            'projectName' => $entry->project?->title ?? 'Unknown Project',
            'projectId' => $entry->project_id,
            'enteredBy' => $enteredByName ?? 'Unknown',
            'role' => $roleLabel,
            'csg_position' => $entry->creator?->student?->csg_position ?? 'CSG Officer',
            'amount' => (float) $entry->amount,
            'transactionType' => $entry->type,
            'category' => $entry->category ?? 'test',
            'description' => $entry->description ?? '',
            'date' => optional($entry->created_at)->format('Y-m-d') ?? '',
            'status' => $status,
            'approvalStatus' => $entry->approval_status,
            'archive' => (bool) $entry->archive,
            'proofAttached' => $proofAttached,
            'proofFiles' => $proofFiles,
            'verificationState' => $verificationState,
            'correctionReason' => $correctionReason,
            'note' => $entry->note,
            'budgetBreakdown' => $entry->budget_breakdown,
        ];
    }
}
