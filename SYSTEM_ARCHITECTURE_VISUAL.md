# System Architecture - Visual Overview

## 📊 Data Flow Diagram

```
┌─────────────────────────────────────────────────────────────────────┐
│                         ADMIN WORKFLOW                             │
└─────────────────────────────────────────────────────────────────────┘

┌─────────────────────┐
│   User Management   │
│    Page Loaded      │
│  /sadmin/users      │
└──────────┬──────────┘
           │
           │ Clicks "Create User"
           ↓
┌──────────────────────────────────────────────┐
│          MODAL STEP 1                        │
│  ┌────────────────────────────────────────┐  │
│  │ Select Role:                           │  │
│  │ ☐ Student      ☐ Single  ☐ Multiple   │  │
│  │ ☐ Teacher      ☐ Single  ☐ Multiple   │  │
│  │ ☐ Adviser      ☐ Single  ☐ Multiple   │  │
│  └────────────────────────────────────────┘  │
└──────────┬───────────────────────────────────┘
           │
           │ User selects role & type
           ↓
┌──────────────────────────────────────────────┐
│          MODAL STEP 2                        │
│  ┌────────────────────────────────────────┐  │
│  │ SINGLE MODE:                           │  │
│  │ Name: [Juan Dela Cruz]                 │  │
│  │ Email: [juan@kld.edu.ph]               │  │
│  └────────────────────────────────────────┘  │
│  OR                                          │
│  ┌────────────────────────────────────────┐  │
│  │ MULTIPLE MODE (Max 10):                │  │
│  │ juan@kld.edu.ph                        │  │
│  │ maria@kld.edu.ph                       │  │
│  │ Juan Dela Cruz juan2@kld.edu.ph        │  │
│  └────────────────────────────────────────┘  │
│                                              │
│  [Back]  [Create & Send Invitations]        │
└──────────┬───────────────────────────────────┘
           │
           │ Form submitted
           ↓
┌──────────────────────────────────────────────┐
│     API: POST /sadmin/users/bulk-create      │
│                                              │
│ Request Body:                                │
│ {                                            │
│   "role_id": "uuid-123",                     │
│   "users": [                                 │
│     {email: "juan@kld.edu.ph",               │
│      name: "Juan Dela Cruz"}                 │
│   ]                                          │
│ }                                            │
└──────────┬───────────────────────────────────┘
           │
           │ Processing in UserManagementController
           ↓
┌──────────────────────────────────────────────┐
│        FOR EACH USER:                        │
│                                              │
│  1. Generate Password                        │
│     juan@kld.edu.ph → juanKLD2026            │
│                                              │
│  2. Create User Record                       │
│     id: UUID                                 │
│     name: "Juan Dela Cruz"                   │
│     email: "juan@kld.edu.ph"                 │
│     password: bcrypt("juanKLD2026")          │
│     role_id: uuid-123                        │
│     status: active                           │
│                                              │
│  3. Create Role-Specific Record              │
│     If Student:                              │
│       → student_csg_officers table           │
│     If Teacher:                              │
│       → teacher_adviser table                │
│                                              │
│  4. Generate Signup Link                     │
│     /auth/register-teacher?                  │
│       email=juan@kld.edu.ph&                 │
│       password=juanKLD2026&                  │
│       name=Juan%20Dela%20Cruz                │
│                                              │
│  5. Send Invitation Email                    │
│     To: juan@kld.edu.ph                      │
│     Template: user-invitation.blade.php      │
└──────────┬───────────────────────────────────┘
           │
           │ Response: 201 Created
           ↓
┌──────────────────────────────────────────────┐
│      Admin Modal Shows Success               │
│  ✅ Successfully created 1 user(s)          │
│     Invitation emails sent.                  │
│  [Close]                                     │
└──────────┬───────────────────────────────────┘
           │
           │ Modal closes
           ↓
┌──────────────────────────────────────────────┐
│    User Appears in Management Table          │
│  name: Juan Dela Cruz                        │
│  email: juan@kld.edu.ph                      │
│  role: Teacher                               │
│  status: ✅ Active                           │
│  created: Apr 18, 2026                       │
└──────────────────────────────────────────────┘


┌─────────────────────────────────────────────────────────────────────┐
│                         USER WORKFLOW                               │
└─────────────────────────────────────────────────────────────────────┘

┌────────────────────────────────────┐
│   User Receives Email              │
│   From: noreply@kld.edu.ph         │
│   Subject: Welcome! Complete Your  │
│   Registration                     │
└──────────┬─────────────────────────┘
           │
           │ Email Content:
           ↓
┌────────────────────────────────────┐
│  Hello Juan Dela Cruz!             │
│                                    │
│  Your account has been created     │
│  and is ready to use.              │
│                                    │
│  ┌──────────────────────────────┐  │
│  │ Email: juan@kld.edu.ph       │  │
│  │ Password: juanKLD2026        │  │
│  │ Role: Teacher                │  │
│  └──────────────────────────────┘  │
│                                    │
│  ⚠️ Please change your password    │
│  immediately after first login     │
│                                    │
│  [Complete Your Registration]      │
│  Link:                             │
│  /auth/register-teacher?           │
│    email=juan@kld.edu.ph&          │
│    password=juanKLD2026&           │
│    name=Juan%20Dela%20Cruz         │
│                                    │
│  Next Steps:                       │
│  1. Click button to start          │
│  2. Email/password pre-filled      │
│  3. Complete profile info          │
│  4. Change password to secure      │
│  5. Start using platform           │
└──────────┬─────────────────────────┘
           │
           │ User clicks link
           ↓
┌────────────────────────────────────────────────┐
│   Teacher Signup Page Loaded                   │
│   GET /auth/register-teacher?                  │
│     email=juan@kld.edu.ph&                     │
│     password=juanKLD2026&                      │
│     name=Juan%20Dela%20Cruz                    │
└──────────┬─────────────────────────────────────┘
           │
           │ Pre-filled data parsed from URL
           ↓
┌────────────────────────────────────────────────┐
│   TEACHER REGISTRATION FORM                    │
│  ┌──────────────────────────────────────────┐  │
│  │ First Name:        [Juan] (pre-filled)   │  │
│  │ Last Name:         [Dela Cruz] (pre)     │  │
│  │ Employee ID *:     [______]              │  │
│  │ Specialization:    [______]              │  │
│  │ Office Location:   [______]              │  │
│  │                                          │  │
│  │ Email:     juan@kld.edu.ph (info)        │  │
│  │ Password:  juanKLD2026 (reference)       │  │
│  │                                          │  │
│  │            [Complete Registration]       │  │
│  └──────────────────────────────────────────┘  │
└──────────┬──────────────────────────────────────┘
           │
           │ Form filled and submitted
           ↓
┌────────────────────────────────────────────────┐
│   API: POST /api/auth/register-teacher         │
│                                                │
│   Request:                                     │
│   {                                            │
│     "firstName": "Juan",                       │
│     "lastName": "Dela Cruz",                   │
│     "email": "juan@kld.edu.ph",                │
│     "password": "juanKLD2026",                 │
│     "employeeId": "T-12345",                   │
│     "specialization": "Mathematics",           │
│     "officeLocation": "Room 201",              │
│     "role": "teacher"                          │
│   }                                            │
└──────────┬──────────────────────────────────────┘
           │
           │ Processing in BulkRegistrationController
           ↓
┌────────────────────────────────────────────────┐
│   Validate Input                               │
│   ✅ All required fields present               │
│   ✅ Employee ID unique                        │
│   ✅ Email unique                              │
└──────────┬──────────────────────────────────────┘
           │
           │ Validation passed
           ↓
┌────────────────────────────────────────────────┐
│   Update User Record                           │
│   UPDATE users SET                             │
│     password = bcrypt("juanKLD2026")           │
│   WHERE email = "juan@kld.edu.ph"              │
│                                                │
│   Create Teacher Record                        │
│   INSERT INTO teacher_adviser (                │
│     id: "T-12345",                             │
│     user_id: uuid-123,                         │
│     specialization: "Mathematics",             │
│     office_location: "Room 201"                │
│   )                                            │
└──────────┬──────────────────────────────────────┘
           │
           │ Response: 201 Created
           ↓
┌────────────────────────────────────────────────┐
│   Success Page                                 │
│   ✅ Registration Successful!                 │
│   Your account has been created.              │
│   Redirecting to login...                     │
│                                                │
│   (After 2 seconds)                            │
│   ↓                                            │
│   Login Page: /login                          │
│   (User can now login with creds)             │
└────────────────────────────────────────────────┘
```

