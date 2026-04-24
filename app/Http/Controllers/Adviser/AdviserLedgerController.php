<?php

namespace App\Http\Controllers\Adviser;

use App\Http\Controllers\Controller;
use App\Models\AuditLog;
use App\Models\Chain;
use App\Models\User;
use App\Models\User\LedgerEntry;
use App\Models\User\Project;
use App\Support\AdviserLedgerFormatter;
use Illuminate\Http\Request;
use Illuminate\Support\Str;
use Inertia\Inertia;

class AdviserLedgerController extends Controller
{
    public function index()
    {
        $projectNames = LedgerEntry::query()
            ->join('projects', 'ledger_entries.project_id', '=', 'projects.id')
            ->where('projects.archive', false)
            ->distinct()
            ->orderBy('projects.title')
            ->pluck('projects.title')
            ->filter()
            ->values();

        $totalProjectBudget = Project::query()
            ->where('archive', false)
            ->where('approval_status', 'Approved')
            ->sum('budget');

        return Inertia::render('Adviser/Ledger', [
            'ledgerEntries' => Inertia::defer(fn() => $this->getLedgerEntriesData()),
            'auditTrail' => Inertia::defer(fn() => $this->getAuditTrailData()),
            'projectFilterOptions' => $projectNames,
            'totalProjectBudget' => (float) $totalProjectBudget,
        ]);
    }

    private function getLedgerEntriesData()
    {
        $entries = LedgerEntry::query()
            ->with('project')
            ->orderBy('created_at', 'asc')
            ->where('archive', false)
            ->get();

        // Build a map of project_id => chain block (latest block for each project)
        $chainBlocks = [];
        $projectVerifications = [];
        $uniqueProjectIds = $entries->pluck('project_id')->unique();

        foreach ($uniqueProjectIds as $projectId) {
            // Get latest block for verification
            $latestBlock = Chain::where('project_id', $projectId)
                ->orderByDesc('block_index')
                ->first();

            if ($latestBlock) {
                $chainBlocks[$projectId] = $latestBlock;
                // Verify the entire chain for this project
                $verification = \App\Support\BlockchainService::verifyChain($projectId);
                $projectVerifications[$projectId] = $verification;
            }
        }

        // Map chain blocks by entry ID for the formatter
        $entryChainBlocks = [];
        foreach ($entries as $entry) {
            $entryChainBlocks[$entry->id] = $chainBlocks[$entry->project_id] ?? null;
        }

        $byId = $entries->keyBy('id');
        $rows = [];
        $prev = null;
        $prevChain = null;
        foreach ($entries as $entry) {
            $name = $this->userName($entry->created_by);
            $currentChain = $entryChainBlocks[$entry->id] ?? null;
            $verification = $projectVerifications[$entry->project_id] ?? ['isValid' => false, 'status' => 'no_chain', 'tamperedBlocks' => []];
            
            // Check if THIS specific ledger is tampered
            $isTampered = false;
            foreach ($verification['tamperedBlocks'] ?? [] as $tamperedBlock) {
                if ($tamperedBlock['ledgerId'] === $entry->id) {
                    $isTampered = true;
                    break;
                }
            }
            
            $rows[] = AdviserLedgerFormatter::toFrontendRow(
                $entry,
                $prev,
                $name,
                'CSG Officer',
                $currentChain,
                $prevChain,
                $verification,
                $isTampered
            );
            $prev = $entry;
            $prevChain = $currentChain;
        }

        return collect($rows)->sortByDesc('date')->values()->all();
    }

    private function getAuditTrailData()
    {
        return AuditLog::query()
            ->with(['user.role'])
            ->where(function ($q) {
                $q->where('module', 'ledger')
                    ->orWhere('module', 'approvals')
                    ->orWhere('actionable_type', 'ledger_entry');
            })
            ->orderByDesc('created_at')
            ->limit(500)
            ->get()
            ->map(fn (AuditLog $log) => [
                'id' => $log->id,
                'action' => $log->action ?? '',
                'performedBy' => $log->user?->name ?? 'System',
                'role' => $log->user?->role?->name ?? 'User',
                'timestamp' => optional($log->created_at)->format('Y-m-d h:i A') ?? '',
                'ipAddress' => $log->ip_address ?? '—',
                'details' => $log->details ?? '',
            ])->values()->all();
    }

    public function approve(Request $request, string $id)
{
    $entry = LedgerEntry::where('id', $id)->with('project')->firstOrFail();
    if ($entry->type === 'Initial') {
        return back()->withErrors(['error' => 'Initial baseline entries are managed automatically.']);
    }
    $wasApproved = $entry->approval_status === 'Approved';

    $entry->update([
        'approval_status' => 'Approved',
        'approved_by' => auth()->id(),
        'approved_at' => now(),
        'updated_by' => auth()->id(),
        'rejected_at' => null,
    ]);

    if (! $wasApproved && $entry->project) {
        $amount = (float) $entry->amount;
        if ($amount > 0) {
            if ($entry->type === 'Expense') {
                    $entry->project->budget = (float) $entry->project->budget - $amount;
            } elseif (in_array($entry->type, ['Income', 'Canvas', 'Donation', 'Sponsorship'], true)) {
                $entry->project->budget = (float) $entry->project->budget + $amount;
            }
            $entry->project->save();
        }
    }

    $this->writeAudit(
        'Ledger Entry Approved',
        $entry->id,
        'ledger_entry',
        ($entry->description ?? '').' — '.$entry->project?->title,
        'ledger'
    );

    return back();
}

