<?php

namespace App\Http\Controllers\Adviser;

use App\Http\Controllers\Controller;
use App\Models\User\Notification;
use Illuminate\Http\Request;
use Inertia\Inertia;

class AdviserNotificationController extends Controller
{
    public function index()
    {
        $rows = Notification::query()
            ->where('archive', false)
            ->orderByDesc('created_at')
            ->limit(150)
            ->get();

        $items = $rows->map(function (Notification $row) {
            $type = strtolower((string) ($row->type ?: 'system'));
            $icon = match ($type) {
                'rating' => 'star',
                'meeting' => 'calendar',
                'project' => 'project',
                'badge' => 'badge',
                'points' => 'points',
                'proof' => 'file',
                'ledger' => 'dollar',
                default => 'bell',
            };

            return [
                'id' => $row->id,
                'type' => in_array($type, ['project', 'meeting', 'badge', 'points', 'rating', 'system', 'proof', 'ledger'], true) ? $type : 'system',
                'title' => $row->title ?: 'Notification',
                'message' => $row->message ?: '',
                'timestamp' => optional($row->created_at)->format('M d, Y h:i A') ?? '',
                'isRead' => (bool) $row->is_read,
                'icon' => $icon,
                'userId' => $row->user_id,
            ];
        })->values();

        $unread = collect($items)->where('isRead', false)->count();

        return Inertia::render('Adviser/Notifications', [
            'notificationsData' => $items,
            'unreadNotificationsCount' => $unread,
        ]);
    }

    public function markRead(Request $request, string $id)
    {
        Notification::query()->where('id', $id)->where('archive', false)->update([
            'is_read' => 1,
            'read_at' => now(),
        ]);

        return back();
    }

    public function markAllRead(Request $request)
    {
        Notification::query()
            ->where('archive', false)
            ->where('is_read', 0)
            ->update([
                'is_read' => 1,
                'read_at' => now(),
            ]);

        return back();
    }
}