## 🗄️ Database Schema

```
┌─────────────────────────────────────┐
│         users                       │
├─────────────────────────────────────┤
│ id (UUID)                      ◄────┼─── Primary Key
│ name                                │
│ email (unique)                      │
│ password (hashed)                   │
│ phone                               │
│ role_id (FK) ───────┐               │
│ status              │               │
│ email_verified_at   │               │
│ last_login_at       │               │
│ archive             │               │
│ created_at          │               │
└─────────────────────────────────────┘
                      │
                      │
          ┌───────────┴───────────┐
          ↓                       ↓
┌──────────────────────┐  ┌──────────────────────┐
│      roles           │  │    RELATED           │
├──────────────────────┤  │    RECORDS           │
│ id (UUID)            │  │                      │
│ name (Student,       │  │ ┌──────────────────┐ │
│  Teacher, etc.)      │  │ │ teacher_adviser  │ │
│ created_at           │  │ ├──────────────────┤ │
└──────────────────────┘  │ │ id               │ │
                          │ │ user_id (FK)     │ │
                          │ │ specialization   │ │
                          │ │ office_location  │ │
                          │ │ is_adviser       │ │
                          │ └──────────────────┘ │
                          │                      │
                          │ ┌──────────────────┐ │
                          │ │ student_csg_off  │ │
                          │ │ ├──────────────────┤ │
                          │ │ id               │ │
                          │ │ user_id (FK)     │ │
                          │ │ year_level       │ │
                          │ └──────────────────┘ │
                          └──────────────────────┘
```

