<?php

// Configuration for Laravel Session & Cookie Management
// This file shows how cookies and sessions work together for authentication

/*
|--------------------------------------------------------------------------
| COOKIES & SESSION AUTHENTICATION FLOW
|--------------------------------------------------------------------------
|
| When a user visits your application, Laravel uses cookies and sessions
| to maintain authentication state across requests.
|
| KEY POINTS:
| 1. Session starts when user visits ANY page (stored in database)
| 2. Session is identified by a LARAVEL_SESSION cookie sent to browser
| 3. Auth flag is stored IN the session ONLY after successful login
| 4. Every page request checks the session for the auth flag
| 5. Without the auth flag, user is redirected to login page
| 6. Session is regenerated after login (security against fixation)
|
*/

return [
    // ========== CURRENT CONFIGURATION ==========
    'driver' => env('SESSION_DRIVER', 'database'),  // Sessions stored in database
    'lifetime' => (int) env('SESSION_LIFETIME', 120), // 120 minutes (2 hours)
    'expire_on_close' => env('SESSION_EXPIRE_ON_CLOSE', false), // Keep session after browser closes
    'encrypt' => env('SESSION_ENCRYPT', false), // Optional encryption
    'connection' => env('SESSION_CONNECTION', null), // Uses default DB connection
    'table' => env('SESSION_TABLE', 'sessions'), // Database table for sessions
    
    // ========== COOKIE CONFIGURATION ==========
    'cookie' => env('SESSION_COOKIE', 'LARAVEL_SESSION'), // Cookie name sent to browser
    'path' => '/',
    'domain' => env('SESSION_DOMAIN', null),
    'secure' => env('SESSION_SECURE_COOKIES', false),
    'http_only' => true, // Cannot be accessed by JavaScript (prevents XSS attacks)
    'same_site' => 'lax', // CSRF protection
    
    // ========== PARTITIONED COOKIE (for cross-site scenarios) ==========
    'partitioned' => false,

    // ========== HOW AUTHENTICATION & SESSIONS WORK TOGETHER ==========
    
    /*
    STEP-BY-STEP AUTH FLOW:
    
    1. USER VISITS /login
       ↓
       → Session created automatically (middleware starts session)
       → Empty session stored in sessions table
       → Browser receives LARAVEL_SESSION cookie with session ID
       
    2. USER SUBMITS LOGIN FORM
       ↓
       → LoginRequest validates email & password
       → Auth::attempt($credentials) attempts authentication
       → If valid: Auth guard stores user ID in session data
       → If invalid: ValidationException thrown
       
    3. SESSION REGENERATION (Security)
       ↓
       → Old session destroyed from database
       → New session created (prevents session fixation attacks)
       → New LARAVEL_SESSION cookie sent to browser
       → User redirected to dashboard
       
    4. SUBSEQUENT REQUESTS
       ↓
       → Browser sends LARAVEL_SESSION cookie with every request
       → Laravel loads session from database using cookie ID
       → Auth middleware checks for user ID in session
       → If found: user is authenticated
       → If not found: redirect to login
       
    5. LOGOUT
       ↓
       → Auth::logout() removes user from session
       → Session invalidated: removed from database
       → Session token regenerated (CSRF protection)
       → Redirect to home page
    */
];

/*
|--------------------------------------------------------------------------
| IMPORTANT: WHY YOU CANNOT ACCESS DASHBOARD WITHOUT LOGIN
|--------------------------------------------------------------------------
|
| The session cookie alone is NOT enough. You also need:
|
| ✗ Session cookie alone          → Redirect to login
| ✗ Empty session (no auth flag)  → Redirect to login
| ✓ Session cookie + Auth flag    → Dashboard accessible
|
| This is enforced by the 'auth' middleware on protected routes:
|
|   Route::middleware(['auth', 'verified'])->get('/dashboard', ...);
|
| The 'auth' middleware checks Auth::check() which looks for:
| - User ID stored in session['auth.id']
| - User authenticated status in session
|
| Without this, even if session exists, user is not authenticated.
*/

?>
