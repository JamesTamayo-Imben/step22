# 🔐 Password Reset Feature Documentation

## Overview

The STEP platform now includes a comprehensive 3-step OTP-based password reset system that allows users to securely reset their forgotten passwords.

## Flow Diagram

```
┌─────────────────────────────────────────────────────────────────┐
│                    User Forgot Password                          │
└─────────────────┬───────────────────────────────────────────────┘
                  │
                  ▼
        ┌─────────────────────┐
        │  STEP 1: SEND OTP   │
        │                     │
        │ User enters email   │
        │ ↓                   │
        │ Backend sends OTP   │
        │ to their inbox      │
        └─────────┬───────────┘
                  │
                  ▼
        ┌─────────────────────┐
        │ STEP 2: VERIFY OTP  │
        │                     │
        │ User enters 6-digit │
        │ code from email     │
        │ ↓                   │
        │ Backend verifies    │
        │ OTP matches        │
        └─────────┬───────────┘
                  │
                  ▼
        ┌─────────────────────┐
        │ STEP 3: NEW PASSWORD│
        │                     │
        │ User enters new     │
        │ password (min 8 ch) │
        │ ↓                   │
        │ Backend hashes &    │
        │ stores in database  │
        └─────────┬───────────┘
                  │
                  ▼
        ┌─────────────────────┐
        │   SUCCESS! ✅       │
        │ Redirect to login   │
        └─────────────────────┘
```

## Frontend Implementation

### File: `resources/js/Pages/Auth/ForgotPassword.jsx`

**Features:**
- Multi-step form with progress indicator
- Three distinct UI states (Email → OTP → Password)
- Real-time validation and error handling
- Resend OTP functionality with 60-second cooldown
- Back button to navigate between steps
- Eye icon toggle for password visibility
- Responsive design with mobile support

**State Management:**
```javascript
// Current step (1, 2, or 3)
const [step, setStep] = useState(1);

// User email (persistent across steps)
const [email, setEmail] = useState('');

// Step 1 errors
const [error, setError] = useState('');

// Step 2: OTP input and errors
const [otp, setOtp] = useState('');
const [otpError, setOtpError] = useState('');
const [resendCooldown, setResendCooldown] = useState(0);

// Step 3: New password and errors
const [newPassword, setNewPassword] = useState('');
const [confirmPassword, setConfirmPassword] = useState('');
const [showPassword, setShowPassword] = useState(false);
const [passwordError, setPasswordError] = useState('');
```

### Step 1: Send OTP

**User Input:**
- Email address field

**API Call:**
```javascript
POST /api/password-reset/send-otp
Body: { email: "user@kld.edu.ph" }
```

**Validation:**
- Email is required
- Email format validation (done by backend)

**Success Flow:**
- OTP sent to email
- Display success message
- Proceed to Step 2

### Step 2: Verify OTP

**User Input:**
- 6 individual digit fields (auto-advances to next field)

**API Call:**
```javascript
POST /api/password-reset/verify-otp
Body: { email: "user@kld.edu.ph", otp: "123456" }
```

**Features:**
- Auto-focus to next field when digit entered
- Resend button with 60-second cooldown
- Shows seconds remaining before resend available
- Back button to return to email step

**Success Flow:**
- OTP verified
- Display success message
- Proceed to Step 3

### Step 3: Set New Password

**User Input:**
- New password field (with visibility toggle)
- Confirm password field (with visibility toggle)

**API Call:**
```javascript
POST /api/password-reset/reset
Body: {
  email: "user@kld.edu.ph",
  otp: "123456",
  password: "newpassword123"
}
```

**Validation:**
- Both password fields required
- Minimum 8 characters
- Passwords must match
- Password confirmation included in request

**Success Flow:**
- Password successfully reset
- Display success message
- Redirect to login page after 2 seconds

## Backend Implementation

### File: `app/Http/Controllers/Auth/PasswordResetController.php`

#### Method 1: `sendOTP(Request $request)`

**Purpose:** Generate and send OTP to user's email

**Request:**
```json
{
  "email": "user@kld.edu.ph"
}
```

**Process:**
1. Validate email format
2. Check if user exists with that email
3. Generate random 6-digit OTP
4. Store OTP in cache with key `password_reset_otp_{email}` for 10 minutes
5. Send OTP via email using `OTPMail` class
6. Log the event

**Response (Success):**
```json
{
  "success": true,
  "message": "OTP sent to your email"
}
```

**Response (User not found):**
```json
{
  "success": true,
  "message": "If the email exists, an OTP has been sent"
}
```
*Note: Returns success even if email doesn't exist (security best practice - prevents email enumeration)*

