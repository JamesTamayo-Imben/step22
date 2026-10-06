<?php

namespace App\Http\Controllers\Auth;

use App\Http\Controllers\Controller;
use App\Mail\OTPMail;
use App\Models\User;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Auth;
use Illuminate\Support\Facades\Cache;
use Illuminate\Support\Facades\Hash;
use Illuminate\Support\Facades\Log;
use Illuminate\Support\Facades\Mail;
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

        // Check if user is archived
        if ($user->archive) {
            Log::warning('Archived user login attempt', [
                'email' => $validated['email'],
                'user_id' => $user->id,
            ]);
            return response()->json([
                'message' => 'This account is no longer available.',
            ], 404);
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

        // Get user role from already loaded relation
        $role = $user->role ? $user->role->slug : 'student';

        // Check if superadmin flag is present in request
        $isSuperAdminAttempt = $request->input('isSuperAdmin', false);

        // Prevent superadmin from logging in through regular login form
        if ($role === 'superadmin' && !$isSuperAdminAttempt) {
            Log::warning('Superadmin login attempt through regular login portal', [
                'email' => $validated['email'],
                'user_id' => $user->id,
            ]);
            return response()->json([
                'message' => 'Access denied.',
            ], 403);
        }

        // Prevent non-superadmin from logging in through superadmin portal
        if ($role !== 'superadmin' && $isSuperAdminAttempt) {
            Log::warning('Non-superadmin login attempt through superadmin portal', [
                'email' => $validated['email'],
                'user_id' => $user->id,
                'role' => $role,
            ]);
            return response()->json([
                'message' => 'Only superadmin accounts can access this portal. Your account does not have superadmin privileges.',
            ], 403);
        }

        // Authenticate the user for session
        Auth::login($user);

        // Update last login timestamp
        $user->update(['last_login_at' => now()]);

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
     * Send a superadmin login OTP challenge to the user's email.
     */
    public function sendSuperAdminLoginOTP(Request $request)
    {
        try {
            $validated = $request->validate([
                'email' => ['required', 'string', 'email'],
                'password' => ['required', 'string'],
            ]);

            $user = User::with('role')->where('email', $validated['email'])->first();

            if (!$user) {
                return response()->json([
                    'success' => false,
                    'message' => 'Invalid email or password.',
                ], 401);
            }

            if (!Hash::check($validated['password'], $user->password)) {
                return response()->json([
                    'success' => false,
                    'message' => 'Invalid email or password.',
                ], 401);
            }

            if ($user->archive) {
                return response()->json([
                    'success' => false,
                    'message' => 'This account is no longer available.',
                ], 404);
            }

            if ($user->status !== 'active') {
                return response()->json([
                    'success' => false,
                    'message' => 'Your account is ' . $user->status . '. Please contact an administrator.',
                ], 403);
            }

            if (($user->role?->slug ?? '') !== 'superadmin') {
                return response()->json([
                    'success' => false,
                    'message' => 'Only superadmin accounts can access this portal.',
                ], 403);
            }

            $otp = str_pad((string) random_int(0, 999999), 6, '0', STR_PAD_LEFT);
            $cacheKey = 'superadmin_login_otp_' . strtolower($user->email);

            Cache::put($cacheKey, [
                'otp' => $otp,
                'user_id' => $user->id,
                'email' => $user->email,
                'issued_at' => now()->toDateTimeString(),
            ], now()->addMinutes(10));

            Mail::to($user->email)->send(new OTPMail($user->name, $otp));

            Log::info('Superadmin login OTP sent', [
                'email' => $user->email,
                'user_id' => $user->id,
            ]);

            return response()->json([
                'success' => true,
                'message' => 'A verification code has been sent to your email.',
            ], 200);
        } catch (ValidationException $e) {
            return response()->json([
                'success' => false,
                'message' => $e->validator->errors()->first(),
            ], 422);
        } catch (\Throwable $e) {
            Log::error('Superadmin login OTP send failed', [
                'error' => $e->getMessage(),
            ]);

            return response()->json([
                'success' => false,
                'message' => 'Unable to send the verification code at this time. Please try again later.',
            ], 500);
        }
    }

    /**
     * Verify the OTP sent to the superadmin and complete the login.
     */
    public function verifySuperAdminLoginOTP(Request $request)
    {
        try {
            $validated = $request->validate([
                'email' => ['required', 'string', 'email'],
                'password' => ['required', 'string'],
                'otp' => ['required', 'string', 'size:6'],
            ]);

            $user = User::with('role')->where('email', $validated['email'])->first();

            if (!$user) {
                return response()->json([
                    'success' => false,
                    'message' => 'Invalid email or password.',
                ], 401);
            }

            if (!Hash::check($validated['password'], $user->password)) {
                return response()->json([
                    'success' => false,
                    'message' => 'Invalid email or password.',
                ], 401);
            }

            if (($user->role?->slug ?? '') !== 'superadmin') {
                return response()->json([
                    'success' => false,
                    'message' => 'Only superadmin accounts can access this portal.',
                ], 403);
            }

            $cacheKey = 'superadmin_login_otp_' . strtolower($user->email);
            $otpData = Cache::get($cacheKey);

            if (!$otpData) {
                return response()->json([
                    'success' => false,
                    'message' => 'The verification code has expired. Please request a new one.',
                ], 400);
            }

            if (($otpData['otp'] ?? null) !== $validated['otp']) {
                return response()->json([
                    'success' => false,
                    'message' => 'Invalid verification code. Please try again.',
                ], 400);
            }

            Cache::forget($cacheKey);

            Auth::login($user);
            $user->update(['last_login_at' => now()]);

            Log::info('Superadmin login verified successfully', [
                'email' => $user->email,
                'user_id' => $user->id,
            ]);

            return response()->json([
                'success' => true,
                'message' => 'Login successful.',
                'user' => [
                    'id' => $user->id,
                    'name' => $user->name,
                    'email' => $user->email,
                    'role' => 'superadmin',
                    'role_name' => $user->role ? $user->role->name : 'Super Admin',
                ],
                'redirect' => '/sadmin/dashboard',
            ], 200);
        } catch (ValidationException $e) {
            return response()->json([
                'success' => false,
                'message' => $e->validator->errors()->first(),
            ], 422);
        } catch (\Throwable $e) {
            Log::error('Superadmin login OTP verification failed', [
                'error' => $e->getMessage(),
            ]);

            return response()->json([
                'success' => false,
                'message' => 'Unable to verify the code at this time. Please try again later.',
            ], 500);
        }
    }

    /**
     * Determine dashboard redirect URL based on user role
     */
    private function getRedirectUrlByRole($role): string
    {
        return match($role) {
            'superadmin' => '/sadmin/dashboard',
            'admin' => '/adviser/dashboard',
            'admin-sadu' => '/adviser/dashboard',
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
