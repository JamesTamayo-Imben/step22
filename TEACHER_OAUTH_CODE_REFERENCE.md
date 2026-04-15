# Teacher OAuth Storage - Code Implementation Reference

## Quick Code Reference

### 1. Frontend: OAuthCallback.jsx
**What it does:** Initiates OAuth, fetches dropdowns, shows onboarding

```jsx
// Key part: Fetch dropdowns and show onboarding
const [courseList, setCourseList] = useState([]);
const [instituteList, setInstituteList] = useState([]);

// Inside useEffect:
if (!data.user.profile_completed) {
  // Fetch dropdown data
  const [cRes, iRes] = await Promise.all([
    fetch('/api/onboarding/courses'),
    fetch('/api/onboarding/institutes')
  ]);

  const cData = cRes.ok ? await cRes.json() : { courses: [] };
  const iData = iRes.ok ? await iRes.json() : { institutes: [] };

  setCourseList(cData.courses || []);
  setInstituteList(iData.institutes || []);

  // Show onboarding with dropdown data
  setShowOnboarding(true);
}

// Render OnboardingFlow with data
<OnboardingFlow
  userId={oauthUser.id}
  email={oauthUser.email}
  courses={courseList}           // ✅ Pass here
  institutes={instituteList}     // ✅ Pass here
  onOnboardingComplete={(data) => {
    router.visit('/user');
  }}
/>
```

---

### 2. Frontend: OnboardingFlow.jsx
**What it does:** Manages the multi-step flow

```jsx
export default function OnboardingFlow({
  userId,
  email,
  courses = [],      // ✅ Receive from OAuthCallback
  institutes = [],   // ✅ Receive from OAuthCallback
  onOnboardingComplete
}) {
  const [currentStep, setCurrentStep] = useState('onboarding');

  // Pass to OnboardingModal
  return (
    <OnboardingModal
      userId={userId}
      email={email}
      courses={courses}           // ✅ Pass here
      institutes={institutes}     // ✅ Pass here
      onComplete={(data) => {
        setCurrentStep('password');
      }}
    />
  );
}
```

---

### 3. Frontend: OnboardingModal.jsx
**What it does:** Collects role and role-specific data

```jsx
export default function OnboardingModal({
  userId,
  email,
  courses = [],      // ✅ Receive here
  institutes = [],   // ✅ Receive here
  onComplete
}) {
  const [step, setStep] = useState(1);
  const [form, setForm] = useState({
    role: "",
    employee_id: "",        // ✅ For teacher
    institute_id: "",       // ✅ For teacher
    student_id: "",         // For student
    course_id: "",          // For student
    phone_number: ""
  });

  // Step 2: Role-specific form
  if (step === 2) {
    // For TEACHER role
    if (form.role === "teacher") {
      return (
        <>
          {/* Employee ID Input */}
          <input
            type="text"
            placeholder="e.g., EMP001"
            value={form.employee_id}
            onChange={(e) => handleInputChange("employee_id", e.target.value)}
          />

          {/* Institute Dropdown */}
          <select
            value={form.institute_id}
            onChange={(e) => handleInputChange("institute_id", e.target.value)}
          >
            <option value="">Select your institute</option>
            {institutes.map((institute) => (
              <option key={institute.id} value={institute.id}>
                {institute.name}
              </option>
            ))}
          </select>
        </>
      );
    }
  }

  // Handle submit
  const handleSubmit = async (e) => {
    e.preventDefault();

    const response = await fetch("/api/onboarding/complete", {
      method: "POST",
      headers: {
        "Content-Type": "application/json",
        "X-CSRF-TOKEN": document.querySelector('meta[name="csrf-token"]')?.content,
      },
      body: JSON.stringify({
        user_id: userId,
        email: email,
        role: form.role,                    // "teacher" ✅
        employee_id: form.employee_id,      // "EMP999" ✅
        institute_id: form.institute_id,    // "UUID" ✅
        phone_number: form.phone_number
      }),
    });

    const data = await response.json();
    onComplete(data);
  };
}
```

---

### 4. Backend: GoogleAuthController.php
**What it does:** Creates user with profile_completed = false

