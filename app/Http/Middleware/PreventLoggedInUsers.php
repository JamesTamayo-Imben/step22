<?php

namespace App\Http\Middleware;

use Closure;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Auth;
use Symfony\Component\HttpFoundation\Response;

class PreventLoggedInUsers
{
    /**
     * Handle an incoming request.
     * Prevents authenticated users from accessing login/welcome pages.
     * Exception: Super Admin users can access freely for debugging/testing.
     * Redirects other authenticated users to their appropriate dashboard based on role.
     *
     * @param  \Closure(\Illuminate\Http\Request): (\Symfony\Component\HttpFoundation\Response)  $next
     */
    public function handle(Request $request, Closure $next): Response
    {
        // If user is already authenticated, check their role
        if (Auth::check()) {
            $user = Auth::user();
            $user->load('role');
            $userRole = $user->role?->slug;

            // Allow super admin to access freely for debugging/testing
            if ($userRole === 'superadmin') {
                return $next($request);
            }

            // Redirect other authenticated users to appropriate dashboard based on role
            $dashboardRoutes = [
                'admin' => 'adviser.dashboard',
                'csg' => 'csg.dashboard',
                'student' => 'user.dashboard',
                'teacher' => 'user.dashboard', // Default to user dashboard for teachers
            ];

            $route = $dashboardRoutes[$userRole] ?? 'dashboard';

            return redirect()->route($route)
                ->with('info', 'You are already logged in.');
        }

        return $next($request);
    }
}
