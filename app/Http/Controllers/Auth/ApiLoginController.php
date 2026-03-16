<?php

namespace App\Http\Controllers\Auth;

use App\Http\Controllers\Controller;
use App\Models\User;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Auth;
use Illuminate\Support\Facades\Hash;
use Illuminate\Support\Facades\Log;
use Illuminate\Validation\ValidationException;

class ApiLoginController extends Controller
{
    /**
     * Handle an incoming API login request.
     * Authenticates user against step2 database and returns JSON response with role and redirect URL
     */
    public function login(Request $request)
    {
        // Validate incoming request
        $validated = $request->validate([
            'email' => ['required', 'string', 'email'],
            'password' => ['required', 'string'],
        ]);

        // Log the login attempt for debugging
        Log::info('Login attempt', [
            'email' => $validated['email'],
            'timestamp' => now(),
        ]);

        // Find user by email from step2 database
        $user = User::with('role')->where('email', $validated['email'])->first();

        // Debug: Log if user was found
        if (!$user) {
            Log::warning('User not found during login attempt', [
                'email' => $validated['email'],
            ]);
            return response()->json([
                'message' => 'Invalid email or password',
            ], 401);
        }

        // Debug: Log user found and password check
        $passwordValid = Hash::check($validated['password'], $user->password);
        Log::info('User found, checking password', [
            'email' => $validated['email'],
            'user_id' => $user->id,
            'password_valid' => $passwordValid,
            'user_status' => $user->status,
        ]);

        // Check if user exists and password is correct
        if (!$passwordValid) {
            Log::warning('Invalid password during login attempt', [
                'email' => $validated['email'],
                'user_id' => $user->id,
            ]);
            return response()->json([
                'message' => 'Invalid email or password',
            ], 401);
        }

        // Check if user is active
        if ($user->status !== 'active') {
            Log::warning('Account not active during login attempt', [
                'email' => $validated['email'],
                'status' => $user->status,
            ]);
            return response()->json([
                'message' => 'Your account is ' . $user->status . '. Please contact an administrator.',
            ], 403);
        }

        // Authenticate the user for session
        Auth::login($user);

        // Get user role from already loaded relation
        $role = $user->role ? $user->role->slug : 'student';

        // Log successful login
        Log::info('Login successful', [
            'email' => $validated['email'],
            'user_id' => $user->id,
            'role' => $role,
        ]);

        // Determine redirect URL based on role
        $redirectUrl = $this->getRedirectUrlByRole($role);

        return response()->json([
            'success' => true,
            'message' => 'Login successful',
            'user' => [
                'id' => $user->id,
                'name' => $user->name,
                'email' => $user->email,
                'role' => $role,
                'role_name' => $user->role ? $user->role->name : 'User',
            ],
            'redirect' => $redirectUrl,
        ], 200);
    }

    /**
     * Determine dashboard redirect URL based on user role
     */
    private function getRedirectUrlByRole($role): string
    {
        return match($role) {
            'superadmin' => '/sadmin/dashboard',
            'admin' => '/adviser/dashboard',
            'csg' => '/csg/dashboard',
            'student' => '/user/dashboard',
            'teacher' => '/user/dashboard',
            default => '/dashboard',
        };  
    }

    /**
     * Get current authenticated user
     */
    public function getUser(Request $request)
    {
        if (!Auth::check()) {
            return response()->json([
                'authenticated' => false,
            ], 401);
        }

        $user = Auth::user();

        return response()->json([
            'authenticated' => true,
            'user' => [
                'id' => $user->id,
                'name' => $user->name,
                'email' => $user->email,
                'role' => $user->role ? $user->role->slug : 'student',
                'role_name' => $user->role ? $user->role->name : 'User',
            ],
        ], 200);
    }

    /**
     * Logout the user
     */
    public function logout(Request $request)
    {
        Auth::logout();

        $request->session()->invalidate();
        $request->session()->regenerateToken();

        return response()->json([
            'success' => true,
            'message' => 'Logged out successfully',
        ], 200);
    }
}
