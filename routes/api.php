<?php

use Illuminate\Http\Request;
use Illuminate\Support\Facades\Route;
use Illuminate\Support\Facades\Log;
use App\Http\Controllers\Api\ChatbotController;
use App\Http\Controllers\Api\ConcernController;
// Import your controllers here
use App\Http\Controllers\CSG\LedgerEntryController;
use App\Http\Controllers\CSG\ProjectController;
use App\Http\Controllers\Auth\OTPController;
use App\Http\Controllers\Auth\OnboardingController;
use App\Http\Controllers\Auth\BulkRegistrationController;
use App\Http\Controllers\Auth\PasswordResetController;
use Laravel\Sanctum\Http\Middleware\EnsureFrontendRequestsAreStateful;

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
})->middleware('auth:sanctum', 'throttle:120,1');

Route::post('/chatbot', ChatbotController::class)->middleware('auth:sanctum', 'throttle:30,1');

Route::middleware([
    EnsureFrontendRequestsAreStateful::class,
    'auth:sanctum',
    'throttle:60,1',
])->group(function () {
    Route::post('/concerns', [ConcernController::class, 'store']);
    Route::get('/concerns', [ConcernController::class, 'index']);
    Route::patch('/concerns/{id}/favorite', [ConcernController::class, 'toggleFavorite']);
});

/**
 * AUTHENTICATION - OTP Routes (No auth required)
 */
Route::middleware('throttle:5,1')->group(function () {
    Route::post('/send-otp', [OTPController::class, 'sendOTP']);
    Route::post('/verify-otp', [OTPController::class, 'verifyOTP']);
    Route::post('/resend-otp', [OTPController::class, 'resendOTP']);
});

/**
 * PASSWORD RESET - OTP-based password reset (No auth required)
 */
Route::prefix('password-reset')->middleware('throttle:5,1')->group(function () {
    Route::post('/send-otp', [PasswordResetController::class, 'sendOTP']);
    Route::post('/verify-otp', [PasswordResetController::class, 'verifyOTP']);
    Route::post('/reset', [PasswordResetController::class, 'resetPassword']);
});

/**
 * BULK REGISTRATION - Role Specific Registration (No auth required)
 */
Route::middleware('throttle:5,1')->group(function () {
    Route::post('/auth/register-teacher', [BulkRegistrationController::class, 'registerTeacher']);
    Route::post('/auth/register-student', [BulkRegistrationController::class, 'registerStudent']);
});

/**
 * DATA PROVIDERS - Courses and Institutes (No auth required)
 */
Route::get('/registration-roles', function () {
    $roles = \App\Models\Role::query()
        ->whereIn('slug', ['student', 'teacher'])
        ->where('archive', false)
        ->select('id', 'name', 'slug')
        ->get();

    return response()->json(['roles' => $roles]);
})->middleware('throttle:120,1');

Route::get('/institutes', function () {
    try {
        Log::info('Fetching institutes from table: institute');
        $institutes = \App\Models\Institute::where('archive', 0)->select('id', 'name')->get();
        Log::info('Institutes fetched successfully', ['count' => count($institutes)]);
        return response()->json(['institutes' => $institutes]);
    } catch (\Exception $e) {
        Log::error('Failed to fetch institutes', ['error' => $e->getMessage()]);
        return response()->json([
            'error' => 'Unable to fetch institutes at this time.',
            'institutes' => []
        ], 500);
    }
})->middleware('throttle:120,1');

Route::get('/courses', function () {
    try {
        Log::info('Fetching courses from table: course');
        $courses = \App\Models\Course::where('archive', 0)->select('id', 'name')->get();
        Log::info('Courses fetched successfully', ['count' => count($courses)]);
        return response()->json(['courses' => $courses]);
    } catch (\Exception $e) {
        Log::error('Failed to fetch courses', ['error' => $e->getMessage()]);
        return response()->json([
            'error' => 'Unable to fetch courses at this time.',
            'courses' => []
        ], 500);
    }
})->middleware('throttle:120,1');

/**
 * ONBOARDING ROUTES
 * Handled via API directly to prevent Inertia HTML redirects
 */
Route::prefix('onboarding')->middleware([
    EnsureFrontendRequestsAreStateful::class,
    'auth:sanctum',
    'throttle:60,1',
])->group(function () {
    Route::post('/complete', [OnboardingController::class, 'complete']);
    Route::post('/skip', [OnboardingController::class, 'skip']);
    Route::post('/set-password', [OnboardingController::class, 'setPassword']);
    // routes/api.php
    Route::get('/onboarding/data', [OnboardingController::class, 'getOnboardingData']);
});

Route::prefix('onboarding')->middleware('throttle:60,1')->group(function () {
    Route::get('/courses', [OnboardingController::class, 'getCourses']);
    Route::get('/institutes', [OnboardingController::class, 'getInstitutes']);
});

/**
 * CSG FINANCIAL SYSTEM ROUTES
 */

Route::middleware([
    EnsureFrontendRequestsAreStateful::class,
    'auth:sanctum',
    'throttle:60,1',
])->group(function () {
    // Route to create a new ledger entry with file upload
    Route::post('/ledger-entries', [LedgerEntryController::class, 'store']);

    // CSV bulk-upload: preview the grouped entries before committing, then create them.
    Route::post('/ledger-entries/bulk-preview', [LedgerEntryController::class, 'bulkPreview']);
    Route::post('/ledger-entries/bulk-upload', [LedgerEntryController::class, 'bulkStore']);

    // Route to handle the document/image upload for a specific ledger entry
    Route::post('/ledger-entries/{id}/upload', [LedgerEntryController::class, 'uploadProof']);

    // Route to fetch all entries for a specific project
    Route::get('/ledger-entries/project/{projectId}', [LedgerEntryController::class, 'index']);

    // Route to fetch all entries (accepts project_id as query parameter)
    Route::get('/ledger-entries', [LedgerEntryController::class, 'all']);

    // Route to verify blockchain integrity for a project
    Route::get('/projects/{projectId}/verify-chain', [LedgerEntryController::class, 'verifyChain']);

    Route::apiResource('projects', ProjectController::class, [
        'only' => ['index', 'store', 'show', 'update', 'destroy']
    ]);
});