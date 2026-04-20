<?php

namespace App\Http\Controllers;

use Illuminate\Http\Request;
use Inertia\Inertia;

class UserController extends Controller
{
    /**
     * Get current authenticated user with profile data
     */
    public function getCurrentUser(Request $request)
    {
        $user = $request->user();
        
        if (!$user) {
            return response()->json([
                'success' => false,
                'message' => 'Not authenticated',
            ], 401);
        }

        return response()->json([
            'success' => true,
            'user' => [
                'id' => $user->id,
                'name' => $user->name,
                'email' => $user->email,
                'phone' => $user->phone,
                'role' => $user->role ? [
                    'id' => $user->role->id,
                    'name' => $user->role->name,
                ] : null,
                'status' => $user->status,
                'avatar_url' => $user->avatar_url,
                'created_at' => $user->created_at,
            ],
        ]);
    }

    /**
     * Show user dashboard page
     */
    public function dashboard(Request $request)
    {
        $user = $request->user();

        if (!$user) {
            return redirect('/login');
        }

        // Get user role to determine which dashboard to show
        $role = $user->role?->name;

        // Redirect to appropriate dashboard based on role
        if ($role === 'Admin/Adviser') {
            return redirect('/adviser/dashboard');
        } elseif ($role === 'Ordinary Teacher') {
            return redirect('/teacher/dashboard');
        } else {
            // Student or default
            return Inertia::render('User/Dashboard', [
                'user' => [
                    'id' => $user->id,
                    'name' => $user->name,
                    'email' => $user->email,
                    'phone' => $user->phone,
                    'role' => $user->role?->name,
                    'avatar_url' => $user->avatar_url,
                ],
            ]);
        }
    }

    /**
     * Update user profile
     */
    public function updateProfile(Request $request)
    {
        $user = $request->user();

        if (!$user) {
            return response()->json([
                'success' => false,
                'message' => 'Not authenticated',
            ], 401);
        }

        $validated = $request->validate([
            'name' => ['required', 'string', 'max:255'],
            'email' => ['required', 'email'],
            'phone' => ['nullable', 'string', 'max:20'],
        ]);

        $user->update($validated);

        return response()->json([
            'success' => true,
            'message' => 'Profile updated successfully',
            'user' => [
                'id' => $user->id,
                'name' => $user->name,
                'email' => $user->email,
                'phone' => $user->phone,
                'role' => $user->role ? [
                    'id' => $user->role->id,
                    'name' => $user->role->name,
                ] : null,
                'avatar_url' => $user->avatar_url,
            ],
        ]);
    }

    /**
     * Upload user avatar
     */
    public function uploadAvatar(Request $request)
    {
        $user = $request->user();

        if (!$user) {
            return response()->json([
                'success' => false,
                'message' => 'Not authenticated',
            ], 401);
        }

        $validated = $request->validate([
            'avatar' => ['required', 'image', 'max:2048'],
        ]);

        // Store avatar
        if ($request->hasFile('avatar')) {
            $file = $request->file('avatar');
            $path = $file->store('avatars', 'public');
            $user->update(['avatar_url' => $path]);
        }

        return response()->json([
            'success' => true,
            'message' => 'Avatar uploaded successfully',
            'avatar_url' => $user->avatar_url,
        ]);
    }
}
