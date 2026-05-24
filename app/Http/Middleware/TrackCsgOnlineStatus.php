<?php

namespace App\Http\Middleware;

use App\Services\CsgOnlineStatusService;
use Closure;
use Illuminate\Http\Request;
use Symfony\Component\HttpFoundation\Response;

class TrackCsgOnlineStatus
{
  public function __construct(
    private CsgOnlineStatusService $onlineStatus
  ) {}

  /**
   * Keep the current CSG session marked as online while browsing CSG routes.
   */
  public function handle(Request $request, Closure $next): Response
  {
    if ($request->user()?->hasRole('CSG Officer')) {
      $this->onlineStatus->markOnline($request->session()->getId());
    }

    return $next($request);
  }
}
