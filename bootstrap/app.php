<?php

use App\Http\Middleware\CheckPermission;
use App\Http\Middleware\CheckRole;
use App\Http\Middleware\HandleInertiaRequests;
use App\Http\Middleware\LogoutArchivedUsers;
use App\Http\Middleware\PreventLoggedInUsers;
use App\Http\Middleware\SecurityHeaders;
use App\Http\Middleware\TrackCsgOnlineStatus;
use Illuminate\Console\Scheduling\Schedule;
use Illuminate\Foundation\Application;
use Illuminate\Foundation\Configuration\Exceptions;
use Illuminate\Foundation\Configuration\Middleware;
use Illuminate\Http\Middleware\AddLinkHeadersForPreloadedAssets;

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
            SecurityHeaders::class,
            HandleInertiaRequests::class,
            AddLinkHeadersForPreloadedAssets::class,
            LogoutArchivedUsers::class,
        ]);

        $middleware->api(append: [
            LogoutArchivedUsers::class,
            'throttle:api',
        ]);

        // Register role-based access control middleware
        // Register middleware that prevents logged-in users from accessing login/welcome pages
        $middleware->alias([
            'role' => CheckRole::class,
            'permission' => CheckPermission::class,
            'prevent_logged_in' => PreventLoggedInUsers::class,
            'csg.online' => TrackCsgOnlineStatus::class,
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
