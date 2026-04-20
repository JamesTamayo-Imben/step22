# 🎓 STEP - School Transparency & Evaluation Platform

<div align="center">

![Status](https://img.shields.io/badge/status-active-success)
![Version](https://img.shields.io/badge/version-1.0.0-blue)
![License](https://img.shields.io/badge/license-MIT-green)
![Laravel](https://img.shields.io/badge/Laravel-12.x-red)
![React](https://img.shields.io/badge/React-18.x-blue)

A modern, comprehensive school management and transparency platform built with Laravel 12, React 18, and Inertia.js for Kolehiyo ng Lungsod ng Dasmariñas (KLD).

**[Features](#features)** • **[Tech Stack](#tech-stack)** • **[Installation](#installation)** • **[Database](#database)** • **[API Documentation](#api-documentation)** • **[Contributing](#contributing)**

</div>

---

## 📋 Table of Contents

- [Overview](#overview)
- [Features](#features)
- [Tech Stack](#tech-stack)
- [System Architecture](#system-architecture)
- [Installation & Setup](#installation--setup)
- [Database Schema](#database-schema)
- [Authentication System](#authentication-system)
- [API Documentation](#api-documentation)
- [Project Structure](#project-structure)
- [User Roles & Permissions](#user-roles--permissions)
- [Key Components](#key-components)
- [Development Workflow](#development-workflow)
- [Troubleshooting](#troubleshooting)
- [Contributing](#contributing)
- [License](#license)

---

## 🎯 Overview

STEP (School Transparency & Evaluation Platform) is an integrated school management system designed to streamline communication, evaluation, and transparency between students, teachers, administrators, and parents/guardians. The platform leverages modern web technologies to provide a seamless user experience across desktop and mobile devices.

### Key Objectives

- **Transparency**: Provide clear visibility into student performance and institutional activities
- **Efficiency**: Automate administrative tasks and reduce paperwork
- **Collaboration**: Enable effective communication between all stakeholders
- **Evaluation**: Facilitate fair and consistent performance evaluations
- **Accessibility**: Ensure easy access to information for all users

---

## ✨ Features

### 👤 Authentication & Onboarding

- **Google OAuth Integration** via Supabase for seamless SSO
- **Email Domain Validation** (@kld.edu.ph required)
- **Role-Based Onboarding** with dynamic form fields based on user role
- **Profile Completion** with optional skip option
- **Temporary Password Generation** on account creation
- **Email Notifications** with login credentials sent automatically

### 📚 Student Features

- View and manage academic records
- Track course enrollments and progress
- Submit assignments and projects
- View grades and evaluations from instructors
- Access course materials and resources
- Submit feedback and ratings for courses/teachers
- Track CSG (Class Student Government) activities

### 👨‍🏫 Teacher Features

- Manage courses and course materials
- View enrolled students
- Record student grades and evaluations
- Provide feedback and comments on assignments
- View CSG adviser responsibilities
- Access institute-specific information
- Generate and export student reports

### 👨‍💼 Admin Features

- Manage users and roles
- Manage courses and institutes
- View system-wide statistics and reports
- Configure platform settings
- Audit logs for system activities
- User activity tracking

### 🔐 Security Features

- Secure authentication with encrypted sessions
- Role-based access control (RBAC)
- CSRF protection on all forms
- Audit logging of critical actions
- Temporary password policies
- Email verification

### 📱 User Experience

- Responsive design for mobile and desktop
- Intuitive navigation
- Real-time notifications
- Dark/Light theme support (UI components ready)
- Smooth page transitions with Inertia.js

---

## 🛠 Tech Stack

### Backend

| Technology | Purpose | Version |
|-----------|---------|---------|
| **Laravel** | Web Framework | 12.x |
| **PHP** | Server Language | 8.2+ |
| **MySQL/MariaDB** | Database | 8.0+ |
| **Supabase** | OAuth Provider | Latest |

### Frontend

| Technology | Purpose | Version |
|-----------|---------|---------|
| **React** | UI Framework | 18.x |
| **Inertia.js** | Server-driven UI | 1.x |
| **Tailwind CSS** | Styling | 3.x |
| **Vite** | Build Tool | Latest |

### Development Tools

| Tool | Purpose |
|------|---------|
| **Composer** | PHP Package Manager |
| **npm/yarn** | JavaScript Package Manager |
| **PHPUnit** | PHP Testing Framework |
| **Laravel Pint** | PHP Code Style Fixer |
| **Axios** | HTTP Client |

---

## 🏗 System Architecture

### High-Level Architecture

```
┌─────────────────────────────────────────────────────────────────┐
│                        Client Layer (React)                      │
│                   Browser-based UI Components                    │
└──────────────────────────────┬──────────────────────────────────┘
                               │
                    ┌──────────▼──────────┐
                    │   Inertia.js        │
                    │  Server-Driven UI   │
                    └──────────┬──────────┘
                               │
┌──────────────────────────────▼──────────────────────────────────┐
│                     Backend Layer (Laravel)                      │
│                                                                   │
│  ┌──────────────────────────────────────────────────────────┐  │
│  │            API Routes & Controllers                       │  │
│  │  (Onboarding, Users, Courses, Grades, etc.)             │  │
│  └──────────────────────────────────────────────────────────┘  │
│                                                                   │
│  ┌──────────────────────────────────────────────────────────┐  │
│  │            Middleware Layer                               │  │
│  │  (Auth, CORS, Inertia, Rate Limiting, Audit)            │  │
│  └──────────────────────────────────────────────────────────┘  │
│                                                                   │
│  ┌──────────────────────────────────────────────────────────┐  │
│  │            Models & Services                              │  │
│  │  (Business Logic, Relationships, Queries)               │  │
│  └──────────────────────────────────────────────────────────┘  │
└──────────────────────────────┬──────────────────────────────────┘
                               │
┌──────────────────────────────▼──────────────────────────────────┐
│                      Data Layer                                  │
│                                                                   │
│  ┌───────────────────┬─────────────────────┬──────────────┐   │
│  │   MySQL Database  │  Session Storage    │  File Storage│   │
│  └───────────────────┴─────────────────────┴──────────────┘   │
└──────────────────────────────────────────────────────────────────┘
```

### Request Flow

```
1. User Request (OAuth/Form)
         │
         ▼
2. Laravel Router (routes/web.php or routes/api.php)
         │
         ▼
3. Middleware Stack (HandleInertiaRequests, Auth, etc.)
         │
         ▼
4. Controller Action (Business Logic)
         │
         ▼
5. Model/Service Layer (Database Queries)
         │
         ▼
6. Return Response (JSON or Inertia Props)
         │
         ▼
7. React Component Renders
```

---

## 📦 Installation & Setup

### Prerequisites

- PHP 8.2 or higher
- Composer
- Node.js (v16+) and npm/yarn
- MySQL 8.0 or MariaDB 10.4+
- Git

### Step 1: Clone Repository

```bash
git clone https://github.com/JamesTamayo-Imben/step22.git
cd step22
```

### Step 2: Install Dependencies

```bash
# Install PHP dependencies
composer install

# Install JavaScript dependencies
npm install
```

### Step 3: Environment Configuration

```bash
# Copy environment file
cp .env.example .env

# Generate application key
php artisan key:generate
```

**Update `.env` with:**

```env
APP_NAME=STEP
APP_URL=http://localhost:8000

DB_CONNECTION=mysql
DB_HOST=127.0.0.1
DB_PORT=3306
DB_DATABASE=step_system
DB_USERNAME=root
DB_PASSWORD=

# Supabase OAuth Configuration
SUPABASE_URL=your_supabase_url
SUPABASE_ANON_KEY=your_supabase_anon_key
SUPABASE_SERVICE_KEY=your_supabase_service_key

# Mail Configuration
MAIL_MAILER=smtp
MAIL_HOST=smtp.mailtrap.io
MAIL_PORT=2525
MAIL_USERNAME=your_username
MAIL_PASSWORD=your_password
MAIL_FROM_ADDRESS=noreply@kld.edu.ph
```

### Step 4: Database Setup

```bash
# Run migrations
php artisan migrate

# Seed database with sample data (optional)
php artisan db:seed

# Create storage symlink
php artisan storage:link
```

### Step 5: Start Development Servers

```bash
# Terminal 1: Laravel Development Server
php artisan serve

# Terminal 2: Vite Development Server
npm run dev
```

Access the application at `http://localhost:8000`

### Step 6: Verify Installation

- Navigate to login page
- Try Google OAuth login with @kld.edu.ph email
- Complete onboarding flow
- Access user dashboard

---

## 🗄 Database Schema

### Core Tables

#### `users`
Main user account table
- `id` (UUID) - Primary Key
- `name` (string) - User's full name
- `email` (string) - University email
- `role_id` (UUID) - Foreign Key to roles
- `profile_completed` (boolean) - Onboarding status
- `phone` (string) - Contact number
- `avatar_url` (string) - Profile picture
- `email_verified_at` (timestamp) - Email verification
- `password` (string) - Hashed password (nullable for OAuth users)
- `timestamps`

#### `roles`
User role definitions
- `id` (UUID) - Primary Key
- `name` (string) - Role name (Student, Teacher, Admin, Superadmin)
- `slug` (string) - URL-friendly role identifier
- `description` (text) - Role description
- `timestamps`

#### `student_csg_officers`
Student information and CSG roles
- `id` (string) - Student ID (Primary Key)
- `user_id` (UUID) - Foreign Key to users
- `course_id` (UUID) - Foreign Key to courses
- `is_csg` (boolean) - Is CSG member
- `csg_is_active` (boolean) - CSG member active status
- `timestamps`

#### `teacher_adviser`
Teacher information and adviser roles
- `id` (string) - Employee ID (Primary Key)
- `user_id` (UUID) - Foreign Key to users
- `institute_id` (UUID) - Foreign Key to institutes
- `is_adviser` (boolean) - Is class adviser
- `timestamps`

#### `courses`
Course/Subject information
- `id` (UUID) - Primary Key
- `code` (string) - Course code (unique)
- `name` (string) - Course name
- `description` (text) - Course description
- `credit_units` (decimal) - Credit value
- `institute_id` (UUID) - Foreign Key to institutes
- `timestamps`

#### `institutes`
Academic institutes/departments
- `id` (UUID) - Primary Key
- `code` (string) - Institute code (unique)
- `name` (string) - Institute name
- `description` (text) - Institute description
- `head_name` (string) - Institute head/chair
- `timestamps`

#### `grades`
Student grades and evaluations
- `id` (UUID) - Primary Key
- `student_id` (string) - Foreign Key to student_csg_officers
- `course_id` (UUID) - Foreign Key to courses
- `teacher_id` (string) - Foreign Key to teacher_adviser
- `grade` (decimal) - Numeric grade
- `remarks` (text) - Teacher comments
- `timestamps`

#### `audit_logs`
System audit trail
- `id` (UUID) - Primary Key
- `user_id` (UUID) - Foreign Key to users
- `action` (string) - Action performed
- `model` (string) - Model affected
- `model_id` (string) - Record ID
- `changes` (json) - Before/after values
- `ip_address` (string) - User IP
- `user_agent` (string) - Browser info
- `timestamps`

#### `notifications`
User notifications
- `id` (UUID) - Primary Key
- `user_id` (UUID) - Foreign Key to users
- `type` (string) - Notification type
- `title` (string) - Notification title
- `message` (text) - Notification content
- `read_at` (timestamp) - Read status
- `timestamps`

### Relationships Diagram

```
users (1) ──────── (1) roles
  │
  ├─── (1) ────── (1) student_csg_officers
  │                      │
  │                      └─── (1) ────── (1) courses
  │
  ├─── (1) ────── (1) teacher_adviser
  │                      │
  │                      └─── (1) ────── (1) institutes
  │
  ├─── (1) ────── (M) grades
  │
  ├─── (1) ────── (M) audit_logs
  │
  └─── (1) ────── (M) notifications

courses (1) ────── (M) grades
           └────── (M) student_csg_officers

institutes (1) ──── (M) teacher_adviser
            └───── (M) courses

teacher_adviser (1) ──── (M) grades
```

---

## 🔐 Authentication System

### OAuth Flow (Google)

```
1. User clicks "Sign in with Google" → Redirects to Supabase OAuth endpoint
2. User authenticates with Google account
3. Google redirects back with authorization code
4. Supabase exchanges code for ID token
5. Token sent to Laravel backend (/api/auth/callback)
6. Backend verifies token and creates/updates user in database
7. Session established, user redirected to onboarding or dashboard
```

### Session Management

- **Driver**: Database (configurable in `config/session.php`)
- **Lifetime**: 120 minutes (configurable)
- **Secure Cookies**: Enabled in production
- **CSRF Protection**: Enabled on all state-changing requests

### Password Policy

- **Temporary Password Format**: `{email_local_part}KLD{year}`
  - Example: `{username}@kld.edu.ph` → `{username}KLD2026`
- **Required Change**: On first login after onboarding
- **Minimum Length**: 8 characters (configurable)
- **Complexity**: Enforced during password change

---

## 📡 API Documentation

### Base URL
- Development: `http://localhost:8000/api`
- Production: `https://your-domain.com/api`

### Authentication
Include CSRF token in request header or use Laravel cookies for authenticated requests.

### Key Endpoints

#### Authentication

**POST** `/auth/callback`
- Handle OAuth callback from Supabase
- Body: `{ code, state }`
- Response: User data and session token

**POST** `/auth/logout`
- Terminate user session
- Response: `{ success: true }`

#### Onboarding

**POST** `/onboarding/complete`
- Complete user profile setup
- Body: `{ user_id, email, role, student_id, course_id, employee_id, institute_id }`
- Response: User profile with assigned role and ID

**POST** `/onboarding/skip`
- Skip profile completion (minimal setup)
- Body: `{ user_id, email }`
- Response: `{ success: true, message: "..." }`

**GET** `/onboarding/courses`
- Retrieve available courses for student onboarding
- Response: Array of courses with IDs and names

**GET** `/onboarding/institutes`
- Retrieve available institutes for teacher onboarding
- Response: Array of institutes with IDs and names

#### User Management

**GET** `/user`
- Retrieve current authenticated user profile
- Response: User object with relationships (role, student, teacher)

**PUT** `/user/profile`
- Update user profile information
- Body: `{ name, phone, avatar }`
- Response: Updated user object

**POST** `/user/password`
- Change user password
- Body: `{ current_password, password, password_confirmation }`
- Response: `{ success: true }`

#### Courses

**GET** `/courses`
- List all courses with pagination
- Query: `?page=1&per_page=15`
- Response: Paginated course list

**GET** `/courses/{id}`
- Retrieve specific course details
- Response: Course object with enrolled students

**POST** `/courses` (Admin only)
- Create new course
- Body: `{ code, name, description, credit_units, institute_id }`
- Response: Created course object

#### Grades

**GET** `/grades/student/{student_id}`
- Retrieve grades for specific student
- Response: Array of grade records

**POST** `/grades`
- Record student grade (Teacher only)
- Body: `{ student_id, course_id, grade, remarks }`
- Response: Created grade record

#### Notifications

**GET** `/notifications`
- Retrieve user notifications
- Query: `?read=false` (filter unread)
- Response: Array of notifications

**PUT** `/notifications/{id}`
- Mark notification as read
- Response: Updated notification

---

## 📁 Project Structure

```
step22/
├── app/
│   ├── Exceptions/
│   │   └── Handler.php                    # Exception handling
│   ├── Http/
│   │   ├── Controllers/
│   │   │   ├── Auth/
│   │   │   │   ├── OAuthCallbackController.php
│   │   │   │   ├── OnboardingController.php
│   │   │   │   └── LoginController.php
│   │   │   ├── UserController.php
│   │   │   ├── CourseController.php
│   │   │   └── GradeController.php
│   │   ├── Middleware/
│   │   │   ├── HandleInertiaRequests.php  # Inertia data sharing
│   │   │   ├── VerifyCsrfToken.php
│   │   │   └── Authenticate.php
│   │   └── Requests/
│   │       ├── OnboardingRequest.php
│   │       └── ProfileUpdateRequest.php
│   ├── Mail/
│   │   ├── OnboardingWelcomeMail.php      # Welcome email with temp password
│   │   ├── OTPMail.php
│   │   └── SuccessMail.php
│   ├── Models/
│   │   ├── User.php                       # Core user model
│   │   ├── Student.php
│   │   ├── StudentCsgOfficer.php          # Student record with CSG info
│   │   ├── Teacher.php
│   │   ├── TeacherAdviser.php             # Teacher record with adviser info
│   │   ├── Course.php
│   │   ├── Institute.php
│   │   ├── Role.php
│   │   ├── Grade.php
│   │   ├── Notification1.php
│   │   ├── AuditLog.php
│   │   └── CSG/
│   │       └── Chain.php
│   ├── Services/
│   │   ├── SupabaseService.php            # Supabase OAuth service
│   │   └── BlockchainService.php
│   ├── Support/
│   │   ├── AdviserLedgerFormatter.php
│   │   └── BlockchainService.php
│   └── Providers/
│       └── AppServiceProvider.php
├── bootstrap/
│   ├── app.php
│   └── providers.php
├── config/
│   ├── app.php                            # Application config
│   ├── auth.php                           # Authentication config
│   ├── database.php                       # Database config
│   ├── mail.php                           # Email config
│   ├── session.php                        # Session config
│   └── services.php                       # Third-party services
├── database/
│   ├── migrations/                        # Database migrations
│   │   ├── *_create_users_table.php
│   │   ├── *_create_courses_table.php
│   │   ├── *_create_student_csg_officers_table.php
│   │   └── ... (more migrations)
│   ├── seeders/                           # Database seeders
│   └── factories/                         # Model factories
├── public/
│   ├── index.php                          # Application entry point
│   ├── images/                            # Static images
│   └── storage/                           # Symbolic link to storage/app/public
├── resources/
│   ├── css/
│   │   └── app.css                        # Tailwind CSS
│   ├── js/
│   │   ├── app.jsx                        # React entry point
│   │   ├── Pages/
│   │   │   ├── Auth/
│   │   │   │   ├── OAuthCallback.jsx      # OAuth handling & onboarding form
│   │   │   │   └── Login.jsx
│   │   │   ├── Dashboard.jsx
│   │   │   ├── User/
│   │   │   │   ├── pages/
│   │   │   │   │   └── StudentProfile.jsx # Student/Teacher profile display
│   │   │   │   └── Account.jsx
│   │   │   ├── Courses/
│   │   │   │   ├── Index.jsx
│   │   │   │   └── Show.jsx
│   │   │   └── Grades/
│   │   │       └── Index.jsx
│   │   └── Components/
│   │       ├── Navigation.jsx
│   │       ├── Sidebar.jsx
│   │       └── ... (shared components)
│   └── views/
│       ├── app.blade.php                  # Inertia root template
│       └── emails/
│           ├── onboarding-welcome.blade.php # Welcome email template
│           ├── otp.blade.php
│           └── ... (other email templates)
├── routes/
│   ├── api.php                            # API routes
│   ├── web.php                            # Web routes
│   ├── auth.php                           # Auth routes
│   └── console.php                        # Console commands
├── storage/
│   ├── app/                               # Application files
│   ├── framework/                         # Framework cache
│   └── logs/                              # Application logs
├── tests/
│   ├── Feature/                           # Feature tests
│   └── Unit/                              # Unit tests
├── .env.example                           # Environment template
├── artisan                                # Laravel CLI
├── composer.json                          # PHP dependencies
├── package.json                           # JavaScript dependencies
├── vite.config.js                         # Vite configuration
├── tailwind.config.js                     # Tailwind CSS configuration
├── phpunit.xml                            # PHPUnit configuration
└── README.md                              # This file
```

---

## 👥 User Roles & Permissions

### Role Hierarchy

```
┌─────────────────────────────────────────────┐
│          Superadmin (Full Access)           │
│  • Manage all users and roles               │
│  • Configure system settings                │
│  • View all audit logs                      │
│  • Access all data                          │
└─────────────────────────────────────────────┘
                    ▲
                    │
        ┌───────────┴────────────┐
        ▼                        ▼
┌─────────────────┐    ┌──────────────────┐
│      Admin      │    │ Institute Head   │
│ • User Management   │ • Manage institute │
│ • Course setup      │ • View institute   │
│ • View reports      │   data             │
└─────────────────┘    └──────────────────┘
        ▲
        │
    ┌───┴─────┐
    ▼         ▼
 Teacher   Student
 • Teach    • View grades
 • Grade    • Submit work
 • Advise   • Rate courses
```

### Permission Matrix

| Action | Student | Teacher | Admin | Superadmin |
|--------|---------|---------|-------|-----------|
| View Own Grades | ✅ | ✅ | ✅ | ✅ |
| Record Grades | ❌ | ✅ | ✅ | ✅ |
| Manage Users | ❌ | ❌ | ✅ | ✅ |
| Create Courses | ❌ | ❌ | ✅ | ✅ |
| View Audit Logs | ❌ | ❌ | ✅ | ✅ |
| System Config | ❌ | ❌ | ❌ | ✅ |

---

## 🔧 Key Components

### Frontend Components

#### `OAuthCallback.jsx`
Handles Google OAuth authentication callback and onboarding form display.

**Features:**
- Validates @kld.edu.ph email domain
- Dynamic form fields based on user role
- Course/Institute selection dropdowns
- Real-time validation with error display
- Submits complete/skip onboarding action
- Sends temporary password via email

**Props:**
- `auth.user` - Authenticated user data
- `auth.redirect_url` - Post-login redirect

#### `StudentProfile.jsx`
Displays user profile with student/employee IDs.

**Features:**
- Shows Student ID for students
- Shows Employee ID for teachers
- Displays profile information
- Editable profile fields
- Role-specific information display

#### Navigation Components
- Responsive sidebar navigation
- Role-based menu items
- User dropdown menu
- Mobile hamburger menu

### Backend Controllers

#### `OnboardingController`

**Methods:**
- `complete()` - Finalize onboarding with student/teacher linking
- `skip()` - Skip profile setup and send welcome email
- `setPassword()` - Allow user to set new password
- `getCourses()` - Return available courses
- `getInstitutes()` - Return available institutes

**Key Logic:**
- Database transactions for atomic operations
- Temporary password generation and email sending
- Student/teacher record creation
- Validation and error handling

#### `UserController`

**Methods:**
- `show()` - Get current user profile
- `update()` - Update profile information
- `changePassword()` - Change user password

---

## 🚀 Development Workflow

### Running the Application

```bash
# Terminal 1: Start Laravel server
php artisan serve

# Terminal 2: Start Vite development server
npm run dev

# Access application at http://localhost:8000
```

### Database Management

```bash
# Create new migration
php artisan make:migration create_table_name

# Run migrations
php artisan migrate

# Rollback last migration
php artisan migrate:rollback

# Seed database
php artisan db:seed

# Fresh migration and seed
php artisan migrate:fresh --seed
```

### Code Quality

```bash
# Run PHP tests
php artisan test

# Fix code style
php artisan pint

# Check code coverage
php artisan test --coverage
```

### Debugging

```bash
# View application logs
tail -f storage/logs/laravel.log

# Tinker (interactive shell)
php artisan tinker

# Debug email sending (test)
php artisan tinker
# In tinker: Mail::to('test@example.com')->send(new OnboardingWelcomeMail(...))
```

---

## 🐛 Troubleshooting

### Common Issues

#### 1. "422 Unprocessable Content" on Onboarding

**Cause**: Missing required fields in API request
**Solution**: Ensure `email` and `role` fields are included in POST body

```javascript
// ✅ Correct
fetch('/api/onboarding/complete', {
  body: JSON.stringify({
    user_id: uuid,
    email: 'user@kld.edu.ph',
    role: 'student',
    student_id: 'STU001',
    course_id: courseUuid
  })
})

// ❌ Wrong - Missing email and role
fetch('/api/onboarding/complete', {
  body: JSON.stringify({
    user_id: uuid,
    student_id: 'STU001',
    course_id: courseUuid
  })
})
```

#### 2. Student IDs Not Displaying in Profile

**Cause**: User model relationship not loading StudentCsgOfficer
**Solution**: Verify `HandleInertiaRequests` middleware loads relationships:

```php
// config/app.php middleware
$user->load('role', 'student', 'teacher');
```

#### 3. Emails Not Sending

**Cause**: Mail configuration incorrect or SMTP credentials invalid
**Solution**: 
- Verify `.env` mail settings
- Test with Mailtrap or local mail service
- Check `storage/logs/laravel.log` for errors

```bash
# Test email sending
php artisan tinker
Mail::to('test@kld.edu.ph')->send(new OnboardingWelcomeMail(...))
```

#### 4. OAuth Login Not Working

**Cause**: Supabase credentials or redirect URL misconfigured
**Solution**:
- Verify `SUPABASE_URL` and `SUPABASE_ANON_KEY` in `.env`
- Ensure redirect URL matches in Supabase configuration
- Check browser console for OAuth errors

#### 5. Session Not Persisting

**Cause**: Session configuration or driver issue
**Solution**:
- Verify `SESSION_DRIVER=database` in `.env`
- Run `php artisan migrate` to create sessions table
- Check cookie settings in `config/session.php`

---

## 📝 Contributing

Contributions are welcome! Please follow these guidelines:

### Code Style
- Follow PSR-12 standard for PHP
- Use Laravel naming conventions
- Add DocBlocks to functions/methods

### Testing
- Write tests for new features
- Ensure all tests pass: `php artisan test`
- Maintain code coverage above 80%

### Commit Messages
```
Format: [TYPE] Brief description

Types:
- feat: New feature
- fix: Bug fix
- docs: Documentation
- style: Code style changes
- refactor: Code refactoring
- test: Test additions/changes
- chore: Dependencies or config

Example:
feat: Add email notifications on onboarding completion
```

### Pull Request Process
1. Create feature branch: `git checkout -b feature/your-feature`
2. Commit changes with clear messages
3. Push to repository: `git push origin feature/your-feature`
4. Create Pull Request with description
5. Address code review comments
6. Merge after approval

---

## 📞 Support

For issues, questions, or suggestions:
- **Email**: support@kld.edu.ph
- **GitHub Issues**: [Report an issue](https://github.com/JamesTamayo-Imben/step22/issues)
- **Documentation**: Check inline code comments and `/docs` folder

---

## 📄 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

---

## 🙏 Acknowledgments

- Built with [Laravel](https://laravel.com) and [React](https://react.dev)
- Styled with [Tailwind CSS](https://tailwindcss.com)
- Powered by [Inertia.js](https://inertiajs.com)
- Authentication via [Supabase](https://supabase.com)
- Developed for Kolehiyo ng Lungsod ng Dasmariñas (KLD)

---

**Last Updated**: April 20, 2026
**Version**: 1.0.0
**Maintainer**: James Tamayo-Imben
