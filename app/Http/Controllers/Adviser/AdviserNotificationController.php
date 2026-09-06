<?php

namespace App\Http\Controllers\Adviser;

use App\Http\Controllers\Controller;
use App\Models\User\Notification;
use App\Services\NotificationReadService;
use Illuminate\Http\Request;
use Illuminate\Support\Str;
use Inertia\Inertia;

class AdviserNotificationController extends Controller
{
    public function index()
    {
        $rows = app(NotificationReadService::class)->withReadState(Notification::query(), (string) auth()->id())
            ->where('notifications.archive', false)
            ->where(function ($query) {
                $query->whereNull('notifications.user_id')
                    ->orWhere('notifications.user_id', auth()->id());
            })
            ->orderByDesc('notifications.created_at')
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
                'isRead' => (bool) $row->user_is_read,
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
        app(NotificationReadService::class)->markRead($id, (string) $request->user()->id);

        return back();
    }

    public function markAllRead(Request $request)
    {
        app(NotificationReadService::class)->markAllRead((string) $request->user()->id);

        return back();
    }

    public function store(Request $request)
    {
        $validated = $request->validate([
            'title' => ['required', 'string', 'max:150'],
            'message' => ['required', 'string', 'max:5000'],
        ]);

        $this->createNotification(
            $validated['title'],
            $validated['message'],
            'system'
        );

        return back()->with('success', 'Notice published.');
    }
}
