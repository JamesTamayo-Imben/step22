<?php

namespace App\Providers;

use Illuminate\Support\Facades\Vite;
use Illuminate\Support\ServiceProvider;
use Illuminate\Support\Facades\URL;

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
            \Illuminate\Support\Facades\Response::macro('withSecurityHeaders', function () {
                return $this->header('Strict-Transport-Security', 'max-age=31536000; includeSubDomains; preload');
            });
        }
    }
}
