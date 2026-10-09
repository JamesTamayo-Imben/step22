<?php

namespace App\Http\Middleware;

use Illuminate\Http\Request;
use Inertia\Middleware;
use App\Services\CsgOnlineStatusService;
use App\Services\RolePermissionService;
use Illuminate\Support\Facades\DB;
use Inertia\Inertia;

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

        $authUser = $user ? [
    'id' => $user->id,
    'name' => $user->name,
    'email' => $user->email,
    'phone' => $user->phone,
    'avatar_url' => $user->avatar_url,
    'student' => $user->student ? [
        'id' => $user->student->id,
    ] : null,
    'teacher' => $user->teacher ? [
        'id' => $user->teacher->id,
    ] : null,
    'role' => $user->role ? [
        'id' => $user->role->id,
        'name' => $user->role->name,
        'slug' => $user->role->slug,
    ] : null,
] : null;

        try {
            $globalColorTheme = DB::table('system_settings')
                ->where('key', 'color_theme')
                ->value('value') === 'kld' ? 'kld' : 'system';
        } catch (\Throwable $e) {
            $globalColorTheme = 'system';
        }

        return [
    ...parent::share($request),
    'globalColorTheme' => $globalColorTheme,
    'auth' => [
        'user' => $authUser,
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
    'onlineOfficers' => $user && $user->hasRole('CSG Officer')
        ? app(CsgOnlineStatusService::class)->getOfficersStatus()
        : [],
        ];
    }
}