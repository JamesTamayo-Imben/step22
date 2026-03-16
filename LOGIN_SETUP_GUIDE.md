# Step2 Database Login Setup Guide

## Overview
The application is now configured to use the **step2 database** for authentication instead of Supabase. Users can login with their step2 database credentials and will be directed to role-based dashboards.

---

## Architecture

### 1. **Frontend (React Login Component)**
- **File**: `resources/js/Pages/Auth/Login.jsx`
- **Endpoint**: POST `/api/login`
- **Features**:
  - Email/password authentication
  - Remember me functionality
  - Error handling with user-friendly messages
  - Stores user info in localStorage
  - Redirects to role-based dashboards

### 2. **Backend (Laravel API Controller)**
- **File**: `app/Http/Controllers/Auth/ApiLoginController.php`
- **Responsibilities**:
  - Validates user input
  - Authenticates against step2 database
  - Checks user account status (active/suspended/archived)
  - Returns JSON response with user role and redirect URL
  - Determines dashboard URL based on user role

### 3. **Database**
- **Database**: `step2`
- **Tables Used**:
  - `users` - User credentials and account info
  - `roles` - User role definitions (Super Admin, Admin/Adviser, CSG Officer, Student, Teacher)
- **Password**: All test passwords are hashed with bcrypt

### 4. **Routes**
- **File**: `routes/auth.php`
- **API Route**: `POST /api/login`
  - Accepts JSON: `{ email: string, password: string }`
  - Returns JSON: `{ success: bool, message: string, user: object, redirect: string }`

---

## Test User Credentials

All test users use password: **`password`**

| Email | Role | Dashboard |
|-------|------|-----------|
| superadmin@kld.edu.ph | Super Admin | /dashboard |
| maria.santos@kld.edu.ph | Admin/Adviser | /dashboard |
| juan.reyes@kld.edu.ph | Admin/Adviser | /dashboard |
| anna.cruz@kld.edu.ph | Admin/Adviser | /dashboard |
| sarah.chen@kld.edu.ph | CSG Officer | /csg/dashboard |
| michael.torres@kld.edu.ph | CSG Officer | /csg/dashboard |
| emma.johnson@kld.edu.ph | Student | /student/dashboard |
| juan.delacruz@kld.edu.ph | Student | /student/dashboard |
| anna.martinez@kld.edu.ph | Student | /student/dashboard |
| carlos.mendoza@kld.edu.ph | Student | /student/dashboard |
| maria.santos.jr@kld.edu.ph | Student | /student/dashboard |
| ramon.garcia@kld.edu.ph | Teacher | /teacher/dashboard |
| lisa.wong@kld.edu.ph | Teacher | /teacher/dashboard |
| daniel.fernandez@kld.edu.ph | Teacher | /teacher/dashboard |

---

## How Authentication Works

### Step-by-Step Flow:

1. **User enters email and password** in Login component
2. **React component sends POST request** to `/api/login` with email and password
3. **ApiLoginController receives request** and validates input
4. **Controller queries step2 database** to find user by email
5. **Password verification** using `Hash::check()` against stored bcrypt hash
6. **Account status check** - ensures user is 'active'
7. **User role loaded** via relationship with roles table
8. **Dashboard URL determined** based on user's role slug:
   - `superadmin` → `/dashboard`
   - `admin` → `/dashboard`
   - `csg` → `/csg/dashboard`
   - `student` → `/student/dashboard`
   - `teacher` → `/teacher/dashboard`
9. **JSON response returned** with:
   - User info (id, name, email, role)
   - Redirect URL
   - Success message
10. **Frontend stores user data** in localStorage
11. **Browser redirects** to appropriate dashboard

### Error Handling:

| Error | HTTP Code | Message |
|-------|-----------|---------|
| Invalid email or password | 401 | "Invalid email or password" |
| Account suspended | 403 | "Your account is suspended. Please contact an administrator." |
| Account archived | 403 | "Your account is archived. Please contact an administrator." |
| Validation errors | 422 | Validation error messages |

---

## Important Files

### Frontend
```
resources/js/Pages/Auth/Login.jsx
├── Handles form submission
├── Makes API request to /api/login
├── Stores user info in localStorage
└── Redirects based on role
```

