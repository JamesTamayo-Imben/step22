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

        $recipients = User::query()
            ->where('archive', false)
            ->whereNotNull('email')
            ->whereHas('role', fn ($query) => $query->whereIn('slug', [
                'csg',
                'admin',
                'admin-sadu',
                'superadmin',
            ]))
            ->pluck('email')
            ->filter()
            ->unique()
            ->values();

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
}