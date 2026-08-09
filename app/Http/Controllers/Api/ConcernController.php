<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use App\Models\Concern;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Log;
use Illuminate\Support\Facades\RateLimiter;
use Illuminate\Support\Str;

class ConcernController extends Controller
{
    public function index(Request $request)
    {
        $concerns = Concern::query()
            ->orderByDesc('favorite')
            ->orderByDesc('created_at')
            ->get(['id', 'user_id', 'concern', 'favorite', 'created_at']);

        return response()->json(['success' => true, 'concerns' => $concerns]);
    }

    public function toggleFavorite(Request $request, string $id)
    {
        $validated = $request->validate([
            'favorite' => 'required|boolean',
        ]);

        $concern = Concern::findOrFail($id);
        $concern->favorite = $validated['favorite'] ? 1 : 0;
        $concern->save();

        return response()->json(['success' => true, 'concern' => $concern]);
    }

    public function store(Request $request)
    {
        $key = 'concern-submit:' . ($request->user()?->id ?? $request->ip());

        if (RateLimiter::tooManyAttempts($key, 5)) { // 5 attempts
            $seconds = RateLimiter::availableIn($key);

            return response()->json([
                'success' => false,
                'error' => "Too many concerns submitted. Please try again in {$seconds} seconds.",
            ], 429);
        }

        RateLimiter::hit($key, 60); // decay window: 60 seconds

        $validated = $request->validate([
            'concern' => 'required|string|max:1000',
            'contact_answer' => 'nullable|string|max:255',
        ]);

        try {
            $contactAnswer = strtolower(trim($validated['contact_answer'] ?? ''));
            $wantsToBeContacted = $this->shouldRecordUserId($contactAnswer);

            $userId = ($wantsToBeContacted && $request->user())
                ? $request->user()->id
                : null;

            $entry = Concern::create([
                'id' => (string) Str::uuid(),
                'user_id' => $userId,
                'concern' => trim($validated['concern']),
                'favorite' => 0,
                'created_at' => now(),
            ]);

            return response()->json(['success' => true, 'concern' => $entry], 201);
        } catch (\Exception $e) {
            Log::error('Failed to save concern', [
                'message' => $e->getMessage(),
                'request' => $request->all(),
            ]);

            return response()->json([
                'success' => false,
                'error' => 'Unable to save your concern at this time. Please try again later.',
            ], 500);
        }
    }

    protected function shouldRecordUserId(string $contactAnswer): bool
    {
        $normalized = strtolower(trim($contactAnswer));

        return in_array($normalized, ['y', 'yes'], true);
    }
}