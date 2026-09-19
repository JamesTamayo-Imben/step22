<?php

namespace App\Http\Middleware;

use Closure;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Auth;
use Symfony\Component\HttpFoundation\Response;

class CheckRole
{
    /**
     * Handle an incoming request.
     *
     * @param  \Closure(\Illuminate\Http\Request): (\Symfony\Component\HttpFoundation\Response)  $next
     * @param  string  ...$roles
     */
    public function handle(Request $request, Closure $next, ...$roles): Response
    {
        // Ensure user is authenticated
        if (!Auth::check()) {
            return redirect()->route('login')->with('error', 'You must be logged in to access this resource.');
        }

        $user = Auth::user();
        
        // Load user role relationship if not loaded
        if (!$user->relationLoaded('role')) {
            $user->load('role');
        }

        $userRole = $user->role?->slug;

        // Check if user's role is in allowed roles
        if (!in_array($userRole, $roles)) {
            \Log::warning('Unauthorized access attempt', [
                'user_id' => $user->id,
                'user_role' => $userRole,
                'allowed_roles' => $roles,
                'path' => $request->path(),
                'method' => $request->method(),
                'ip' => $request->ip(),
            ]);

            if ($request->expectsJson()) {
                return response()->json([
                    'success' => false,
                    'message' => 'You do not have permission to access this resource.',
                    'error' => 'Unauthorized',
                ], Response::HTTP_FORBIDDEN);
            }

            $dashboardRoute = match ($userRole) {
                'superadmin' => 'sadmin.dashboard',
                'admin', 'admin-sadu' => 'adviser.dashboard',
                'csg' => 'csg.dashboard',
                'student', 'teacher' => 'user.dashboard',
                default => 'dashboard',
            };

            return redirect()->route($dashboardRoute)
                ->with('error', 'Your role has changed. You were redirected to the correct dashboard.');
        }

        return $next($request);
    }
}
