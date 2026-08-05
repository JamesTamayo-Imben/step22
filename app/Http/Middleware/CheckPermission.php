<?php

namespace App\Http\Middleware;

use App\Services\RolePermissionService;
use Closure;
use Illuminate\Http\Request;
use Symfony\Component\HttpFoundation\Response;

class CheckPermission
{
    public function handle(Request $request, Closure $next, string ...$permissions): Response
    {
        $user = $request->user();
        $service = app(RolePermissionService::class);

        foreach ($permissions as $permission) {
            if ($service->userCan($user, $permission)) {
                return $next($request);
            }
        }

        if ($request->expectsJson() || $request->is('api/*')) {
            return response()->json([
                'message' => 'You do not have permission to perform this action.',
                'required' => $permissions,
            ], 403);
        }

        return redirect()->back()->with('error', 'You do not have permission to perform this action.');
    }
}