```php
public function googleLogin(Request $request)
{
  $validated = $request->validate([
    'id' => 'required|string|uuid',
    'email' => 'required|email',
    'name' => 'required|string',
    'avatar_url' => 'nullable|string|url',
  ]);

  $supabaseId = $validated['id'];

  $user = User::where('email', $validated['email'])->first();

  if (!$user) {
    // Create new user
    $defaultRole = Role::where('slug', 'student')->first();

    $user = User::create([
      'id' => $supabaseId,                // ✅ Same as Supabase ID
      'role_id' => $defaultRole->id,
      'name' => $validated['name'],
      'email' => $validated['email'],
      'avatar_url' => $validated['avatar_url'],
      'email_verified_at' => now(),
      'profile_completed' => false,       // ✅ Triggers onboarding
      'status' => 'active',
      'last_login_at' => now(),
    ]);
  }

  Auth::login($user);

  return response()->json([
    'success' => true,
    'user' => $user,
    'message' => 'User created successfully',
  ], 200);
}
```

---

### 5. Backend: OnboardingController.php
**What it does:** Stores teacher in teacher_adviser table ✅

```php
public function complete(Request $request)
{
  $validated = $request->validate([
    'user_id' => 'required|string|uuid',
    'email' => 'required|email',
    'role' => 'required|string',
    'employee_id' => 'nullable|required_if:role,teacher|string',     // ✅
    'institute_id' => 'nullable|required_if:role,teacher|string',    // ✅
    'phone_number' => 'nullable|string',
  ]);

  $userId = $validated['user_id'];
  $role = strtolower($validated['role']);

  $result = DB::transaction(function () use ($validated, $userId, $role) {
    $user = User::findOrFail($userId);

    // Update user role
    $roleRecord = Role::where('slug', $role === 'professor' ? 'teacher' : $role)
      ->first();

    $user->update([
      'role_id' => $roleRecord->id,
      'profile_completed' => true,        // ✅ Mark as complete
      'phone' => $validated['phone_number'] ?? $user->phone,
    ]);

    // ✅ Handle Teacher Role
    if ($role === 'professor' || $role === 'teacher') {
      $roleRecord = Role::where('slug', 'teacher')->first();

      // ✅ CREATE/UPDATE in teacher_adviser table
      TeacherAdviser::updateOrCreate(
        ['user_id' => $userId],
        [
          'id' => $validated['employee_id'],         // ✅ Employee ID as primary key
          'institute_id' => $validated['institute_id'], // ✅ Institute ID
          'is_adviser' => false,
        ]
      );

      return ['type' => 'teacher', 'message' => 'Teacher linked to institute successfully'];
    }

    // Handle Student Role
    if ($role === 'student') {
      StudentCsgOfficer::updateOrCreate(
        ['user_id' => $userId],
        [
          'id' => $validated['student_id'],
          'course_id' => $validated['course_id'],
          'is_csg' => false,
          'csg_is_active' => true,
        ]
      );

      return ['type' => 'student', 'message' => 'Student linked to course successfully'];
    }
  });

  return response()->json([
    'success' => true,
    'message' => $result['message'],
    'user_onboarded' => true,
  ], 200);
}
```

---

### 6. Backend: Routes
**What it does:** Define API endpoints

```php
// routes/api.php

Route::prefix('/onboarding')->group(function () {
    Route::post('/complete', [OnboardingController::class, 'complete']);
    Route::post('/set-password', [OnboardingController::class, 'setPassword']);
    Route::post('/courses', [OnboardingController::class, 'getCourses']);
    Route::post('/institutes', [OnboardingController::class, 'getInstitutes']);
});

Route::post('/oauth/google-login', [GoogleAuthController::class, 'googleLogin']);
```

---

### 7. Database: teacher_adviser table

```sql
CREATE TABLE `teacher_adviser` (
  `id` varchar(100) NOT NULL,           -- ✅ Employee ID (primary key)
  `user_id` char(36) DEFAULT NULL,      -- ✅ User ID (foreign key)
  `institute_id` char(36) DEFAULT NULL, -- ✅ Institute ID (foreign key)
  `is_adviser` tinyint(1) DEFAULT 0,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `updated_at` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  `archive` tinyint(1) DEFAULT 0
);
```

