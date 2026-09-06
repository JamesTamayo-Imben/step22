<?php

namespace App\Services;

use App\Mail\TamperingDetectedMail;
use App\Models\AuditLog;
use App\Models\User;
use Illuminate\Support\Facades\Mail;
use Illuminate\Support\Str;

class TamperingEmailService
{
    public function sendIfNew(string $projectId, array $verification): void
    {
        $tamperedBlocks = $verification['tamperedBlocks'] ?? [];
        if (! is_array($tamperedBlocks) || $tamperedBlocks === []) {
            return;
        }

        $signature = hash('sha256', json_encode($tamperedBlocks, JSON_THROW_ON_ERROR));
        $details = "tampering_signature:{$signature}";

        $alreadySent = AuditLog::query()
            ->where('actionable_id', $projectId)
            ->where('actionable_type', 'blockchain')
            ->where('action', 'Tampering detected - email delivered')
            ->where('details', $details)
            ->where('archive', false)
            ->exists();

        if ($alreadySent) {
            return;
        }

        $project = \App\Models\User\Project::query()->find($projectId);
        if (! $project) {
            return;
        }

        $recipients = $this->recipientsForProject($project);
        if ($recipients->isEmpty()) {
            return;
        }

        Mail::to($recipients->all())->send(new TamperingDetectedMail(
            (string) ($project->title ?? 'Unknown Project'),
            (string) $projectId,
            $tamperedBlocks,
        ));

        AuditLog::create([
            'id' => (string) Str::uuid(),
            'user_id' => null,
            'actionable_id' => $projectId,
            'actionable_type' => 'blockchain',
            'action' => 'Tampering detected - email delivered',
            'module' => 'blockchain',
            'action_type' => 'alert',
            'status' => 'Warning',
            'details' => $details,
            'archive' => false,
        ]);
    }

    public function sendBudgetMismatchIfNew(string $projectId, string $projectTitle, float $storedBudget, float $computedBudget): void
    {
        $project = \App\Models\User\Project::query()->find($projectId);
        if (! $project) {
            return;
        }

        $details = "budget_mismatch:{$storedBudget}:{$computedBudget}";
        $alreadySent = AuditLog::query()
            ->where('actionable_id', $projectId)
            ->where('actionable_type', 'blockchain')
            ->where('action', 'Budget mismatch - email delivered')
            ->where('details', $details)
            ->where('archive', false)
            ->exists();

        if ($alreadySent) {
            return;
        }

        $recipients = $this->recipientsForProject($project);
        if ($recipients->isEmpty()) {
            return;
        }

        Mail::to($recipients->all())->send(new TamperingDetectedMail(
            $projectTitle,
            (string) $projectId,
            [[
                'ledgerId' => null,
                'issues' => [
                    "Budget mismatch: stored {$storedBudget}, computed {$computedBudget}",
                ],
            ]],
        ));

        AuditLog::create([
            'id' => (string) Str::uuid(),
            'user_id' => null,
            'actionable_id' => $projectId,
            'actionable_type' => 'blockchain',
            'action' => 'Budget mismatch - email delivered',
            'module' => 'blockchain',
            'action_type' => 'alert',
            'status' => 'Warning',
            'details' => $details,
            'archive' => false,
        ]);
    }

    private function recipientsForProject(\App\Models\User\Project $project): \Illuminate\Support\Collection
    {
        $projectCreatorId = $project->created_by;
        $recipientIds = User::query()
            ->where('archive', false)
            ->whereNotNull('email')
            ->whereHas('role', fn ($query) => $query->whereIn('slug', [
                'student',
                'teacher',
                'csg',
                'admin',
                'admin-sadu',
                'superadmin',
            ]))
            ->pluck('id')
            ->filter()
            ->values();

        if ($projectCreatorId) {
            $recipientIds->push($projectCreatorId);
        }

        return User::query()
            ->whereIn('id', $recipientIds->unique()->values())
            ->where('archive', false)
            ->whereNotNull('email')
            ->pluck('email')
            ->filter()
            ->unique()
            ->values();
    }
}