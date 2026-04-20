<?php

namespace App\Http\Controllers\Auth;

use App\Http\Controllers\Controller;
use App\Mail\OTPMail;
use App\Models\User;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Cache;
use Illuminate\Support\Facades\DB;
use Illuminate\Support\Facades\Hash;
use Illuminate\Support\Facades\Log;
use Illuminate\Support\Facades\Mail;

class PasswordResetController extends Controller
{
    /**
     * Step 1: Send OTP to user's email for password reset
     * 
     * Request body:
     * {
     *   "email": "user@kld.edu.ph"
     * }
     */
    public function sendOTP(Request $request)
    {
        try {
            $request->validate([
                'email' => 'required|email',
            ]);

            $email = $request->email;

            // Check if user exists
            $user = User::where('email', $email)->first();
            if (!$user) {
                // Don't reveal if email exists or not (security best practice)
                return response()->json([
                    'success' => true,
                    'message' => 'If the email exists, an OTP has been sent',
                ], 200);
            }

            // Generate 6-digit OTP
            $otp = str_pad(random_int(0, 999999), 6, '0', STR_PAD_LEFT);

            // Store OTP in cache for 10 minutes
            Cache::put("password_reset_otp_{$email}", [
                'otp' => $otp,
                'user_id' => $user->id,
                'created_at' => now(),
            ], now()->addMinutes(10));

            // Send OTP via email
            try {
                Mail::to($email)->send(new OTPMail($user->name, $otp));
                Log::info('✅ Password reset OTP sent', [
                    'email' => $email,
                    'user_id' => $user->id,
                ]);
            } catch (\Exception $emailError) {
                Log::warning('⚠️ Failed to send password reset OTP', [
                    'email' => $email,
                    'error' => $emailError->getMessage(),
                ]);
                // Still return success to not leak information
            }

            return response()->json([
                'success' => true,
                'message' => 'OTP sent to your email',
            ], 200);

        } catch (\Illuminate\Validation\ValidationException $e) {
            return response()->json([
                'success' => false,
                'message' => 'Validation error',
                'errors' => $e->errors(),
            ], 422);
        } catch (\Exception $e) {
            Log::error('❌ Send OTP Error: ' . $e->getMessage());
            return response()->json([
                'success' => false,
                'message' => 'An error occurred',
            ], 500);
        }
    }

    /**
     * Step 2: Verify OTP sent to email
     * 
     * Request body:
     * {
     *   "email": "user@kld.edu.ph",
     *   "otp": "123456"
     * }
     */
    public function verifyOTP(Request $request)
    {
        try {
            $request->validate([
                'email' => 'required|email',
                'otp' => 'required|string|size:6',
            ]);

            $email = $request->email;
            $otp = $request->otp;

            // Retrieve OTP from cache
            $otpData = Cache::get("password_reset_otp_{$email}");

            if (!$otpData) {
                Log::warning('❌ OTP not found or expired', ['email' => $email]);
                return response()->json([
                    'success' => false,
                    'message' => 'OTP expired. Please request a new one.',
                ], 400);
            }

            // Verify OTP
            if ($otpData['otp'] !== $otp) {
                Log::warning('❌ Invalid OTP', ['email' => $email]);
                return response()->json([
                    'success' => false,
                    'message' => 'Invalid OTP code. Please try again.',
                ], 400);
            }

            // Mark OTP as verified by storing verification token
            $verificationToken = bin2hex(random_bytes(32));
            Cache::put("password_reset_verified_{$email}", [
                'token' => $verificationToken,
                'otp' => $otp,
                'user_id' => $otpData['user_id'],
                'verified_at' => now(),
            ], now()->addMinutes(15)); // Token valid for 15 minutes

            Log::info('✅ OTP verified successfully', ['email' => $email]);

            return response()->json([
                'success' => true,
                'message' => 'OTP verified successfully',
                'verification_token' => $verificationToken,
            ], 200);

        } catch (\Illuminate\Validation\ValidationException $e) {
            return response()->json([
                'success' => false,
                'message' => 'Validation error',
                'errors' => $e->errors(),
            ], 422);
        } catch (\Exception $e) {
            Log::error('❌ Verify OTP Error: ' . $e->getMessage());
            return response()->json([
                'success' => false,
                'message' => 'An error occurred',
            ], 500);
        }
    }

    /**
     * Step 3: Reset password after OTP verification
     * 
     * Request body:
     * {
     *   "email": "user@kld.edu.ph",
     *   "otp": "123456",
     *   "password": "new_password"
     * }
     */
    public function resetPassword(Request $request)
    {
        try {
            $request->validate([
                'email' => 'required|email',
                'otp' => 'required|string|size:6',
                'password' => 'required|string|min:8|confirmed',
            ]);

            $email = $request->email;
            $otp = $request->otp;
            $password = $request->password;

            // Check if OTP is verified
            $verifiedData = Cache::get("password_reset_verified_{$email}");

            if (!$verifiedData) {
                Log::warning('❌ No verified OTP found for reset', ['email' => $email]);
                return response()->json([
                    'success' => false,
                    'message' => 'Verification expired. Please start over.',
                ], 400);
            }

            // Double-check OTP
            if ($verifiedData['otp'] !== $otp) {
                Log::warning('❌ OTP mismatch during reset', ['email' => $email]);
                return response()->json([
                    'success' => false,
                    'message' => 'Invalid request',
                ], 400);
            }

            // Find user and update password
            $user = User::find($verifiedData['user_id']);

            if (!$user) {
                Log::error('❌ User not found during password reset', ['email' => $email]);
                return response()->json([
                    'success' => false,
                    'message' => 'User not found',
                ], 404);
            }

            // Update password
            $user->update([
                'password' => Hash::make($password),
            ]);

            // Clear verification cache
            Cache::forget("password_reset_verified_{$email}");
            Cache::forget("password_reset_otp_{$email}");

            Log::info('✅ Password reset successfully', [
                'user_id' => $user->id,
                'email' => $email,
            ]);

            return response()->json([
                'success' => true,
                'message' => 'Password reset successfully. Please log in with your new password.',
            ], 200);

        } catch (\Illuminate\Validation\ValidationException $e) {
            return response()->json([
                'success' => false,
                'message' => 'Validation error',
                'errors' => $e->errors(),
            ], 422);
        } catch (\Exception $e) {
            Log::error('❌ Reset Password Error: ' . $e->getMessage(), [
                'trace' => $e->getTraceAsString(),
            ]);
            return response()->json([
                'success' => false,
                'message' => 'An error occurred while resetting password',
            ], 500);
        }
    }
}
