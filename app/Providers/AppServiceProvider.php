<?php

namespace App\Providers;

use Illuminate\Cache\RateLimiting\Limit;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\RateLimiter;
use Illuminate\Support\Facades\Response;
use Illuminate\Support\Facades\URL;
use Illuminate\Support\Facades\Vite;
use Illuminate\Support\ServiceProvider;
use Illuminate\Support\Str;

class AppServiceProvider extends ServiceProvider
{
    /**
     * Register any application services.
     */
    public function register(): void
    {
        //
    }

    /**
     * Bootstrap any application services.
     */
    public function boot(): void
    {
        Vite::prefetch(concurrency: 3);

        // Force HTTPS in production
        if (env('APP_ENV') === 'production') {
            URL::forceScheme('https');
        }

        // Enable HSTS (HTTP Strict Transport Security) for enhanced security
        if (env('APP_ENV') === 'production') {
            Response::macro('withSecurityHeaders', function () {
                return $this->header('Strict-Transport-Security', 'max-age=31536000; includeSubDomains; preload');
            });
        }

        $this->registerRateLimiters();
    }

    /**
     * Register the named rate limiters used by the login and sign up routes.
     *
     * Every limiter combines an IP limit (protects the server) with per
     * account limits (protect a single account, even when the attacker
     * rotates IP addresses).
     */
    protected function registerRateLimiters(): void
    {
        RateLimiter::for('login', function (Request $request) {
            return $this->authLimits($request, 'login');
        });

        RateLimiter::for('register', function (Request $request) {
            return $this->authLimits($request, 'register');
        });

        RateLimiter::for('otp', function (Request $request) {
            return $this->authLimits($request, 'otp');
        });

        RateLimiter::for('password-reset', function (Request $request) {
            return $this->authLimits($request, 'password_reset');
        });

        RateLimiter::for('password-generate', function (Request $request) {
            $settings = config('security.rate_limits.password_generate');

            return [
                Limit::perMinute((int) ($settings['per_minute'] ?? 30))
                    ->by('ip:'.$request->ip())
                    ->response($this->throttleResponse('Too many password requests. Please slow down.')),
            ];
        });

        RateLimiter::for('api', function (Request $request) {
            $settings = config('security.rate_limits.api');

            return [
                Limit::perMinute((int) ($settings['per_minute'] ?? 120))
                    ->by($request->user()?->id ?: $request->ip())
                    ->response($this->throttleResponse('Too many requests. Please slow down.')),
            ];
        });
    }

    /**
     * Build the combined IP + account limits for an authentication limiter.
     *
     * @return array<int, Limit>
     */
    protected function authLimits(Request $request, string $group): array
    {
        $settings = config('security.rate_limits.'.$group, []);

        $email = Str::lower(trim((string) $request->input('email')));
        $ip = $request->ip();
        $path = '/'.ltrim($request->path(), '/');

        $limits = [
            Limit::perMinute((int) ($settings['ip_per_minute'] ?? 30))
                ->by('ip:'.$ip)
                ->response($this->throttleResponse('Too many requests from this network. Please try again later.')),
        ];

        // Account based limits are skipped when no e-mail is present so that
        // endpoints without an e-mail field do not share one global bucket.
        if ($email !== '') {
            // The per minute bucket is scoped to the endpoint so that, for
            // example, requesting an OTP does not consume the budget used to
            // verify it.
            $limits[] = Limit::perMinute((int) ($settings['per_minute'] ?? 5))
                ->by('email:'.$email.'|ip:'.$ip.'|path:'.$path)
                ->response($this->throttleResponse('Too many attempts. Please wait a minute and try again.'));

            $limits[] = Limit::perHour((int) ($settings['per_hour'] ?? 20))
                ->by('account:'.$email)
                ->response($this->throttleResponse('Too many attempts for this account. Please try again later.'));
        }

        return $limits;
    }

    /**
     * Build the JSON body returned when a limit is exceeded.
     */
    protected function throttleResponse(string $message): callable
    {
        return function (Request $request, array $headers) use ($message) {
            return response()->json([
                'success' => false,
                'message' => $message,
                'retry_after' => (int) ($headers['Retry-After'] ?? 0),
            ], 429, $headers);
        };
    }
}
