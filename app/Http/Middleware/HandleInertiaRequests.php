<?php

namespace App\Http\Middleware;

use Illuminate\Http\Request;
use Inertia\Middleware;
use App\Models\Notification; // Ensure you have created this Model

class HandleInertiaRequests extends Middleware
{
    protected $rootView = 'app';

    public function version(Request $request): ?string
    {
        return parent::version($request);
    }

    public function share(Request $request): array
    {
        return [
            ...parent::share($request),
            'auth' => [
                'user' => $request->user(),
                // Connection Logic: Fetch unread notifications for the logged-in user
                // 'notifications' => $request->user() 
                //     ? Notification::where('user_id', $request->user()->id)
                //         ->where('is_read', 0)
                //         ->where('archive', 0)
                //         ->orderBy('created_at', 'desc')
                //         ->get()
                //     : [],
                'notifications' => $request->user() 
    ? \App\Models\Notification::where('archive', 0) // Remove user_id check just for testing
        ->orderBy('created_at', 'desc')
        ->get()
    : [],
            ],
        ];
    }
}