### Backend
```
app/Http/Controllers/Auth/ApiLoginController.php
├── login() - Authenticates user
├── getUser() - Returns current authenticated user
├── logout() - Logs out user
└── getRedirectUrlByRole() - Determines dashboard URL

routes/auth.php
└── POST /api/login - API endpoint
```

### Database
```
step2 database
├── users table
│   ├── id (primary key)
│   ├── email (unique)
│   ├── password (hashed)
│   ├── role_id (foreign key)
│   ├── status (active/suspended/archived)
│   └── ...other fields
│
└── roles table
    ├── id (primary key)
    ├── name
    ├── slug (superadmin, admin, csg, student, teacher)
    └── ...other fields
```

---

## Switching Between Authentication Methods

### Currently Using: **Step2 Database** ✅

### To Switch to Supabase (When Ready):

1. **In `resources/js/Pages/Auth/Login.jsx`:**
   - Line 17: Uncomment `import { useSupabase } from "../../context/SupabaseContext";`
   - Line 22: Uncomment `const { signIn, signInWithGoogle, ... } = useSupabase();`
   - Lines 81-100: Uncomment Supabase auth block
   - Lines 114-139: Uncomment Google login handler

2. **In `routes/auth.php`:**
   - Comment or remove `Route::post('api/login', [ApiLoginController::class, 'login']);`

3. **Restart your Laravel server:**
   ```bash
   php artisan serve
   ```

---

## Configuration

### Environment Variables
Make sure your `.env` file has:
```env
DB_CONNECTION=mysql
DB_HOST=127.0.0.1
DB_PORT=3306
DB_DATABASE=step2
DB_USERNAME=root
DB_PASSWORD=
```

### CSRF Token
The React component automatically includes the CSRF token from the meta tag:
```jsx
'X-CSRF-TOKEN': document.querySelector('meta[name="csrf-token"]')?.content,
```

Make sure your blade template includes:
```blade
<meta name="csrf-token" content="{{ csrf_token() }}">
```

---

## Testing the Login

### Using cURL:
```bash
curl -X POST http://localhost:8000/api/login \
  -H "Content-Type: application/json" \
  -H "X-CSRF-TOKEN: your_csrf_token" \
  -d '{
    "email": "superadmin@kld.edu.ph",
    "password": "password"
  }'
```

### Expected Response (Success):
```json
{
  "success": true,
  "message": "Login successful",
  "user": {
    "id": 1,
    "name": "Super Admin",
    "email": "superadmin@kld.edu.ph",
    "role": "superadmin",
    "role_name": "Super Admin"
  },
  "redirect": "/dashboard"
}
```

### Expected Response (Failure):
```json
{
  "message": "Invalid email or password"
}
```

---

## Troubleshooting

### "Unexpected token '<', "<!DOCTYPE "..."
This error means the endpoint is returning HTML instead of JSON. Check:
1. ✅ Route is correctly pointing to `ApiLoginController@login`
2. ✅ Controller exists and returns JSON
3. ✅ No syntax errors in controller

### "User not found" or "Invalid password"
Check:
1. ✅ User exists in step2 database
2. ✅ Email is correctly spelled
3. ✅ Password hash is valid (should start with `$2y$`)
4. ✅ User status is 'active'

### "Column not found" errors
Check:
1. ✅ Database tables exist (run migrations if needed)
2. ✅ `users` table has `role_id` column
3. ✅ `roles` table has `slug` column

### Login redirects to wrong dashboard
Check the `getRedirectUrlByRole()` method in `ApiLoginController.php` to ensure routes match your frontend dashboard URLs.

---

## Next Steps

1. **Test login** with provided test credentials
2. **Create role-based dashboards** at the redirect URLs:
   - `/dashboard` for super admin & admins
   - `/csg/dashboard` for CSG officers
   - `/student/dashboard` for students
   - `/teacher/dashboard` for teachers
3. **Implement role-based access control** using middleware
4. **Add user profile** page to display user info from localStorage
5. **When ready**, switch to Supabase following the instructions above

---

## Related Documentation

- Laravel Authentication: https://laravel.com/docs/11.x/authentication
- Laravel Hashing: https://laravel.com/docs/11.x/hashing
- React useState: https://react.dev/reference/react/useState
- Fetch API: https://developer.mozilla.org/en-US/docs/Web/API/Fetch_API

---

**Last Updated**: March 17, 2026
**Status**: ✅ Step2 Database Authentication Active
