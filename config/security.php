<?php

return [

    /*
    |--------------------------------------------------------------------------
    | Rate Limiting
    |--------------------------------------------------------------------------
    |
    | Thresholds for the named rate limiters registered in AppServiceProvider.
    | The "ip" limits protect the server as a whole, the "email" limits protect
    | a single account, and the "account" limit protects an account even when
    | the attacker rotates IP addresses.
    |
    */

    'rate_limits' => [

        // Login attempts (web form + /api/login + superadmin OTP login).
        'login' => [
            'per_minute' => env('RATE_LIMIT_LOGIN_PER_MINUTE', 10),
            'per_hour' => env('RATE_LIMIT_LOGIN_PER_HOUR', 30),
            'ip_per_minute' => env('RATE_LIMIT_LOGIN_IP_PER_MINUTE', 30),
        ],

        // Sign up / registration (OTP sign up, teacher + student sign up).
        'register' => [
            'per_minute' => env('RATE_LIMIT_REGISTER_PER_MINUTE', 5),
            'per_hour' => env('RATE_LIMIT_REGISTER_PER_HOUR', 20),
            'ip_per_minute' => env('RATE_LIMIT_REGISTER_IP_PER_MINUTE', 20),
        ],

        // One time password send / verify / resend.
        'otp' => [
            'per_minute' => env('RATE_LIMIT_OTP_PER_MINUTE', 5),
            'per_hour' => env('RATE_LIMIT_OTP_PER_HOUR', 20),
            'ip_per_minute' => env('RATE_LIMIT_OTP_IP_PER_MINUTE', 20),
        ],

        // Forgot password / reset password.
        'password_reset' => [
            'per_minute' => env('RATE_LIMIT_PASSWORD_RESET_PER_MINUTE', 5),
            'per_hour' => env('RATE_LIMIT_PASSWORD_RESET_PER_HOUR', 20),
            'ip_per_minute' => env('RATE_LIMIT_PASSWORD_RESET_IP_PER_MINUTE', 20),
        ],

        // Password generator endpoint.
        'password_generate' => [
            'per_minute' => env('RATE_LIMIT_PASSWORD_GENERATE_PER_MINUTE', 30),
            'ip_per_minute' => env('RATE_LIMIT_PASSWORD_GENERATE_IP_PER_MINUTE', 60),
        ],

        // Default limiter applied to the whole /api route group.
        'api' => [
            'per_minute' => env('RATE_LIMIT_API_PER_MINUTE', 120),
        ],
    ],

    /*
    |--------------------------------------------------------------------------
    | Account Lockout
    |--------------------------------------------------------------------------
    |
    | After this many consecutive failed logins the account is locked for the
    | configured number of minutes, regardless of the IP address used.
    |
    */

    'lockout' => [
        'max_attempts' => env('AUTH_LOCKOUT_MAX_ATTEMPTS', 5),
        'decay_minutes' => env('AUTH_LOCKOUT_DECAY_MINUTES', 15),
    ],

    /*
    |--------------------------------------------------------------------------
    | Password Policy
    |--------------------------------------------------------------------------
    |
    | A single source of truth for every password validation rule in the app.
    | Tighten the boolean switches to enforce stronger passwords everywhere.
    |
    */

    'password' => [
        'min_length' => env('PASSWORD_MIN_LENGTH', 8),
        'max_length' => env('PASSWORD_MAX_LENGTH', 72),
        'require_mixed_case' => env('PASSWORD_REQUIRE_MIXED_CASE', false),
        'require_numbers' => env('PASSWORD_REQUIRE_NUMBERS', false),
        'require_symbols' => env('PASSWORD_REQUIRE_SYMBOLS', false),
    ],

    /*
    |--------------------------------------------------------------------------
    | Password Generator
    |--------------------------------------------------------------------------
    */

    'password_generator' => [
        'default_length' => env('PASSWORD_GENERATOR_LENGTH', 16),
        'min_length' => env('PASSWORD_GENERATOR_MIN_LENGTH', 12),
        'max_length' => env('PASSWORD_GENERATOR_MAX_LENGTH', 64),
        'default_words' => env('PASSWORD_GENERATOR_WORDS', 4),
        'min_words' => 3,
        'max_words' => 8,
    ],

];