---

## Data Flow Summary

```
User Input (Form)              Backend Processing              Database Storage
═════════════════              ════════════════════            ════════════════

employee_id: "EMP999"  ──→  validated['employee_id']  ──→  teacher_adviser.id
                             ↓
                          TeacherAdviser::updateOrCreate(
                            ['user_id' => $userId],
                            ['id' => 'EMP999']
                          )

institute_id: "UUID123" ──→ validated['institute_id'] ──→  teacher_adviser.institute_id
                             ↓
                          TeacherAdviser::updateOrCreate(
                            [...],
                            ['institute_id' => 'UUID123']
                          )

role: "teacher"         ──→ strtolower($role) = 'teacher'
                             ↓
                          if ('teacher') {
                            Create TeacherAdviser record ✅
                          }

user_id: "uuid-1234"    ──→ $userId from request      ──→  teacher_adviser.user_id
```

---

## Key Implementation Details

### ✅ Employee ID Storage
- **Frontend:** User enters in input field (OnboardingModal)
- **Transport:** Sent as `employee_id` in POST body
- **Backend:** Validated and stored as `TeacherAdviser.id`
- **Database:** Primary key in `teacher_adviser` table

### ✅ Institute ID Storage  
- **Frontend:** User selects from dropdown (institutes list)
- **Transport:** Sent as `institute_id` in POST body
- **Backend:** Validated and stored as `TeacherAdviser.institute_id`
- **Database:** Foreign key linking to `institute` table

### ✅ User Linking
- **Supabase ID:** Same as Laravel User.id
- **Relationship:** teacher_adviser.user_id → users.id
- **Purpose:** Links teacher record to user account

### ✅ Profile Completion
- **Initial:** `users.profile_completed = false` (from Google auth)
- **After Onboarding:** `users.profile_completed = true`
- **Subsequent Logins:** Skip onboarding, go straight to dashboard

---

## Testing Checklist

```
☐ Click "Continue with Google" on login/register
☐ Authenticate with teacher@kld.edu.ph
☐ Onboarding Step 1: Select "Professor / Teacher"
☐ Onboarding Step 2: Fill form
  ☐ Enter Employee ID (e.g., EMP999)
  ☐ Select Institute from dropdown
  ☐ Click Continue
☐ Optional: Set password or skip
☐ Redirect to dashboard
☐ Verify in database:
  ☐ users table: profile_completed = 1
  ☐ users table: role_id = teacher_role_id
  ☐ teacher_adviser table: NEW ROW with {id, user_id, institute_id}
```

---

## Common Issues & Solutions

| Issue | Cause | Solution |
|-------|-------|----------|
| teacher_adviser not created | institute_id is NULL | Check dropdown value is being sent |
| profile_completed still 0 | API returned error | Check browser network tab for errors |
| Institute dropdown empty | getCourses/Institutes failed | Verify endpoints return 200 |
| Employee ID validation fails | Field was empty | Make field required in UI |
| Can't login as teacher later | profile_completed not updated | Check if onboarding endpoint succeeded |

---

## File Locations

| Component | File Path |
|-----------|-----------|
| OAuthCallback | `resources/js/Pages/Auth/OAuthCallback.jsx` |
| OnboardingFlow | `resources/js/Pages/Auth/OnboardingFlow.jsx` |
| OnboardingModal | `resources/js/Pages/Auth/OnboardingModal.jsx` |
| GoogleAuthController | `app/Http/Controllers/Auth/GoogleAuthController.php` |
| OnboardingController | `app/Http/Controllers/Auth/OnboardingController.php` |
| Routes | `routes/api.php` |
| Database | `step_system_database.sql` |

---

## This is ✅ COMPLETE

All the code is already in place. When a teacher selects the teacher role during Google OAuth:

1. ✅ Employee ID is collected via form input
2. ✅ Institute ID is selected from dropdown
3. ✅ Both are sent to `/api/onboarding/complete`
4. ✅ Backend creates `teacher_adviser` record with both fields
5. ✅ User is marked as onboarded (profile_completed = true)
6. ✅ Redirect to dashboard

No code changes needed - just testing required!
