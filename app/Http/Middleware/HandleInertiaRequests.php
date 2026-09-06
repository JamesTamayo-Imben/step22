<?php

namespace App\Http\Middleware;

use Illuminate\Http\Request;
use Inertia\Middleware;
use App\Models\User\Notification;
use App\Services\CsgOnlineStatusService;
use App\Services\RolePermissionService;
use Illuminate\Support\Facades\DB;

class HandleInertiaRequests extends Middleware
{
    protected $rootView = 'app';

    public function version(Request $request): ?string
    {
        return parent::version($request);
    }

    public function share(Request $request): array
    {
        $user = $request->user();
        
        // Load user with role, student, and teacher relationships if user is authenticated
        if ($user) {
            $user->load('role', 'student', 'teacher');
        }

        $permissions = [];
        if ($user) {
            try {
                $permissions = app(RolePermissionService::class)->permissionSlugsForUser($user);
            } catch (\Throwable $e) {
                $permissions = [];
            }
        }
        
        return [
            ...parent::share($request),
            'auth' => [
                'user' => $user,
                'permissions' => $permissions,
                'notifications' => $user
                    ? DB::table('notifications')
                        ->leftJoin('notification_reads as notification_read_state', function ($join) use ($user) {
                            $join->on('notifications.id', '=', 'notification_read_state.notification_id')
                                ->where('notification_read_state.user_id', $user->id);
                        })
                        ->where('notifications.archive', 0)
                        ->where(function ($query) use ($user) {
                            $query->whereNull('notifications.user_id')->orWhere('notifications.user_id', $user->id);
                        })
                        ->select('notifications.*', DB::raw('CASE WHEN notification_read_state.read_at IS NULL THEN 0 ELSE 1 END as is_read'))
                        ->orderBy('notifications.created_at', 'desc')
                        ->get()
                    : [],
            ],
            'userPermissions' => $permissions,
            'onlineOfficers' => fn () => $user && $user->hasRole('CSG Officer')
                ? app(CsgOnlineStatusService::class)->getOfficersStatus()
                : [],
        ];
    }
}