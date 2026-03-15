# Database Setup Quick Start

## Step 1: Run Migrations

```bash
php artisan migrate
```

This will create:
- ✅ `roles` table
- ✅ `role_user` table (pivot/junction table)
- ✅ Add columns to `users` table: `department`, `year_level`, `bio`, `provider`, `provider_id`, `avatar_url`, `last_login_at`, `is_active`

---

## Step 2: Seed Initial Roles (Optional)

Create this file: `database/seeders/RoleSeeder.php`

```php
<?php

namespace Database\Seeders;

use App\Models\Role;
use Illuminate\Database\Seeder;

class RoleSeeder extends Seeder
{
    /**
     * Run the database seeds.
     */
    public function run(): void
    {
        Role::create([
            'name' => 'Student',
            'slug' => 'student',
            'description' => 'Regular student user',
        ]);

        Role::create([
            'name' => 'Adviser',
            'slug' => 'adviser',
            'description' => 'Faculty adviser or counselor',
        ]);

        Role::create([
            'name' => 'CSG Officer',
            'slug' => 'csg_officer',
            'description' => 'CSG Leadership Officer',
        ]);

        Role::create([
            'name' => 'Superadmin',
            'slug' => 'superadmin',
            'description' => 'System administrator with full access',
        ]);
    }
}
```

Then run:
```bash
php artisan db:seed --class=RoleSeeder
```

Or add to `database/seeders/DatabaseSeeder.php`:

```php
public function run(): void
{
    $this->call([
        RoleSeeder::class,
    ]);
}
```

Then run:
```bash
php artisan db:seed
```

---

## Step 3: Example Usage in Controllers

### Assign Role to User
```php
use App\Models\User;
use App\Models\Role;

$user = User::find(1);
$studentRole = Role::where('slug', 'student')->first();

// Assign single role
$user->roles()->attach($studentRole);

// Or sync (replaces all roles)
$user->roles()->sync([$studentRole->id]);

// Assign multiple roles
$user->roles()->sync([
    Role::where('slug', 'student')->first()->id,
    Role::where('slug', 'csg_officer')->first()->id,
]);
```

### Check User Role
```php
$user = auth()->user();

// Check if has specific role
if ($user->hasRole('student')) {
    // Show student dashboard
}

// Check if has any of multiple roles
if ($user->hasAnyRole(['adviser', 'csg_officer', 'superadmin'])) {
    // Show management features
}

// Get all roles
$roles = $user->roles;
foreach ($roles as $role) {
    echo $role->name;
}
```

---

## Step 4: Protect Routes by Role

Create middleware: `app/Http/Middleware/CheckRole.php`

```php
<?php

namespace App\Http\Middleware;

use Closure;
use Illuminate\Http\Request;

class CheckRole
{
    public function handle(Request $request, Closure $next, string ...$roles)
    {
        if (!auth()->check()) {
            return redirect('/login');
        }

        if (!auth()->user()->hasAnyRole($roles)) {
            abort(403, 'Unauthorized');
        }

        return $next($request);
    }
}
```

Register in `bootstrap/app.php`:

```php
->withMiddleware(function (Middleware $middleware) {
    $middleware->alias([
        'role' => \App\Http\Middleware\CheckRole::class,
    ]);
})
```

Use in routes:

```php
// routes/web.php
Route::middleware(['auth', 'role:adviser,superadmin'])->group(function () {
    Route::get('/dashboard/adviser', [AdviserController::class, 'dashboard']);
    Route::post('/approvals', [ApprovalController::class, 'store']);
});
```

---

## Step 5: OAuth Google Callback

Update your OAuth controller to create/update users with the new fields:

```php
<?php

namespace App\Http\Controllers;

use App\Models\User;
use App\Models\Role;
use Illuminate\Support\Facades\Auth;

class OAuthCallbackController extends Controller
{
    public function handleGoogleCallback($user)
    {
        // Create or update user
        $dbUser = User::updateOrCreate(
            ['email' => $user->email],
            [
                'name' => $user->name,
                'provider' => 'google',
                'provider_id' => $user->id,
                'avatar_url' => $user->avatar,
                'last_login_at' => now(),
            ]
        );

        // If newly created, redirect to complete profile
        if ($dbUser->wasRecentlyCreated && !$dbUser->department) {
            Auth::login($dbUser);
            return redirect('/complete-profile');
        }

        // Assign student role if no roles assigned
        if ($dbUser->roles()->doesntExist()) {
            $studentRole = Role::where('slug', 'student')->first();
            if ($studentRole) {
                $dbUser->roles()->attach($studentRole);
            }
        }

        Auth::login($dbUser);
        return redirect('/dashboard');
    }
}
```

---

## Database Schema Summary

### users table
```
id (PK)
name
email (UNIQUE)
password (nullable)
department
year_level
bio
provider
provider_id (UNIQUE, nullable)
avatar_url
last_login_at
is_active
email_verified_at
remember_token
created_at
updated_at
```

### roles table
```
id (PK)
name (UNIQUE)
slug (UNIQUE)
description
created_at
updated_at
```

### role_user table (Pivot)
```
id (PK)
user_id (FK → users.id)
role_id (FK → roles.id)
UNIQUE(user_id, role_id)
created_at
updated_at
```

---

## Troubleshooting

### Migration fails with "Column doesn't exist"
Make sure you ran all migrations in order. The `add_profile_fields_to_users_table` migration must run AFTER `create_users_table`.

### hasRole() returns false
Check that the role exists and has the correct `slug`:
```php
Role::all(); // view all roles
```

### Can't assign role
Make sure user exists:
```php
$user = User::find(1);
if (!$user) {
    abort(404, 'User not found');
}
```

---

## Next Steps

1. ✅ Run `php artisan migrate`
2. ✅ Create RoleSeeder and run `php artisan db:seed --class=RoleSeeder`
3. ✅ Update OAuth callback to create users with new fields
4. ✅ Create profile completion page for Google OAuth users
5. ✅ Add role-based middleware to protect routes
6. ✅ Update frontend to display user department/year level

See `DATABASE_ARCHITECTURE.md` for more details!
