<?php

namespace App\Http\Controllers;

use App\Models\User\Notification;
use App\Models\User;
use Illuminate\Support\Str;

abstract class Controller
{
    protected function createNotification(string $title, string $message, string $type = 'system', ?string $userId = null): Notification
    {
        if ($userId !== null && ! User::whereKey($userId)->exists()) {
            $userId = null;
        }

        return Notification::create([
            'id' => (string) Str::uuid(),
            'user_id' => $userId,
            'title' => $title,
            'message' => $message,
            'type' => $type,
            'is_read' => 0,
            'archive' => 0,
        ]);
    }

    protected function notifyApprovalReviewers(string $title, string $message, string $type = 'system'): void
    {
        User::query()
            ->where('archive', false)
            ->whereHas('role', fn ($query) => $query->whereIn('slug', ['admin', 'admin-sadu', 'superadmin']))
            ->pluck('id')
            ->each(fn ($userId) => $this->createNotification($title, $message, $type, (string) $userId));
    }
}
