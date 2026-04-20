<?php

namespace App\Http\Controllers\Auth;

use App\Http\Controllers\Controller;
use App\Models\User;
use App\Models\Student;
use App\Models\Teacher;
use App\Models\Role;
use Illuminate\Http\Request;
use Illuminate\Validation\Rule;
use Illuminate\Support\Str;
use Illuminate\Support\Facades\Http;
use Illuminate\Support\Facades\Log;

class BulkRegistrationController extends Controller
{
    /**
     * Register a teacher with invitation data
     * If the teacher already has a existing user record created by superadmin, complete registration using token
     */
    public function registerTeacher(Request $request)
    {
        // Check if this is an invited teacher using a token
        $invitationToken = $request->input('invitation_token');
        
        if ($invitationToken) {
            return $this->completeTeacherRegistration($request, $invitationToken);
        }

        // Standard registration (no token)
        return $this->createNewTeacher($request);
    }

    /**
     * Complete teacher registration using invitation token
     * Updates existing user record created by superadmin
     */
    private function completeTeacherRegistration(Request $request, string $invitationToken)
    {
        // Validate only password and phone for invited registration
        try {
            $validated = $request->validate([
                'password' => ['required', 'string', 'min:8'],
                'phone' => ['nullable', 'string', 'max:20'],
            ]);
        } catch (\Illuminate\Validation\ValidationException $e) {
            return response()->json([
                'success' => false,
                'message' => 'Validation failed',
                'errors' => $e->errors(),
            ], 422);
        }

        try {
            // Find user by valid invitation token
            $user = User::findByValidToken($invitationToken);

            if (!$user) {
                return response()->json([
                    'success' => false,
                    'message' => 'Invalid or expired invitation link. Please contact admin to request a new link.',
                ], 401);
            }

            // Verify user is a teacher
            if (!$user->hasAnyRole(['Ordinary Teacher', 'Admin/Adviser'])) {
                return response()->json([
                    'success' => false,
                    'message' => 'This invitation link is not for a teacher account.',
                ], 422);
            }

            // Update user's password and phone
            $user->update([
                'password' => bcrypt($validated['password']),
                'phone' => $validated['phone'] ?? $user->phone,
                'email_verified_at' => now(),
            ]);

            // Mark token as expired (can't be used again)
            $user->markTokenAsExpired();

            // NOTE: Do NOT create Supabase Auth user here!
            // User was already created in Supabase by the admin when sending the invitation.
            // Only update the password in local database (Supabase auth is handled separately by admin)

            return response()->json([
                'success' => true,
                'message' => 'Registration completed successfully',
                'user' => [
                    'id' => $user->id,
                    'name' => $user->name,
                    'email' => $user->email,
                    'role' => $user->role->name,
                ],
            ], 200);

        } catch (\Exception $e) {
            return response()->json([
                'success' => false,
                'message' => 'Registration failed: ' . $e->getMessage(),
            ], 500);
        }
    }

