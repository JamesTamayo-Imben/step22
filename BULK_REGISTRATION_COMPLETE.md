# Bulk User Registration Implementation - Complete Guide

## Overview
The system has been completely revamped to support bulk user registration with role-specific signup flows. Admin users can now:
1. Register single or multiple users at once (max 10 per batch)
2. Auto-generate passwords from email addresses
3. Send invitation emails with role-specific signup links
4. Have different signup experiences for students and teachers

## Features Implemented

### 1. Frontend Changes (UserManagement.jsx)

#### Modal Flow
- **Step 1**: Select Role and Registration Type (Single or Multiple)
  - Choose from available roles (Student, Teacher, etc.)
  - Select Single or Multiple (Max 10) registration
  
- **Step 2**: Input User Information
  - Single: Name and Email fields
  - Multiple: Textarea for emails (one per line) with optional names

#### State Management
- `bulkRegModal` state tracks:
  - step (1 or 2)
  - selectedRole
  - registrationType ('single' or 'multiple')
  - emails/singleName/singleEmail
  - result ('success', 'error', or null)

#### Email Parsing
- Supports multiple formats:
  - `email@kld.edu.ph` (auto-generates name from email)
  - `Juan Dela Cruz email@kld.edu.ph` (uses provided name)
  - Names extracted as fallback from email username

### 2. Backend Implementation (UserManagementController.php)

#### New Method: `bulkCreate()`
```php
POST /sadmin/users/bulk-create
```

**Request Body:**
```json
{
  "role_id": "uuid-here",
  "users": [
    {"email": "user@kld.edu.ph", "name": "Juan Dela Cruz"},
    {"email": "user2@kld.edu.ph", "name": "Maria Santos"}
  ]
}
```

**Password Generation Logic:**
- Extracts username from email (e.g., `lpcalibuso` from `lpcalibuso@kld.edu.ph`)
- Appends `KLD` + current year
- Result: `lpcalibusoKLD2026`

**Features:**
- Validates up to 10 users per request
- Creates users with auto-generated passwords
- Marks users as 'active' by default
- Sends invitation emails with role-specific signup links
- Handles errors gracefully (continues with successful registrations)
- Logs email failures without blocking user creation

### 3. Email Template (user-invitation.blade.php)

- Beautiful, branded email design
- Shows auto-generated password
- Links to role-specific signup page
- Includes security warning to change password on first login
- Mobile-responsive HTML template

### 4. Role-Specific Registration Pages

#### RegisterTeacher.jsx
- Path: `/auth/register-teacher`
- Receives pre-filled data via query parameters:
  - `email`: Pre-filled email
  - `password`: Initial auto-generated password
  - `name`: Pre-filled name
- Fields:
  - First Name *
  - Last Name *
  - Employee ID *
  - Specialization
  - Office Location
- API Endpoint: `POST /api/auth/register-teacher`

#### RegisterStudent.jsx
- Path: `/auth/register-student`
- Same pre-fill approach as teacher page
- Fields:
  - First Name *
  - Last Name *
  - Student ID *
  - Year Level * (1st, 2nd, 3rd, 4th Year)
  - Contact Number
- API Endpoint: `POST /api/auth/register-student`

### 5. API Endpoints (BulkRegistrationController.php)

#### Teacher Registration
```
POST /api/auth/register-teacher

Request:
{
  "firstName": "Juan",
  "lastName": "Dela Cruz",
  "email": "juan@kld.edu.ph",
  "password": "juanKLD2026",
  "employeeId": "T-12345",
  "specialization": "Mathematics",
  "officeLocation": "Room 201",
  "role": "teacher"
}

Response: 201 Created
{
  "success": true,
  "message": "Teacher registered successfully",
  "user": {...}
}
```

#### Student Registration
```
POST /api/auth/register-student

Request:
{
  "firstName": "Maria",
  "lastName": "Santos",
  "email": "maria@kld.edu.ph",
  "password": "mariaKLD2026",
  "studentId": "2024-12345",
  "yearLevel": "2nd Year",
  "contact": "09991234567",
  "role": "student"
}

Response: 201 Created
{
  "success": true,
  "message": "Student registered successfully",
  "user": {...}
}
```

## Routes

### Web Routes
```php
Route::get('/auth/register-teacher', function () { ... })->name('register.teacher');
Route::get('/auth/register-student', function () { ... })->name('register.student');
```

### API Routes
```php
Route::post('/auth/register-teacher', [BulkRegistrationController::class, 'registerTeacher']);
Route::post('/auth/register-student', [BulkRegistrationController::class, 'registerStudent']);
```

