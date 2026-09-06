<?php

namespace App\Services;

use Illuminate\Database\Query\Builder;
use Illuminate\Database\Eloquent\Builder as EloquentBuilder;
use Illuminate\Support\Facades\DB;

class NotificationReadService
{
    public function withReadState(Builder|EloquentBuilder $query, string $userId): Builder|EloquentBuilder
    {
        return $query
            ->leftJoin('notification_reads as notification_read_state', function ($join) use ($userId) {
                $join->on('notifications.id', '=', 'notification_read_state.notification_id')
                    ->where('notification_read_state.user_id', $userId);
            })
            ->select('notifications.*')
            ->addSelect(DB::raw('CASE WHEN notification_read_state.read_at IS NULL THEN 0 ELSE 1 END as user_is_read'));
    }

    public function markRead(string $notificationId, string $userId): void
    {
        $visible = DB::table('notifications')
            ->where('id', $notificationId)
            ->where('archive', 0)
            ->where(function ($query) use ($userId) {
                $query->whereNull('user_id')->orWhere('user_id', $userId);
            })
            ->exists();

        if ($visible) {
            DB::table('notification_reads')->updateOrInsert(
                ['notification_id' => $notificationId, 'user_id' => $userId],
                ['read_at' => now()]
            );
        }
    }

    public function markAllRead(string $userId): void
    {
        $ids = DB::table('notifications')
            ->where('archive', 0)
            ->where(function ($query) use ($userId) {
                $query->whereNull('user_id')->orWhere('user_id', $userId);
            })
            ->pluck('id');

        foreach ($ids as $notificationId) {
            DB::table('notification_reads')->updateOrInsert(
                ['notification_id' => $notificationId, 'user_id' => $userId],
                ['read_at' => now()]
            );
        }
    }
}