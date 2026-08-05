<?php

namespace App\Http\Middleware;

use Illuminate\Http\Request;
use Inertia\Middleware;
use App\Models\User\Notification;
use App\Services\CsgOnlineStatusService;
use App\Services\RolePermissionService;

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
                    ? Notification::where('archive', 0)
                        ->orderBy('created_at', 'desc')
                        ->get()
                    : [],
            ],
            'onlineOfficers' => fn () => $user && $user->hasRole('CSG Officer')
                ? app(CsgOnlineStatusService::class)->getOfficersStatus()
                : [],
        ];
    }
}