## 🔄 Component Interaction

```
                    USER MANAGEMENT
                          │
                ┌─────────┼─────────┐
                ↓         ↓         ↓
          [Users]   [Filters] [Actions]
                          │
                    [Create Button]
                          │
        ┌─────────────────┼─────────────────┐
        │                 │                 │
        ↓                 ↓                 ↓
    [Modal Step 1]  [Modal Step 2]  [Success/Error]
    Select Role     Input Data      Feedback
        │                 │
        └─────────────────┤
                          ↓
            API ENDPOINT: /sadmin/users/bulk-create
                          │
        ┌─────────────────┼─────────────────┐
        ↓                 ↓                 ↓
    [Validate]      [Create Users]  [Send Emails]
    Input            in DB           via Mail
        │                 │                 │
        └─────────────────┼─────────────────┘
                          │
                    [Response JSON]
                          │
                ┌─────────┼─────────┐
                ↓         ↓         ↓
            Success    Error    Partial
            (201)      (422/500) Failure
```

## 📧 Email Flow

```
┌──────────────────────────────────────────┐
│  bulkCreate() Method                     │
│  Creates Users                           │
└──────────┬───────────────────────────────┘
           │
           │ For each user:
           ↓
┌──────────────────────────────────────────┐
│  Generate signup link with params        │
│  /auth/register-teacher?                 │
│    email=user@kld.edu.ph&                │
│    password=userKLD2026&                 │
│    name=User%20Name                      │
└──────────┬───────────────────────────────┘
           │
           │ Pass to Mail::send()
           ↓
┌──────────────────────────────────────────┐
│  Email Template: user-invitation.blade   │
│  ┌──────────────────────────────────────┐│
│  │ {name: "Juan Dela Cruz"}             ││
│  │ {email: "juan@kld.edu.ph"}           ││
│  │ {password: "juanKLD2026"}            ││
│  │ {role: "Teacher"}                    ││
│  │ {signupLink: "full_url_with_params"} ││
│  └──────────────────────────────────────┘│
└──────────┬───────────────────────────────┘
           │
           │ Blade template renders HTML
           ↓
┌──────────────────────────────────────────┐
│  Beautiful HTML Email with:              │
│  - Header/Footer                         │
│  - Credentials Box                       │
│  - Role Badge                            │
│  - Security Warning                      │
│  - CTA Button (signup link)              │
│  - Instructions                          │
└──────────┬───────────────────────────────┘
           │
           │ Send via configured MAIL driver
           ↓
┌──────────────────────────────────────────┐
│  Email Delivered (or logged if fails)    │
│  User receives in inbox                  │
└──────────────────────────────────────────┘
```

## 🎯 Key Decision Points

```
       "Create User" Clicked
                │
                ↓
    ┌───────────────────────────┐
    │ "Which role?"             │
    │ (Step 1 - Modal)          │
    └───────────┬───────────────┘
                │
        ┌───────┴────────┐
        ↓                ↓
    Student          Teacher
        │                │
        ├──────┬─────────┤
        ↓      ↓         ↓
      Single Multiple Adviser
        │      │
        ├──────┤
    ┌───┴─┐ ┌─┴──────┐
    │ Step2│ │ Step2  │
    │Name  │ │Emails  │
    │Email │ │ (max10)│
    └───┬──┘ └──┬─────┘
        │       │
        └───┬───┘
            ↓
    Form Validation
        │
        ├─ Valid ──→ API Call ──→ Success ──→ Emails Sent
        │
        └─ Invalid ─→ Error Message ──→ Retry
```

This architecture ensures:
- ✅ Clear separation of concerns
- ✅ Reusable components
- ✅ Scalable design
- ✅ Easy to test
- ✅ Easy to extend
