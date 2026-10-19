<?php

namespace App\Services;

use Illuminate\Support\Facades\RateLimiter;
use Illuminate\Support\Str;

/**
 * Account level login throttling.
 *
 * The route level rate limiters (see AppServiceProvider) are IP based, which
 * means an attacker can rotate IP addresses and keep hammering a single
 * account. This service keeps a counter per e-mail address so that an account
 * gets temporarily locked no matter where the request comes from.
 */
class LoginThrottleService
{
    /**
     * Prefix used for the rate limiter keys so they never collide with the
     * keys used by the named route limiters.
     */
    private const PREFIX = 'auth-lockout:';

    /**
     * Maximum number of consecutive failed logins before the account locks.
     */
    public function maxAttempts(): int
    {
        return (int) config('security.lockout.max_attempts', 5);
    }

    /**
     * Number of seconds an account stays locked (and the window in which the
     * failed attempts are counted).
     */
    public function decaySeconds(): int
    {
        return max(1, (int) config('security.lockout.decay_minutes', 15)) * 60;
    }

    /**
     * The rate limiter key for the given account.
     */
    public function throttleKey(string $email): string
    {
        return self::PREFIX.Str::lower(trim($email));
    }

    /**
     * Number of failed attempts recorded for the account.
     */
    public function attempts(string $email): int
    {
        return RateLimiter::attempts($this->throttleKey($email));
    }

    /**
     * Determine whether the account is currently locked out.
     */
    public function tooManyAttempts(string $email): bool
    {
        return RateLimiter::tooManyAttempts($this->throttleKey($email), $this->maxAttempts());
    }

    /**
     * Record a failed login attempt and return the new attempt count.
     */
    public function hit(string $email): int
    {
        return RateLimiter::hit($this->throttleKey($email), $this->decaySeconds());
    }

    /**
     * Seconds remaining before the lockout expires.
     */
    public function availableIn(string $email): int
    {
        return RateLimiter::availableIn($this->throttleKey($email));
    }

    /**
     * Clear the failure counter after a successful login.
     */
    public function clear(string $email): void
    {
        RateLimiter::clear($this->throttleKey($email));
    }
}
