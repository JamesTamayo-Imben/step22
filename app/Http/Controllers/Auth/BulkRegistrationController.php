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
     */
    public function registerTeacher(Request $request)
    {
        $validated = $request->validate([
            'firstName' => ['required', 'string', 'max:255'],
            'lastName' => ['required', 'string', 'max:255'],
            'email' => ['required', 'email', Rule::unique('users')],
            'password' => ['required', 'string', 'min:8'],
            'employeeId' => ['required', 'string', 'max:50', Rule::unique('teacher_adviser', 'id')],
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

            // Verify that the employee ID actually exists in the system
            $existingTeacher = Teacher::find($employeeId);
            if (!$existingTeacher) {
                return response()->json([
                    'success' => false,
                    'message' => "Teacher ID '{$employeeId}' does not exist in the system. Contact admin to create this record first.",
                ], 422);
            }

            // Verify the email hasn't already been assigned to this teacher
            if ($existingTeacher->user_id) {
                return response()->json([
                    'success' => false,
                    'message' => "Teacher ID '{$employeeId}' already has a registered user account.",
                ], 422);
            }

            // Get the teacher/professor role
            $role = Role::whereIn('name', ['Ordinary Teacher', 'Admin/Adviser'])->first();

            if (!$role) {
                return response()->json([
                    'success' => false,
                    'message' => 'Teacher role not found',
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

            // Create teacher record
            Teacher::create([
                'id' => $validated['employeeId'],
                'user_id' => $user->id,
                'institute' => $validated['institute'] ?? null,
                'is_adviser' => $role->name === 'Admin/Adviser' ? 1 : 0,
            ]);

            return response()->json([
                'success' => true,
                'message' => 'Teacher registered successfully',
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
     * Register a student with invitation data
     */
    public function registerStudent(Request $request)
    {
        $validated = $request->validate([
            'firstName' => ['required', 'string', 'max:255'],
            'lastName' => ['required', 'string', 'max:255'],
            'email' => ['required', 'email', Rule::unique('users')],
            'password' => ['required', 'string', 'min:8'],
            'studentId' => ['required', 'string', 'max:50', Rule::unique('student_csg_officers', 'id')],
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

            // Verify that the student ID actually exists in the system
            $existingStudent = Student::find($studentId);
            if (!$existingStudent) {
                return response()->json([
                    'success' => false,
                    'message' => "Student ID '{$studentId}' does not exist in the system. Contact admin to create this record first.",
                ], 422);
            }

            // Verify the email hasn't already been assigned to this student
            if ($existingStudent->user_id) {
                return response()->json([
                    'success' => false,
                    'message' => "Student ID '{$studentId}' already has a registered user account.",
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

            // Create student record
            Student::create([
                'id' => $validated['studentId'],
                'user_id' => $user->id,
                'course' => $validated['course'] ?? null,
            ]);

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
