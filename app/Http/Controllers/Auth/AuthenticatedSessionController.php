<?php

namespace App\Http\Controllers\Auth;

use App\Http\Controllers\Controller;
use App\Http\Requests\Auth\LoginRequest;
use App\Services\CsgOnlineStatusService;
use Illuminate\Http\RedirectResponse;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Auth;
use Illuminate\Support\Facades\Route;
use Inertia\Inertia;
use Inertia\Response;

class AuthenticatedSessionController extends Controller
{
    /**
     * Display the login view.
     */
    public function create(): Response
    {
        return Inertia::render('Auth/Login', [
            'canResetPassword' => Route::has('password.request'),
            'status' => session('status'),
        ]);
    }

    /**
     * Handle an incoming authentication request.
     */
    public function store(LoginRequest $request): RedirectResponse
    {
        $request->authenticate();

        $request->session()->regenerate();

        // Get the authenticated user with their role
        $user = Auth::user();
        $user->load('role');

        if ($user->hasRole('CSG Officer')) {
            app(CsgOnlineStatusService::class)->markOnline($request->session()->getId());
        }

        // Determine redirect path based on role
        $redirectPath = route('dashboard', absolute: false);

        if ($user->role) {
            switch ($user->role->slug) {
                case 'superadmin':
                    $redirectPath = route('sadmin.dashboard', absolute: false);
                    break;
                case 'admin':
                    $redirectPath = route('adviser.dashboard', absolute: false);
                    break;
                case 'csg':
                    $redirectPath = route('csg.dashboard', absolute: false);
                    break;
                case 'student':
                case 'teacher':
                    $redirectPath = route('user.dashboard', absolute: false);
                    break;
            }
        }

        return redirect()->intended($redirectPath);
    }

    /**
     * Destroy an authenticated session.
     */
    public function destroy(Request $request): RedirectResponse
    {
        $userId = Auth::id();

        if ($userId) {
            app(CsgOnlineStatusService::class)->markOffline($userId);
        }

        Auth::guard('web')->logout();

        $request->session()->invalidate();

        $request->session()->regenerateToken();

        return redirect('/');
    }
}
