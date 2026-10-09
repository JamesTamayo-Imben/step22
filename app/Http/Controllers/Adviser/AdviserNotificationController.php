<?php

namespace App\Http\Controllers\Adviser;

use App\Http\Controllers\Controller;
use App\Models\StudentCsgOfficer;
use App\Models\User\Notification;
use App\Services\NotificationReadService;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\DB;
use Illuminate\Validation\ValidationException;
use Inertia\Inertia;

class AdviserNotificationController extends Controller
{
    public function index()
    {
        $canSendToAllUsers = auth()->user()->hasRole('Admin/SADU');

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
            'canSendToAllUsers' => $canSendToAllUsers,
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
        $canSendToAllUsers = $request->user()->hasRole('Admin/SADU');
        $validated = $request->validate([
            'title' => ['required', 'string', 'max:150'],
            'message' => ['required', 'string', 'max:5000'],
            'audience' => ['required', 'in:' . ($canSendToAllUsers ? 'csg,all' : 'csg')],
        ]);

        if ($validated['audience'] === 'all') {
            $this->createNotification($validated['title'], $validated['message'], 'system');
        } else {
            $recipientIds = StudentCsgOfficer::query()
                ->where('is_csg', true)
                ->where('csg_is_active', true)
                ->where('archive', false)
                ->where('csg_position', '!=', 'Member')
                ->whereNotNull('user_id')
                ->whereHas('user', fn ($query) => $query->where('archive', false))
                ->distinct()
                ->pluck('user_id');

            if ($recipientIds->isEmpty()) {
                throw ValidationException::withMessages([
                    'audience' => 'There are no active CSG council members to notify.',
                ]);
            }

            $senderId = (string) $request->user()->id;
            DB::transaction(function () use ($recipientIds, $validated, $senderId) {
                $this->createNotification(
                    $validated['title'],
                    $validated['message'],
                    'system',
                    $senderId
                );

                foreach ($recipientIds as $recipientId) {
                    if ((string) $recipientId === $senderId) {
                        continue;
                    }

                    $this->createNotification(
                        $validated['title'],
                        $validated['message'],
                        'system',
                        (string) $recipientId
                    );
                }
            });
        }

        return back()->with('success', 'Notice published.');
    }
}
