# Teacher OAuth Storage - Quick Testing Guide

## Quick Test Flow

### 1. Start Google OAuth Login
```
URL: http://localhost:3000/login (or /register)
Click: "Continue with Google"
```

### 2. Authenticate with Teacher Email
```
Email: teacher@kld.edu.ph
(Any valid KLD email)
```

### 3. Onboarding Step 1: Select Role
```
Click: "Professor / Teacher"
Next: Step 2
```

### 4. Onboarding Step 2: Fill Teacher Information
```
Employee ID: EMP999
Institute: Select any from dropdown (e.g., "ICDI")
Phone (optional): 09123456789
Click: Continue
```

### 5. Verify in Database

**Check users table:**
```sql
SELECT id, email, name, profile_completed, role_id, updated_at 
FROM users 
WHERE email = 'teacher@kld.edu.ph'
ORDER BY created_at DESC 
LIMIT 1;
```

**Expected Output:**
```
id: [UUID]
email: teacher@kld.edu.ph
name: [From Google]
profile_completed: 1  ✅
role_id: [teacher role UUID]
updated_at: [current timestamp]
```

**Check teacher_adviser table:**
```sql
SELECT * 
FROM teacher_adviser 
WHERE id = 'EMP999';
```

**Expected Output:**
```
id: EMP999                          ✅
user_id: [Same UUID as users.id]   ✅
institute_id: [Selected institute] ✅
is_adviser: 0
created_at: [current timestamp]
updated_at: [current timestamp]
```

## Database Queries for Validation

### Quick Verification (All Recent Teachers)
```sql
SELECT 
  u.id,
  u.name,
  u.email,
  u.profile_completed,
  t.id as employee_id,
  t.institute_id,
  t.is_adviser
FROM users u
LEFT JOIN teacher_adviser t ON u.id = t.user_id
WHERE u.created_at > DATE_SUB(NOW(), INTERVAL 1 HOUR)
AND u.role_id = (SELECT id FROM role WHERE slug = 'teacher')
ORDER BY u.created_at DESC;
```

### Check Specific Teacher
```sql
SELECT 
  u.id as user_id,
  u.name,
  u.email,
  t.id as employee_id,
  i.name as institute_name,
  t.institute_id,
  t.is_adviser
FROM users u
JOIN teacher_adviser t ON u.id = t.user_id
JOIN institute i ON t.institute_id = i.id
WHERE u.email = 'teacher@kld.edu.ph';
```

## Network Request Monitoring

### 1. Check OAuthCallback Request
```
POST /api/oauth/google-login
Payload:
{
  "id": "[supabase-uuid]",
  "email": "teacher@kld.edu.ph",
  "name": "[Google Name]",
  "avatar_url": "[url]"
}
Response: 200 ✅
{
  "success": true,
  "user": { ... "profile_completed": false ... }
}
```

### 2. Check Dropdown Fetch
```
GET /api/onboarding/courses
GET /api/onboarding/institutes
Response: 200 ✅
```

### 3. Check Onboarding Submit
```
POST /api/onboarding/complete
Payload:
{
  "user_id": "[uuid]",
  "email": "teacher@kld.edu.ph",
  "role": "teacher",
  "employee_id": "EMP999",
  "institute_id": "[institute-uuid]",
  "phone_number": "09123456789"
}
Response: 200 ✅
{
  "success": true,
  "message": "Teacher linked to institute successfully",
  "user_onboarded": true
}
```

## Browser Console Logs to Check

Open DevTools (F12) → Console tab

### Should see:
```
✅ User created/updated in step2 DB: { ... }
✅ Dropdown data loaded
✅ Onboarding flow completed: { ... }
```

### If teacher role not stored:
```
❌ Check console for errors
❌ Check Network tab for failed requests
❌ Verify institute_id is being sent
```

## Common Issues & Fixes

### Issue: Teacher record not created
**Check:**
1. `institute_id` is not null in request
2. Institute exists in `institute` table
3. No foreign key constraint errors in browser console

### Issue: profile_completed still false
**Check:**
1. `/api/onboarding/complete` returned 200
2. Response shows `"user_onboarded": true`
3. No validation errors in response

### Issue: Employee ID not stored
**Check:**
1. Employee ID field was filled in form
2. Employee ID is unique (not already in teacher_adviser)
3. Backend validation passed

## Files to Review if Issues Occur

| File | Purpose |
|------|---------|
| `resources/js/Pages/Auth/OAuthCallback.jsx` | Lines 45-105: Google OAuth handling |
| `resources/js/Pages/Auth/OnboardingModal.jsx` | Lines 109-130: Form submission |
| `app/Http/Controllers/Auth/OnboardingController.php` | Lines 290-330: Teacher storage |
| Browser Network Tab | POST requests should be 200 |
| Laravel Logs | `storage/logs/laravel.log` |

## Success Criteria ✅

- [ ] Teacher selects teacher role in onboarding
- [ ] Employee ID input field visible
- [ ] Institute dropdown populated and functional
- [ ] Form submission succeeds (200 response)
- [ ] `teacher_adviser` table has new row with:
  - [ ] `id` = entered employee_id
  - [ ] `user_id` = user's UUID
  - [ ] `institute_id` = selected institute
- [ ] Redirect to dashboard occurs
- [ ] Subsequent login skips onboarding

## For Login Page Testing

Same flow works on login page:
```
URL: http://localhost:8000/login
Click: "Continue with Google"
(First-time user triggers onboarding)
(Returning user goes directly to dashboard)
```

For Register Page Testing:
```
URL: http://localhost:8000/register
Click: "Continue with Google"
(Same flow as login)
```
