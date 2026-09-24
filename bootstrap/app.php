<?php

use Illuminate\Foundation\Application;
use Illuminate\Foundation\Configuration\Exceptions;
use Illuminate\Foundation\Configuration\Middleware;
use Illuminate\Console\Scheduling\Schedule;

return Application::configure(basePath: dirname(__DIR__))
    ->withRouting(
        web: __DIR__.'/../routes/web.php',
        api: __DIR__.'/../routes/api.php',
        commands: __DIR__.'/../routes/console.php',
        health: '/up',
    )
    ->withMiddleware(function (Middleware $middleware): void {
        // Trust proxies for HTTPS/TLS in production
        $middleware->trustProxies(at: '*');
        
        $middleware->web(append: [
            \App\Http\Middleware\SecurityHeaders::class,
            \App\Http\Middleware\HandleInertiaRequests::class,
            \Illuminate\Http\Middleware\AddLinkHeadersForPreloadedAssets::class,
            \App\Http\Middleware\LogoutArchivedUsers::class,
        ]);

        $middleware->api(append: [
            \App\Http\Middleware\LogoutArchivedUsers::class,
        ]);

        // Register role-based access control middleware
        // Register middleware that prevents logged-in users from accessing login/welcome pages
        $middleware->alias([
            'role' => \App\Http\Middleware\CheckRole::class,
            'permission' => \App\Http\Middleware\CheckPermission::class,
            'prevent_logged_in' => \App\Http\Middleware\PreventLoggedInUsers::class,
            'csg.online' => \App\Http\Middleware\TrackCsgOnlineStatus::class,
        ]);

        $middleware->validateCsrfTokens(except: [
            'api/*',
        ]);
    })
    ->withSchedule(function (Schedule $schedule): void {
        $schedule->command('assets:return-expired')->daily();
    })
    ->withExceptions(function (Exceptions $exceptions): void {
        //
    })->create();