**Cache Storage:**
```php
Cache::put("password_reset_otp_{$email}", [
    'otp' => '123456',
    'user_id' => 'uuid-here',
    'created_at' => now(),
], now()->addMinutes(10));
```

---

#### Method 2: `verifyOTP(Request $request)`

**Purpose:** Verify OTP entered by user

**Request:**
```json
{
  "email": "user@kld.edu.ph",
  "otp": "123456"
}
```

**Process:**
1. Validate email and OTP (must be 6 digits)
2. Retrieve OTP from cache
3. Check if OTP exists (not expired)
4. Compare OTP from request with cached OTP
5. If match, generate verification token
6. Store verification token in cache for 15 minutes
7. Log the event

**Response (Success):**
```json
{
  "success": true,
  "message": "OTP verified successfully",
  "verification_token": "binary-token"
}
```

**Response (OTP Not Found):**
```json
{
  "success": false,
  "message": "OTP expired. Please request a new one.",
  "status": 400
}
```

**Response (Invalid OTP):**
```json
{
  "success": false,
  "message": "Invalid OTP code. Please try again.",
  "status": 400
}
```

**Cache Storage:**
```php
Cache::put("password_reset_verified_{$email}", [
    'token' => 'verification-token',
    'otp' => '123456',
    'user_id' => 'uuid-here',
    'verified_at' => now(),
], now()->addMinutes(15));
```

---

#### Method 3: `resetPassword(Request $request)`

**Purpose:** Reset user password after OTP verification

**Request:**
```json
{
  "email": "user@kld.edu.ph",
  "otp": "123456",
  "password": "newpassword123",
  "password_confirmation": "newpassword123"
}
```

**Process:**
1. Validate email, OTP, and password (min 8 chars, confirmed)
2. Retrieve verification data from cache
3. Check if verification exists (not expired)
4. Double-check OTP matches verification data
5. Find user in database
6. Hash new password and update user record
7. Clear OTP and verification caches
8. Log the event
9. Return success response

**Response (Success):**
```json
{
  "success": true,
  "message": "Password reset successfully. Please log in with your new password."
}
```

**Response (Verification Expired):**
```json
{
  "success": false,
  "message": "Verification expired. Please start over.",
  "status": 400
}
```

**Response (Validation Error):**
```json
{
  "success": false,
  "message": "Validation error",
  "errors": {
    "password": ["The password must be at least 8 characters."]
  },
  "status": 422
}
```

**Password Update:**
```php
$user->update([
    'password' => Hash::make($password),
]);
```

---

## API Routes

### File: `routes/api.php`

```php
Route::prefix('password-reset')->group(function () {
    Route::post('/send-otp', [PasswordResetController::class, 'sendOTP']);
    Route::post('/verify-otp', [PasswordResetController::class, 'verifyOTP']);
    Route::post('/reset', [PasswordResetController::class, 'resetPassword']);
});
```

**Endpoints:**
- `POST /api/password-reset/send-otp` - Send OTP to email
- `POST /api/password-reset/verify-otp` - Verify OTP code
- `POST /api/password-reset/reset` - Reset password

---

## Security Features

### 1. **OTP Security**
- Random 6-digit code (0-999999)
- Stored in Laravel Cache (in-memory, not database)
- Expires after 10 minutes
- Different key per email address

### 2. **Verification Token**
- Generated using `bin2hex(random_bytes(32))` (cryptographically secure)
- Separate from OTP to prevent token reuse
- Stored only during password reset process
- Expires after 15 minutes

### 3. **Password Security**
- Minimum 8 characters enforced
- Hashed using bcrypt (via `Hash::make()`)
- Confirmation field to prevent typos
- Eye icon allows user to verify password

### 4. **Email Enumeration Prevention**
- Returns success even if email doesn't exist
- Prevents attackers from discovering registered emails
- Real failure only visible to legitimate users

### 5. **Rate Limiting** (future enhancement)
- Can add rate limiting middleware to prevent brute force
- Throttle OTP generation: max 5 requests per hour per email
- Throttle OTP verification: max 10 attempts per 15 minutes

### 6. **Logging & Audit Trail**
```php
Log::info('✅ Password reset OTP sent', [
    'email' => $email,
    'user_id' => $user->id,
]);

Log::info('✅ OTP verified successfully', ['email' => $email]);

Log::info('✅ Password reset successfully', [
    'user_id' => $user->id,
    'email' => $email,
]);
```

---

## Email Template

### File: `resources/views/emails/otp.blade.php`