    /**
     * Create a new teacher account (standard registration without token)
     * If teacher was pre-created by admin, this updates the existing record
     */
    private function createNewTeacher(Request $request)
    {
        // First validate without the unique email constraint
        $validated = $request->validate([
            'firstName' => ['required', 'string', 'max:255'],
            'lastName' => ['required', 'string', 'max:255'],
            'email' => ['required', 'email'],
            'password' => ['required', 'string', 'min:8'],
            'employeeId' => ['required', 'string', 'max:50'],
            'institute' => ['nullable', 'string', 'max:255'],
            'phone' => ['nullable', 'string', 'max:20'],
            'role' => ['required', 'in:teacher,professor'],
        ]);

        try {
            $email = $validated['email'];
            $employeeId = $validated['employeeId'];

            // Validate email domain - exact match only
            $domain = strtolower(explode('@', $email)[1] ?? '');
            $validDomains = ['kld.edu.ph','gmail.com', 'kld.com.ph', 'step.edu.ph'];
            
            if (!in_array($domain, $validDomains, true)) {
                return response()->json([
                    'success' => false,
                    'message' => "Email must use institutional domain (kld.edu.ph, kld.com.ph, or step.edu.ph): {$email}",
                ], 422);
            }

            // Check if email is already registered to ANY user
            $existingUser = User::where('email', $email)->first();
            
            // Determine the role based on the requested registration type
            $roleName = $validated['role'] === 'teacher' ? 'Ordinary Teacher' : 'Admin/Adviser';
            $role = Role::where('name', $roleName)->first();

            if (!$role) {
                return response()->json([
                    'success' => false,
                    'message' => "Role '{$roleName}' not found",
                ], 422);
            }

            // Check if employee ID is already registered (has user_id)
            $existingTeacher = Teacher::find($employeeId);
            if ($existingTeacher && $existingTeacher->user_id) {
                return response()->json([
                    'success' => false,
                    'message' => "Teacher ID '{$employeeId}' already has a registered user account.",
                ], 422);
            }

            // If email exists, update that user record; otherwise create new user
            if ($existingUser) {
                // Email exists - update the existing user record
                $existingUser->update([
                    'name' => $validated['firstName'] . ' ' . $validated['lastName'],
                    'password' => bcrypt($validated['password']),
                    'role_id' => $validated['role'] === 'teacher' ? Role::where('name', 'Ordinary Teacher')->first()->id : Role::where('name', 'Admin/Adviser')->first()->id,
                    // 'role_id' => $role->id,
                    'status' => 'active',
                    'phone' => $validated['phone'] ?? $existingUser->phone,
                    'email_verified_at' => now(),
                ]);
                $user = $existingUser;
            } else {
                // Email doesn't exist - create new user
                // Create user in Supabase Auth first
                $this->createSupabaseAuthUser(
                    $validated['email'],
                    $validated['password'],
                    $validated['firstName'],
                    $validated['lastName']
                );

                // Create user in local database
                $user = User::create([
                    'id' => Str::uuid(),
                    'name' => $validated['firstName'] . ' ' . $validated['lastName'],
                    'email' => $validated['email'],
                    'password' => bcrypt($validated['password']),
                    'role_id' => $role->id,
                    'status' => 'active',
                    'phone' => $validated['phone'] ?? null,
                    'email_verified_at' => now(),
                ]);
            }

            // Create or update teacher record with user_id and institute_id
            // Employee ID (id field) is NOT hashed - kept as plain string/varchar
            $teacher = Teacher::updateOrCreate(
                ['id' => $employeeId],                              // Find by Employee ID
                [
                    'user_id' => $user->id,                         // Link to user
                    'institute_id' => $validated['institute'] ?? null,  // Institute reference
                    'is_adviser' => $role->name === 'Admin/Adviser' ? 1 : 0,  // Set adviser flag
                    'archive' => 0,                                 // Mark as not archived
                ]
            );

            return response()->json([
                'success' => true,
                'message' => 'Teacher registered successfully',
                'user' => [
                    'id' => $user->id,
                    'name' => $user->name,
                    'email' => $user->email,
                    'role' => $role->name,
                ],
                'teacher' => [
                    'employeeId' => $teacher->id,      // Plain text, NOT hashed
                    'instituteId' => $teacher->institute_id,
                    'isAdviser' => $teacher->is_adviser,
                ],
            ], 201);

        } catch (\Exception $e) {
            return response()->json([
                'success' => false,
                'message' => 'Registration failed: ' . $e->getMessage(),
            ], 500);
        }
    }