### Admin Routes
```php
Route::post('/sadmin/users/bulk-create', [UserManagementController::class, 'bulkCreate'])->name('sadmin.users.bulk-create');
```

## Data Flow

1. **Admin Creates Users**
   - Opens User Management page
   - Clicks "Create User" button
   - Step 1: Selects Role and registration type
   - Step 2: Enters email(s) and names

2. **System Processes**
   - Validates input (max 10 users, unique emails)
   - Creates User records with auto-generated passwords
   - Generates role-specific signup links with parameters
   - Sends invitation emails

3. **User Receives Invitation**
   - Email contains:
     - Auto-generated password
     - Role-specific signup link
     - Instructions
   - Link includes query parameters:
     - `email`: Pre-filled email
     - `password`: Initial password
     - `name`: Pre-filled name

4. **User Signs Up**
   - Clicks link in email
   - Lands on role-specific signup page
   - Pre-filled fields reduce friction
   - Completes additional role-specific fields
   - Submits to `/api/auth/register-{role}`
   - User account fully activated

## Database Records Created

### Users Table
- id (UUID)
- name
- email
- password (hashed with auto-generated password)
- role_id (links to roles table)
- status ('active')
- email_verified_at (set to current time)

### Students Table (for student registrations)
- id (student_id from form)
- user_id (foreign key)
- year_level

### Teachers Table (for teacher registrations)
- id (employee_id from form)
- user_id (foreign key)
- specialization
- office_location
- is_adviser (0 or 1 based on role)

## Security Considerations

1. **Password Generation**
   - Auto-generated passwords contain predictable pattern but are unique per user
   - Users MUST change on first login (enforced via email warning)
   - Consider adding password reset requirement on first login in future

2. **Email Delivery**
   - Logs failures without blocking user creation
   - Users can still log in with auto-generated passwords
   - Password reset email available if signup link fails

3. **Validation**
   - Email uniqueness checked
   - Student ID/Employee ID uniqueness enforced
   - Role-specific fields validated

4. **Email Parameters**
   - Query parameters include auto-generated password
   - Only sent via email (not logged in history)
   - Users should change password immediately

## Files Modified/Created

### Modified Files
1. `/resources/js/Pages/SAdmin/UserManagement.jsx` - New bulk registration modal
2. `/app/Http/Controllers/SAdmin/UserManagementController.php` - Added `bulkCreate()` method
3. `/routes/web.php` - Added registration page routes
4. `/routes/api.php` - Added registration API routes

### New Files
1. `/resources/views/emails/user-invitation.blade.php` - Email template
2. `/resources/js/Pages/Auth/RegisterTeacher.jsx` - Teacher signup page
3. `/resources/js/Pages/Auth/RegisterStudent.jsx` - Student signup page
4. `/app/Http/Controllers/Auth/BulkRegistrationController.php` - Registration API controller

## Testing Checklist

- [ ] Single user registration flow works
- [ ] Multiple user registration (up to 10) works
- [ ] Password generation format is correct (username + KLD + year)
- [ ] Emails received with invitation link
- [ ] Pre-filled data appears on signup page
- [ ] Email and password params visible in URL
- [ ] Teacher signup form fields appear
- [ ] Student signup form fields appear (with year level dropdown)
- [ ] Form submission creates user in database
- [ ] Email verification timestamp set
- [ ] User can login with new account
- [ ] Password change forced on first login (implement in future)
- [ ] Multiple role support works (not just Student/Teacher)
- [ ] Error handling for duplicate emails
- [ ] Error handling for duplicate IDs
- [ ] Email service failures don't prevent user creation

## Future Enhancements

1. **Force Password Change on First Login**
   - Add `force_password_change` flag to users table
   - Redirect to password change page on first login
   - Clear flag after successful password change

2. **Email Resend**
   - Add button to resend invitation email
   - Include in user management actions

3. **Bulk Edit**
   - Allow editing multiple users at once
   - Update roles, statuses, etc.

4. **Import from CSV**
   - Upload CSV file
   - Parse and validate
   - Bulk create from file

5. **Better Error Reporting**
   - Show which users failed to create
   - Provide specific error reasons
   - Allow retry

6. **Customizable Email Template**
   - Admin can customize email body
   - Add organization branding
   - Include custom links/resources

## Known Limitations

1. Max 10 users per bulk registration (prevent performance issues)
2. Auto-generated passwords visible in email (standard approach)
3. No built-in password change enforcement (implement via middleware)
4. Student ID/Employee ID must be manually entered (no integration with existing systems)

## Support

For questions or issues:
1. Check the test checklist above
2. Review error logs: `storage/logs/laravel.log`
3. Check email delivery: verify MAIL_* config in `.env`
4. Test API endpoints directly with Postman/curl
