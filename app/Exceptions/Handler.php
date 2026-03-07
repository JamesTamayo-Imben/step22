<?php

namespace App\Exceptions;

use Illuminate\Foundation\Exceptions\Handler as ExceptionHandler;
use Throwable;
use Illuminate\Auth\Access\AuthorizationException;
use Inertia\Inertia;
use Symfony\Component\HttpKernel\Exception\HttpException;

class Handler extends ExceptionHandler
{
    /**
     * A list of the exception types that are not reported.
     *
     * @var array<int, class-string<\Throwable>>
     */
    protected $dontReport = [
        //
    ];

    /**
     * A list of the inputs that are never flashed for validation exceptions.
     *
     * @var array<int, string>
     */
    protected $dontFlash = [
        'current_password',
        'password',
        'password_confirmation',
    ];

    /**
     * Register the exception handling callbacks for the application.
     */
    public function register(): void
    {
        //
    }

    /**
     * Render an exception into an HTTP response.
     *
     * @param  \Illuminate\Http\Request  $request
     * @param  \Throwable  $e
     * @return \Symfony\Component\HttpFoundation\Response
     */
    public function render($request, Throwable $e)
    {
        // Handle AuthorizationException and 403 HttpException differently for Inertia requests
        if ($e instanceof AuthorizationException || ($e instanceof HttpException && $e->getStatusCode() === 403)) {
            // If the request is an Inertia/XHR request, render an Inertia page so the SPA layout remains
            if ($request->header('X-Inertia') || $request->wantsJson()) {
                return Inertia::render('Errors/403')->toResponse($request)->setStatusCode(403);
            }

            // Otherwise fallback to the classic Blade view
            return response()->view('errors.403', [], 403);
        }

        return parent::render($request, $e);
    }
}
