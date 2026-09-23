<?php

namespace App\Http\Middleware;

use Closure;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Auth;
use Symfony\Component\HttpFoundation\Response;

class LogoutArchivedUsers
{
    private const MESSAGE = 'your account has been archived from the system please contact the authorities';

    public function handle(Request $request, Closure $next): Response
    {
        $user = $request->user();

        if (!$user || !$user->archive) {
            return $next($request);
        }

        Auth::logout();
        $request->session()->invalidate();
        $request->session()->regenerateToken();

        if ($request->expectsJson() || $request->is('api/*')) {
            return response()->json([
                'message' => self::MESSAGE,
            ], 401);
        }

        $request->session()->flash('archived_message', self::MESSAGE);

        return redirect()->route('login');
    }
}