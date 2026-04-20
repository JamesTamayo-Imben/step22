# Password Reset - Quick Reference Guide

## 🎯 What Was Implemented

A complete 3-step OTP-based password reset system with secure verification and new password setup.

## 📋 The 3 Steps

### Step 1️⃣: Send OTP Code
- User enters their email address
- Backend sends 6-digit code to their inbox
- OTP valid for 10 minutes
- User proceeds to verification step

### Step 2️⃣: Verify OTP Code
- User enters 6-digit code from email
- Individual digit input fields with auto-advance
- Resend button available after 60-second cooldown
- After verification, user can set new password

### Step 3️⃣: Set New Password
- User enters new password (min 8 characters)
- User confirms password (must match)
- Toggle eye icon to show/hide password
- Password hashed and stored securely
- Redirect to login with success message

## 🔗 API Endpoints

| Endpoint | Method | Purpose |
|----------|--------|---------|
| `/api/password-reset/send-otp` | POST | Send OTP to email |
| `/api/password-reset/verify-otp` | POST | Verify OTP code |
| `/api/password-reset/reset` | POST | Reset password |

## 📝 Request/Response Examples

### Send OTP
```bash
curl -X POST http://localhost:8000/api/password-reset/send-otp \
  -H "Content-Type: application/json" \
  -d '{"email": "student@kld.edu.ph"}'
```

**Response (Success):**
```json
{
  "success": true,
  "message": "OTP sent to your email"
}
```

### Verify OTP
```bash
curl -X POST http://localhost:8000/api/password-reset/verify-otp \
  -H "Content-Type: application/json" \
  -d '{
    "email": "student@kld.edu.ph",
    "otp": "123456"
  }'
```

**Response (Success):**
```json
{
  "success": true,
  "message": "OTP verified successfully",
  "verification_token": "..."
}
```

### Reset Password
```bash
curl -X POST http://localhost:8000/api/password-reset/reset \
  -H "Content-Type: application/json" \
  -d '{
    "email": "student@kld.edu.ph",
    "otp": "123456",
    "password": "NewPassword123!",
    "password_confirmation": "NewPassword123!"
  }'
```

**Response (Success):**
```json
{
  "success": true,
  "message": "Password reset successfully. Please log in with your new password."
}
```

## 🔒 Security Features

✅ **OTP Security**
- Random 6-digit code
- Cached for 10 minutes
- Different per email

✅ **Password Security**
- Minimum 8 characters
- Bcrypt hashing
- Confirmation validation

✅ **Token Security**
- Cryptographically random
- Separate from OTP
- 15-minute expiration

✅ **Privacy Protection**
- No email enumeration
- Returns success even if email not found
- Detailed errors only visible to legitimate users

## 🧪 Testing Commands

```bash
# 1. Request OTP
curl -X POST http://localhost:8000/api/password-reset/send-otp \
  -H "Content-Type: application/json" \
  -d '{"email": "test@kld.edu.ph"}'

# 2. Verify OTP (replace with actual OTP from email)
curl -X POST http://localhost:8000/api/password-reset/verify-otp \
  -H "Content-Type: application/json" \
  -d '{"email": "test@kld.edu.ph", "otp": "123456"}'

# 3. Reset Password
curl -X POST http://localhost:8000/api/password-reset/reset \
  -H "Content-Type: application/json" \
  -d '{
    "email": "test@kld.edu.ph",
    "otp": "123456",
    "password": "NewPassword123",
    "password_confirmation": "NewPassword123"
  }'
```

## 📊 Cache Storage

| Cache Key | Value | Duration |
|-----------|-------|----------|
| `password_reset_otp_{email}` | OTP + user_id | 10 minutes |
| `password_reset_verified_{email}` | Token + OTP + user_id | 15 minutes |

## 🚀 User Flow

```
Login Page
    ↓
"Forgot Password" link
    ↓
ForgotPassword.jsx - Step 1
    ├─ Input: Email
    ├─ API: POST /api/password-reset/send-otp
    └─ Next: Step 2
    ↓
ForgotPassword.jsx - Step 2
    ├─ Input: 6-digit OTP
    ├─ API: POST /api/password-reset/verify-otp
    └─ Next: Step 3
    ↓
ForgotPassword.jsx - Step 3
    ├─ Input: New password + confirm
    ├─ API: POST /api/password-reset/reset
    └─ Result: Success → Redirect to Login
    ↓
Login Page (with new password)
```

## 📁 Files Modified/Created

| File | Type | Change |
|------|------|--------|
| `resources/js/Pages/Auth/ForgotPassword.jsx` | Component | Updated with 3-step flow |
| `app/Http/Controllers/Auth/PasswordResetController.php` | Controller | Created (3 methods) |
| `routes/api.php` | Route | Added 3 password-reset endpoints |
| `docs/PASSWORD_RESET.md` | Documentation | Created comprehensive guide |

## ⚙️ Configuration Reference

**File:** `.env`

```env
# Mail Configuration (for OTP emails)
MAIL_MAILER=smtp
MAIL_HOST=smtp.mailtrap.io
MAIL_PORT=2525
MAIL_USERNAME=your_username
MAIL_PASSWORD=your_password
MAIL_FROM_ADDRESS=noreply@kld.edu.ph

# Cache Driver (for OTP storage)
CACHE_DRIVER=database
```

## 🐛 Error Codes & Messages

| Scenario | HTTP Status | Message |
|----------|-------------|---------|
| OTP sent successfully | 200 | "OTP sent to your email" |
| Email not found | 200 | "If the email exists, an OTP has been sent" |
| OTP expired | 400 | "OTP expired. Please request a new one." |
| Invalid OTP | 400 | "Invalid OTP code. Please try again." |
| Verification expired | 400 | "Verification expired. Please start over." |
| Validation error | 422 | "Validation error" + field errors |
| Server error | 500 | "An error occurred" |

## 📧 Email Notification

Users receive email with OTP code containing:
- Greeting with their name
- 6-digit verification code
- 10-minute expiration notice
- No-reply notice

## 🔄 Important Timeouts

| Action | Timeout | Impact |
|--------|---------|--------|
| OTP expires | 10 minutes | User must request new OTP |
| Verification expires | 15 minutes | User must verify OTP again |
| Resend cooldown | 60 seconds | Prevent spam |

## ✅ Validation Rules

**Email:**
- Required
- Valid email format
- Must exist in system

**OTP:**
- Required
- Exactly 6 digits
- Must match cached OTP
- Must not be expired

**Password:**
- Required
- Minimum 8 characters
- Must match confirmation field
- Cannot be empty/whitespace

## 🔑 Key Features

✨ **Multi-Step Form**
- Progress indicator on left panel
- Clear visual separation between steps
- Back buttons for navigation

✨ **OTP Input**
- Individual digit fields
- Auto-advances to next field
- Auto-focus on backspace

✨ **Resend Option**
- 60-second cooldown timer
- Shows countdown
- Re-disables after cooldown

✨ **Password Management**
- Show/hide toggle
- Confirmation field
- Strength requirements display

✨ **Error Handling**
- Clear error messages
- Field-level validation
- General error alerts

## 🎨 UI Components Used

- `lucide-react` icons: Mail, Lock, Eye, EyeOff, ArrowLeft
- Tailwind CSS for responsive styling
- Custom input fields with validation
- Loading states on buttons
- Success/error message boxes

---

**Version:** 1.0.0
**Last Updated:** April 20, 2026
**Status:** ✅ Production Ready