    /**
     * Register a student with invitation data
     * Students can self-register - student record is created if it doesn't exist
     */
    public function registerStudent(Request $request)
    {
        $validated = $request->validate([
            'firstName' => ['required', 'string', 'max:255'],
            'lastName' => ['required', 'string', 'max:255'],
            'email' => ['required', 'email', Rule::unique('users')],
            'password' => ['required', 'string', 'min:8'],
            'studentId' => ['required', 'string', 'max:50'],
            'course' => ['nullable', 'string', 'max:255'],
            'phone' => ['nullable', 'string', 'max:20'],
            'role' => ['required', 'in:student'],
        ]);

        try {
            $email = $validated['email'];
            $studentId = $validated['studentId'];

            // Validate email domain - exact match only
            $domain = strtolower(explode('@', $email)[1] ?? '');
            $validDomains = ['kld.edu.ph','gmail.com', 'kld.com.ph', 'step.edu.ph'];
            
            if (!in_array($domain, $validDomains, true)) {
                return response()->json([
                    'success' => false,
                    'message' => "Email must use institutional domain (kld.edu.ph, kld.com.ph, or step.edu.ph): {$email}",
                ], 422);
            }

            // Check if student ID already has a registered user account
            $existingStudent = Student::find($studentId);
            if ($existingStudent && $existingStudent->user_id) {
                return response()->json([
                    'success' => false,
                    'message' => "Student ID '{$studentId}' already has a registered user account.",
                ], 422);
            }

            // Check if email is already registered
            $existingUser = User::where('email', $email)->first();
            if ($existingUser) {
                return response()->json([
                    'success' => false,
                    'message' => "Email '{$email}' is already registered.",
                ], 422);
            }

            // Get the student role
            $role = Role::where('name', 'Student')->first();

            if (!$role) {
                return response()->json([
                    'success' => false,
                    'message' => 'Student role not found',
                ], 422);
            }

            // Create user in Supabase Auth first
            $this->createSupabaseAuthUser(
                $validated['email'],
                $validated['password'],
                $validated['firstName'],
                $validated['lastName']
            );

            // Create user in local database
            $user = User::create([
                'id' => Str::uuid(),
                'name' => $validated['firstName'] . ' ' . $validated['lastName'],
                'email' => $validated['email'],
                'password' => bcrypt($validated['password']),
                'role_id' => $role->id,
                'status' => 'active',
                'phone' => $validated['phone'] ?? null,
                'email_verified_at' => now(),
            ]);

            // Create or update student record
            Student::updateOrCreate(
                ['id' => $studentId],
                [
                    'user_id' => $user->id,
                    'is_csg' => 0,
                ]
            );

            return response()->json([
                'success' => true,
                'message' => 'Student registered successfully',
                'user' => [
                    'id' => $user->id,
                    'name' => $user->name,
                    'email' => $user->email,
                    'role' => $role->name,
                ],
            ], 201);

        } catch (\Exception $e) {
            return response()->json([
                'success' => false,
                'message' => 'Registration failed: ' . $e->getMessage(),
            ], 500);
        }
    }

    /**
     * Create user in Supabase Auth (Backend - Server-side)
     * Using Service Role Key for secure backend user creation
     */
    private function createSupabaseAuthUser($email, $password, $firstName, $lastName)
    {
        try {
            $supabaseUrl = env('VITE_SUPABASE_URL');
            $serviceRoleKey = env('SUPABASE_SERVICE_ROLE_KEY');

            if (!$supabaseUrl || !$serviceRoleKey) {
                // Silently skip if Supabase not configured
                return;
            }

            $response = Http::withHeaders([
                'Authorization' => 'Bearer ' . $serviceRoleKey,
                'Content-Type' => 'application/json',
                'apikey' => $serviceRoleKey,
            ])->post($supabaseUrl . '/auth/v1/admin/users', [
                'email' => $email,
                'password' => $password,
                'email_confirm' => true,
                'user_metadata' => [
                    'firstName' => $firstName,
                    'lastName' => $lastName,
                    'full_name' => "$firstName $lastName",
                    'display_name' => "$firstName $lastName",
                ],
            ]);

            if ($response->failed()) {
                // Log error but don't throw - Supabase is non-critical
                \Illuminate\Support\Facades\Log::warning('Failed to create Supabase Auth user', [
                    'email' => $email,
                    'status' => $response->status(),
                ]);
                return;
            }

        } catch (\Exception $e) {
            // Log exception but don't throw - Supabase is non-critical
            \Illuminate\Support\Facades\Log::warning('Exception creating Supabase Auth user', [
                'email' => $email,
                'error' => $e->getMessage(),
            ]);
        }
    }
}