Uses existing OTP email template with:
- User's name greeting
- 6-digit OTP code in prominent box
- Expiration time (10 minutes)
- Security warning
- No reply notice

**Subject:** "STEP Platform - Email Verification Code"

---

## Cache Duration Reference

| Item | Duration | Purpose |
|------|----------|---------|
| `password_reset_otp_{email}` | 10 minutes | OTP validity period |
| `password_reset_verified_{email}` | 15 minutes | Verification token validity |

---

## User Experience Flow

### Desktop View
```
Step 1                Step 2                Step 3
─────────────         ─────────────         ─────────────
┌─────────────┐       ┌─────────────┐       ┌─────────────┐
│   LOGO      │       │   LOGO      │       │   LOGO      │
├─────────────┤       ├─────────────┤       ├─────────────┤
│ Reset Pass? │       │Verify Email?│       │New Password?│
│             │       │             │       │             │
│ Email field │ ─────▶│ OTP fields  │ ─────▶│ Pass fields │
│ [Send OTP]  │       │ [Verify]    │       │ [Reset]     │
└─────────────┘       └─────────────┘       └─────────────┘
     ▲                      ▲                      ▲
     └─ Back to login       └─ Back button         └─ Redirects to login
```

### Mobile View
- Full-width forms
- Stacked elements for small screens
- Touch-friendly button sizes
- Readable font sizes

---

## Testing the Feature

### Manual Testing Steps

**Test Case 1: Happy Path**
1. Click "Forgot Password" link on login page
2. Enter valid email: `student@kld.edu.ph`
3. Check email for OTP code
4. Enter OTP in verification form
5. Set new password (min 8 characters)
6. Confirm password matches
7. Click "Reset Password"
8. See success message and redirect to login
9. Login with new password

**Test Case 2: Invalid Email**
1. Enter non-existent email: `nobody@kld.edu.ph`
2. Should see: "If the email exists, an OTP has been sent"
3. Confirm no email received (doesn't exist)

**Test Case 3: Expired OTP**
1. Request OTP
2. Wait 11+ minutes
3. Try to verify OTP
4. Should see: "OTP expired. Please request a new one."

**Test Case 4: Wrong OTP**
1. Request OTP
2. Enter wrong code (e.g., 000000)
3. Should see: "Invalid OTP code. Please try again."

**Test Case 5: Password Mismatch**
1. Complete OTP verification
2. Enter different passwords in confirmation
3. Should see: "Passwords do not match"

**Test Case 6: Weak Password**
1. Complete OTP verification
2. Enter password with < 8 characters
3. Should see: "Password must be at least 8 characters long"

---

## Browser Compatibility

- ✅ Chrome/Edge 90+
- ✅ Firefox 88+
- ✅ Safari 14+
- ✅ Mobile browsers (iOS Safari, Chrome Mobile)

---

## Future Enhancements

1. **Rate Limiting**
   - Prevent brute force attacks
   - Limit OTP requests per email per hour

2. **Email Template Enhancement**
   - Add OTP code display in email
   - Add action button to auto-fill code

3. **Two-Factor Authentication**
   - Optional SMS OTP as alternative
   - Recovery codes for backup access

4. **Session Management**
   - Auto-logout after password reset
   - Force user to re-authenticate

5. **Security Alerts**
   - Send email notification when password changed
   - Include device/location information

6. **Password Strength Meter**
   - Real-time feedback on password strength
   - Suggest stronger passwords

---

## Troubleshooting

### Issue: OTP email not received
**Solutions:**
1. Check spam/junk folder
2. Verify email configuration in `.env`
3. Check Laravel logs: `storage/logs/laravel.log`
4. Click "Resend Code" button (60-second cooldown)

### Issue: OTP expired
**Solutions:**
1. Request new OTP using "Resend Code"
2. Complete reset within 10 minutes of OTP generation

### Issue: Cannot reset password
**Solutions:**
1. Ensure email exists in system
2. Verify OTP before setting new password
3. Check password meets minimum requirements
4. Confirm both password fields match

### Issue: Stuck on step 2
**Solutions:**
1. Use back button to return to step 1
2. Request new OTP
3. Try different browser (clear cache)

---

## Related Files

- Frontend: `resources/js/Pages/Auth/ForgotPassword.jsx`
- Backend: `app/Http/Controllers/Auth/PasswordResetController.php`
- Routes: `routes/api.php`
- Email: `resources/views/emails/otp.blade.php`
- Model: `app/Models/User.php`

---

**Last Updated:** April 20, 2026
**Version:** 1.0.0
**Status:** ✅ Production Ready
