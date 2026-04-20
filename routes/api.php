<?php

use Illuminate\Http\Request;
use Illuminate\Support\Facades\Route;
use Illuminate\Support\Facades\Log;
use App\Http\Controllers\Api\ChatbotController;
// Import your controllers here
use App\Http\Controllers\CSG\LedgerEntryController;
use App\Http\Controllers\Auth\OTPController;
use App\Http\Controllers\Auth\OnboardingController;
use App\Http\Controllers\Auth\BulkRegistrationController;

/*
|--------------------------------------------------------------------------
| API Routes
|--------------------------------------------------------------------------
|
| Here is where you can register API routes for your application. These
| routes are loaded by the RouteServiceProvider and all of them will
| be assigned to the "api" middleware group. Make things great!
|
*/

// Default Sanctum User Route
Route::get('/user', function (Request $request) {
    return $request->user();
})->middleware('auth:sanctum');

Route::post('/chatbot', ChatbotController::class)->middleware('auth:sanctum');

/**
 * AUTHENTICATION - OTP Routes (No auth required)
 */
Route::post('/send-otp', [OTPController::class, 'sendOTP']);
Route::post('/verify-otp', [OTPController::class, 'verifyOTP']);
Route::post('/resend-otp', [OTPController::class, 'resendOTP']);

/**
 * BULK REGISTRATION - Role Specific Registration (No auth required)
 */
Route::post('/auth/register-teacher', [BulkRegistrationController::class, 'registerTeacher']);
Route::post('/auth/register-student', [BulkRegistrationController::class, 'registerStudent']);

/**
 * DATA PROVIDERS - Courses and Institutes (No auth required)
 */
Route::get('/institutes', function () {
    try {
        Log::info('Fetching institutes from table: institute');
        $institutes = \App\Models\Institute::where('archive', 0)->select('id', 'name')->get();
        Log::info('Institutes fetched successfully', ['count' => count($institutes)]);
        return response()->json(['institutes' => $institutes]);
    } catch (\Exception $e) {
        Log::error('Failed to fetch institutes', ['error' => $e->getMessage()]);
        return response()->json([
            'error' => $e->getMessage(),
            'institutes' => []
        ], 500);
    }
});

Route::get('/courses', function () {
    try {
        Log::info('Fetching courses from table: course');
        $courses = \App\Models\Course::where('archive', 0)->select('id', 'name')->get();
        Log::info('Courses fetched successfully', ['count' => count($courses)]);
        return response()->json(['courses' => $courses]);
    } catch (\Exception $e) {
        Log::error('Failed to fetch courses', ['error' => $e->getMessage()]);
        return response()->json([
            'error' => $e->getMessage(),
            'courses' => []
        ], 500);
    }
});

/**
 * ONBOARDING ROUTES
 * Handled via API directly to prevent Inertia HTML redirects
 */
Route::prefix('onboarding')->group(function () {
    Route::post('/complete', [OnboardingController::class, 'complete']);
    Route::post('/skip', [OnboardingController::class, 'skip']);
    Route::post('/set-password', [OnboardingController::class, 'setPassword']);
    Route::get('/courses', [OnboardingController::class, 'getCourses']);
    Route::get('/institutes', [OnboardingController::class, 'getInstitutes']);
    // routes/api.php
    Route::get('/onboarding/data', [OnboardingController::class, 'getOnboardingData']);
});

/**
 * CSG FINANCIAL SYSTEM ROUTES
 */

// Route to create a new ledger entry with file upload
// This is used by the CSG Add Ledger Entry modal
Route::post('/ledger-entries', [LedgerEntryController::class, 'store']);

// Route to handle the document/image upload for a specific ledger entry
// This matches your React fetch: `/api/ledger-entries/{id}/upload`
Route::post('/ledger-entries/{id}/upload', [LedgerEntryController::class, 'uploadProof']);

// Route to fetch all entries for a specific project
// Supports both: /api/ledger-entries/project/{projectId} and query param
Route::get('/ledger-entries/project/{projectId}', [LedgerEntryController::class, 'index']);

// Route to fetch all entries (accepts project_id as query parameter)
Route::get('/ledger-entries', [LedgerEntryController::class, 'all']);

// Route to verify blockchain integrity for a project
Route::get('/projects/{projectId}/verify-chain', [LedgerEntryController::class, 'verifyChain']);