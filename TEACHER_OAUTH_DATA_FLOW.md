# Teacher OAuth Storage - Data Flow Diagram

## End-to-End Data Flow

```
┌──────────────────────────────────────────────────────────────────────────────┐
│                     TEACHER GOOGLE OAUTH REGISTRATION FLOW                   │
└──────────────────────────────────────────────────────────────────────────────┘

FRONTEND (React)                          BACKEND (Laravel)              DATABASE
════════════════════════════════════════════════════════════════════════════════

1. USER CLICKS "CONTINUE WITH GOOGLE"
   ↓
   [OAuthCallback.jsx]
   Shows loading state
   ↓
   └─→ Authenticates with Google
       └─→ Receives Supabase user:
           {
             id: "uuid-1234...",
             email: "teacher@kld.edu.ph",
             name: "John Doe",
             avatar_url: "..."
           }


2. OAUTH CALLBACK PROCESSES
   ↓
   POST /api/oauth/google-login
   ├─ Body: {id, email, name, avatar_url}
   │
   └─────────────────────────────────→  [GoogleAuthController.php]
                                        googleLogin()
                                        ├─ Find or create user
                                        ├─ Set profile_completed = false
                                        └─ Return user data
                                                   ↓
                                                  DATABASE
                                        ┌──────────────────────┐
                                        │  INSERT INTO users   │
                                        │  ├─ id: uuid-1234    │
                                        │  ├─ email: teacher@  │
                                        │  ├─ name: John Doe   │
                                        │  ├─ role_id: student │
                                        │  │  (default)        │
                                        │  └─ profile_           │
                                        │    completed: 0      │
                                        └──────────────────────┘


3. FETCH DROPDOWN DATA
   ↓
   [OAuthCallback.jsx continues...]
   ├─ GET /api/onboarding/courses
   ├─ GET /api/onboarding/institutes
   └─ Store in state:
      ├─ courseList = [{id, name}, ...]
      └─ instituteList = [{id, name}, ...]


4. SHOW ONBOARDING MODAL
   ↓
   [OnboardingFlow.jsx]
   ├─ Pass courses & institutes as props
   └─ Show [OnboardingModal.jsx]


5. STEP 1: ROLE SELECTION
   ↓
   User clicks: "Professor / Teacher"
   ↓
   [OnboardingModal.jsx]
   ├─ setForm({role: "teacher", ...})
   └─ Move to Step 2


6. STEP 2: FILL TEACHER FORM
   ↓
   [OnboardingModal.jsx displays]
   ├─ Input: Employee ID
   │  └─ User types: "EMP999"
   │
   ├─ Select: Institute
   │  └─ User selects: "ICDI"
   │     └─ value = "059bab0d-235d..."
   │
   └─ Input: Phone (optional)


7. USER SUBMITS FORM
   ↓
   [OnboardingModal.jsx handleSubmit()]
   ├─ Validate all fields
   ├─ Create request body:
   │  {
   │    user_id: "uuid-1234",
   │    email: "teacher@kld.edu.ph",
   │    role: "teacher",              ✅
   │    employee_id: "EMP999",        ✅
   │    institute_id: "059bab0d...",  ✅
   │    phone_number: "09123456789"
   │  }
   │
   └─→ POST /api/onboarding/complete
           ↓
           └─────────────────────────→ [OnboardingController.php]
                                      complete()
                                      ├─ Validate request
                                      ├─ Find user by ID
                                      │
                                      ├─ DB::transaction() {
                                      │   // Step A: Update user
                                      │   user.update({
                                      │     role_id: teacher_role_id,
                                      │     profile_completed: true ✅
                                      │   })
                                      │
                                      │   // Step C: Teacher case
                                      │   if (role === 'teacher') {
                                      │     TeacherAdviser::updateOrCreate(
                                      │       ['user_id' => $userId],
                                      │       [
                                      │         'id' => 'EMP999',    ✅
                                      │         'institute_id' =>
                                      │           '059bab0d...',    ✅
                                      │         'is_adviser' => false
                                      │       ]
                                      │     )
                                      │   }
                                      │ }
                                      │
                                      └─ Return response:
                                         {
                                           success: true,
                                           message: "Teacher linked..."
                                         }


8. DATABASE UPDATES
                                                   ↓
                                        ┌──────────────────────┐
                                        │  UPDATE users        │
                                        │  SET:                │
                                        │  ├─ role_id: [UUID]  │
                                        │  │  (teacher role)   │
                                        │  ├─ profile_         │
                                        │  │  completed: 1 ✅  │
                                        │  WHERE id = uuid..   │
                                        └──────────────────────┘
                                        ┌──────────────────────────┐
                                        │  INSERT INTO            │
                                        │  teacher_adviser        │
                                        │  VALUES (               │
                                        │  ├─ id: EMP999       ✅ │
                                        │  ├─ user_id: uuid..  ✅ │
                                        │  ├─ institute_id:    ✅ │
                                        │  │  059bab0d...       │
                                        │  ├─ is_adviser: 0    │
                                        │  ├─ created_at: now()│
                                        │  ├─ updated_at: now()│
                                        │  └─ archive: 0       │
                                        │  )                    │
                                        └──────────────────────────┘


9. RESPONSE TO FRONTEND
   ←──────────────────────────────────┐
                                      │
   Response: {success: true, ...}      │
   ↓
   [OnboardingModal.jsx]
   ├─ onComplete callback triggered
   └─ State: currentStep = 'password'


10. OPTIONAL: SET PASSWORD
    ↓
    [SetPasswordModal.jsx]
    ├─ User can skip or set password
    └─ POST /api/onboarding/set-password


11. REDIRECT TO DASHBOARD
    ↓
    router.visit('/user')
    ↓
    Dashboard loads
    ✅ User is authenticated as teacher


════════════════════════════════════════════════════════════════════════════════

FINAL DATABASE STATE:

┌─────────────────────────────────────────────────────────────────┐
│ USERS TABLE                                                      │
├─────────────────────────────────────────────────────────────────┤
│ id              | uuid-1234...                                  │
│ email           | teacher@kld.edu.ph                            │
│ name            | John Doe                                      │
│ role_id         | [teacher_role_uuid] ✅                        │
│ profile_completed| 1 ✅                                         │
│ avatar_url      | https://...                                   │
│ created_at      | 2026-04-14 12:00:00                          │
│ updated_at      | 2026-04-14 12:05:00                          │
└─────────────────────────────────────────────────────────────────┘

┌──────────────────────────────────────────────────────────────────┐
│ TEACHER_ADVISER TABLE                                            │
├──────────────────────────────────────────────────────────────────┤
│ id              | EMP999 ✅ (employee_id)                       │
│ user_id         | uuid-1234... ✅ (linked to users)            │
│ institute_id    | 059bab0d-235d... ✅ (linked to institute)    │
│ is_adviser      | 0                                             │
│ created_at      | 2026-04-14 12:00:00                          │
│ updated_at      | 2026-04-14 12:00:00                          │
│ archive         | 0                                             │
└──────────────────────────────────────────────────────────────────┘

┌──────────────────────────────────────────────────────────────────┐
│ INSTITUTE TABLE                                                  │
├──────────────────────────────────────────────────────────────────┤
│ id              | 059bab0d-235d... (teacher's institute)       │
│ name            | ICDI                                          │
│ created_at      | 2026-03-19 06:29:42                          │
└──────────────────────────────────────────────────────────────────┘

════════════════════════════════════════════════════════════════════════════════

KEY POINTS:

✅ Employee ID (EMP999) → Stored in teacher_adviser.id
✅ Institute ID → Stored in teacher_adviser.institute_id
✅ User ID → Links teacher_adviser to users table
✅ Profile Completed → Set to TRUE after onboarding
✅ Role → Updated to TEACHER role in users table
✅ Both login & register use same flow
✅ Returning teachers skip onboarding (profile_completed = true)

════════════════════════════════════════════════════════════════════════════════
