<?php

namespace App\Http\Controllers;

use App\Models\User\Notification;
use Illuminate\Support\Str;

abstract class Controller
{
    protected function createNotification(string $title, string $message, string $type = 'system', ?string $userId = null): Notification
    {
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
}