    public function reject(Request $request, string $id)
    {
        $data = $request->validate([
            'reason' => 'required|string|min:3|max:2000',
        ]);

        $entry = LedgerEntry::where('id', $id)->firstOrFail();
        if ($entry->type === 'Initial') {
            return back()->withErrors(['error' => 'Initial baseline entries are managed automatically.']);
        }
        $entry->update([
            'approval_status' => 'Rejected',
            'note' => $data['reason'],
            'rejected_at' => now(),
            'updated_by' => auth()->id(),
            'approved_by' => null,
            'approved_at' => null,
        ]);

        $this->writeAudit(
            'Ledger Entry Rejected',
            $entry->id,
            'ledger_entry',
            ($entry->description ?? '').' — '.$data['reason'],
            'ledger'
        );

        return back();
    }

    public function correction(Request $request, string $id)
    {
        $data = $request->validate([
            'reason' => 'required|string|min:3|max:2000',
        ]);

        $entry = LedgerEntry::where('id', $id)->firstOrFail();
        if ($entry->type === 'Initial') {
            return back()->withErrors(['error' => 'Initial baseline entries are managed automatically.']);
        }
        $prefix = AdviserLedgerFormatter::CORRECTION_PREFIX;
        $newNote = $prefix.' '.$data['reason'];
        $entry->update([
            'approval_status' => 'Pending Adviser Approval',
            'note' => $newNote,
            'updated_by' => auth()->id(),
        ]);

        $this->writeAudit(
            'Ledger Correction Requested',
            $entry->id,
            'ledger_entry',
            ($entry->description ?? '').' — '.$data['reason'],
            'ledger'
        );

        return back();
    }

    public function fixTampered(Request $request, string $id)
    {
        $entry = LedgerEntry::where('id', $id)->firstOrFail();

        // Get the blockchain snapshot for this entry
        $chainBlocks = \App\Models\Chain::where('project_id', $entry->project_id)->get();
        $chainBlock = null;
        foreach ($chainBlocks as $block) {
            $snapshot = json_decode($block->data_snapshot, true);
            if ($snapshot && isset($snapshot['ledger_id']) && $snapshot['ledger_id'] === $entry->id) {
                $chainBlock = $block;
                break;
            }
        }

        if (!$chainBlock) {
            return back()->withErrors(['error' => 'No blockchain snapshot found for this entry']);
        }

        $snapshot = json_decode($chainBlock->data_snapshot, true);

        // Update the entry with snapshot data, including budget_breakdown if tampered
        $updateData = [
            'description' => $snapshot['description'] ?? $entry->description,
            'amount' => $snapshot['amount'] ?? $entry->amount,
            'type' => $snapshot['entry_type'] ?? $entry->type,
            'updated_by' => auth()->id(),
        ];

        // Include budget_breakdown if it exists in the snapshot
        if (isset($snapshot['budget_breakdown'])) {
            $updateData['budget_breakdown'] = $snapshot['budget_breakdown'];
        }

        $entry->update($updateData);

        $this->writeAudit(
            'Ledger Entry Restored from Blockchain',
            $entry->id,
            'ledger_entry',
            'Restored to approved state using blockchain snapshot',
            'ledger'
        );

        return back();
    }

    public function fixBudgetMismatch(Request $request)
    {
        $projects = Project::query()
            ->where('archive', false)
            ->where('approval_status', 'Approved')
            // ->where('type', 'Initial')
            ->get();

        $updatedCount = 0;

        foreach ($projects as $project) {
            $approvedEntries = LedgerEntry::query()
                ->where('project_id', $project->id)
                ->where('archive', false)
                ->where('approval_status', 'Approved')
                ->orderBy('created_at')
                ->get(['type', 'amount']);

            $computedBudget = 0.0;
            foreach ($approvedEntries as $entry) {
                $amount = (float) $entry->amount;
                if ($entry->type === 'Expense') {
                    $computedBudget = $computedBudget - $amount;
                } elseif (
                    $entry->type === 'Initial' ||
                    in_array($entry->type, ['Income', 'Donation', 'Sponsorship'], true)
                ) {
                    $computedBudget += $amount;
                }
            }

            if (abs(((float) $project->budget) - $computedBudget) > 0.01) {
                $project->budget = $computedBudget;
                $project->save();
                $updatedCount++;
            }
        }

        $this->writeAudit(
            'Project Budget Synced from Ledger',
            null,
            'project',
            "Synchronized {$updatedCount} project budget(s) with approved ledger totals",
            'ledger'
        );

        return back();
    }

    private function userName(?string $userId): string
    {
        if (! $userId) {
            return 'Unknown';
        }
        $u = User::find($userId);

        return $u?->name ?? 'Unknown';
    }

    private function writeAudit(string $action, ?string $actionableId, ?string $actionableType, string $details, string $module): void
    {
        AuditLog::create([
            'id' => (string) Str::uuid(),
            'user_id' => auth()->id(),
            'actionable_id' => $actionableId,
            'actionable_type' => $actionableType,
            'action' => $action,
            'module' => $module,
            'details' => $details,
            'ip_address' => request()->ip(),
            'browser_info' => substr((string) request()->userAgent(), 0, 500),
            'archive' => 0,
        ]);
    }
}
