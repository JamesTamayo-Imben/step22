# Commands Cheat Sheet

## 🚀 Immediate Next Steps

### 1. Run All Migrations
```bash
php artisan migrate
```

This creates:
- ✅ `roles` table
- ✅ `role_user` table  
- ✅ New columns in `users` table

### 2. Seed Roles (Optional but Recommended)
```bash
php artisan db:seed --class=RoleSeeder
```

This creates 4 default roles:
- Student
- Adviser
- CSG Officer
- Superadmin

### 3. Check Database
```bash
# Enter MySQL
mysql -u root -p

# Select database
USE step_database;

# View users table structure
DESCRIBE users;

# View roles table
SELECT * FROM roles;

# View user-role relationships
SELECT * FROM role_user;
```

---

## 📝 Artisan Commands

### View Migration Status
```bash
php artisan migrate:status
```

### Rollback Last Migration
```bash
php artisan migrate:rollback
```

### Rollback All Migrations
```bash
php artisan migrate:reset
```

### Fresh Migration (Reset + Migrate)
```bash
php artisan migrate:fresh
```

### Fresh + Seed
```bash
php artisan migrate:fresh --seed
```

### Show Migration Info
```bash
php artisan migrate:show
```

---

## 🔍 Tinker Commands (Database Testing)

```bash
php artisan tinker
```

Then in tinker:

```php
# View all roles
Role::all();

# Create a new role
Role::create(['name' => 'Manager', 'slug' => 'manager']);

# Find user
$user = User::find(1);

# View user's roles
$user->roles;

# Check if user has role
$user->hasRole('student');

# Assign role to user
$user->roles()->attach(1);

# Remove role from user
$user->roles()->detach(1);

# Replace all roles
$user->roles()->sync([1, 2]);

# Count users with role
Role::find(1)->users()->count();

# Get all students
User::whereHas('roles', fn($q) => $q->where('slug', 'student'))->get();
```

---

## 🛠️ Create RoleSeeder

If you want to use seeders:

```bash
php artisan make:seeder RoleSeeder
```

Then edit `database/seeders/RoleSeeder.php`:

```php
<?php

namespace Database\Seeders;

use App\Models\Role;
use Illuminate\Database\Seeder;

class RoleSeeder extends Seeder
{
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
            'description' => 'System administrator',
        ]);
    }
}
```

Run with:
```bash
php artisan db:seed --class=RoleSeeder
```

---

## 🔄 Update Main DatabaseSeeder

Edit `database/seeders/DatabaseSeeder.php`:

```php
<?php

namespace Database\Seeders;

use Illuminate\Database\Seeder;

class DatabaseSeeder extends Seeder
{
    public function run(): void
    {
        $this->call([
            RoleSeeder::class,
            // Add other seeders here
        ]);
    }
}
```

Then run:
```bash
php artisan db:seed
```

---

## 📊 MySQL Commands

### Connect to MySQL
```bash
mysql -u root -p
# Enter password: (usually blank for XAMPP)
```

### List Databases
```sql
SHOW DATABASES;
```

### Select Database
```sql
USE step_database;
```

### View Tables
```sql
SHOW TABLES;
```

### View Table Structure
```sql
DESCRIBE users;
DESCRIBE roles;
DESCRIBE role_user;
```

### View All Data
```sql
SELECT * FROM users;
SELECT * FROM roles;
SELECT * FROM role_user;
```

### Count Records
```sql
SELECT COUNT(*) FROM users;
SELECT COUNT(*) FROM roles;
```

### View User with Roles
```sql
SELECT u.id, u.name, u.email, r.name as role
FROM users u
LEFT JOIN role_user ru ON u.id = ru.user_id
LEFT JOIN roles r ON ru.role_id = r.id;
```

### View User Details
```sql
SELECT id, name, email, department, year_level, provider 
FROM users 
WHERE id = 1;
```

### Update User Department
```sql
UPDATE users 
SET department = 'Computer Science', year_level = 'Junior'
WHERE id = 1;
```

### Delete All role_user Assignments
```sql
TRUNCATE role_user;
```

### View User Count by Role
```sql
SELECT r.name, COUNT(u.id) as user_count
FROM roles r
LEFT JOIN role_user ru ON r.id = ru.role_id
LEFT JOIN users u ON ru.user_id = u.id
GROUP BY r.id, r.name;
```

---

## 🧪 Testing in Tinker

```bash
php artisan tinker
```

```php
# Create a test user with Google
$user = User::create([
    'name' => 'Test User',
    'email' => 'test@example.com',
    'provider' => 'google',
    'provider_id' => 'google_12345',
    'avatar_url' => 'https://example.com/avatar.jpg',
]);

# Verify user created
$user->fresh();

# Get student role
$studentRole = Role::where('slug', 'student')->first();

# Assign student role
$user->roles()->attach($studentRole);

# Verify role assigned
$user->roles;

# Test helper methods
$user->hasRole('student');      // true
$user->hasRole('adviser');      // false
$user->hasAnyRole(['student', 'adviser']); // true

# Update user profile
$user->update([
    'department' => 'Computer Science',
    'year_level' => 'Junior',
    'password' => Hash::make('password123'),
]);

# Verify updates
$user->fresh();
```

---

## 🐛 Debugging Commands

### Check Laravel Version
```bash
php artisan --version
```

### Check Database Connection
```bash
php artisan tinker
# Then: DB::connection()->getPdo();
```

### View Current Configuration
```bash
php artisan config:show database
```

### Clear Application Cache
```bash
php artisan cache:clear
```

### Clear Configuration Cache
```bash
php artisan config:clear
```

### View All Routes
```bash
php artisan route:list
```

### View Migration History
```bash
php artisan migrate:status
```

---

## 📋 Common Workflows

### Workflow 1: Fresh Start
```bash
php artisan migrate:fresh
php artisan db:seed --class=RoleSeeder
```

### Workflow 2: Create New User and Assign Role
```bash
php artisan tinker

$user = User::create([
    'name' => 'John Doe',
    'email' => 'john@example.com',
    'provider' => 'google',
    'provider_id' => 'google_123',
    'avatar_url' => 'https://...',
]);

$user->roles()->attach(Role::where('slug', 'student')->first());

$user->update([
    'department' => 'Computer Science',
    'year_level' => 'Junior',
]);
```

### Workflow 3: Add New Role
```bash
php artisan tinker

Role::create([
    'name' => 'Manager',
    'slug' => 'manager',
    'description' => 'Project Manager',
]);
```

### Workflow 4: Check User's Permissions
```bash
php artisan tinker

$user = User::find(1);
$user->roles;                    // View all roles
$user->hasRole('student');       // Check specific role
$user->hasAnyRole(['student', 'adviser']); // Check multiple
```

---

## 🔐 Important Notes

- ⚠️ **Do NOT** run `migrate:reset` or `migrate:fresh` on production!
- ⚠️ Always backup your database before major changes
- ✅ Always test migrations on local first
- ✅ Use seeders for test data, not production data
- ✅ Keep migrations in version control

---

## ✅ Troubleshooting

### Migration fails: "Base table already exists"
```bash
php artisan migrate:fresh
```

### Can't connect to database
Check `.env` file:
```
DB_CONNECTION=mysql
DB_HOST=127.0.0.1
DB_PORT=3306
DB_DATABASE=step_database
DB_USERNAME=root
DB_PASSWORD=
```

### Role not found in seeder
```bash
# Delete migrations and start fresh
php artisan migrate:reset
php artisan migrate
php artisan db:seed
```

### User-role relationship not working
```bash
php artisan tinker
# Check if migration ran: Role::count();
# Check if roles exist: Role::all();
```

---

Ready to go! Start with:

```bash
php artisan migrate
```

Then:

```bash
php artisan db:seed --class=RoleSeeder
```

Done! 🎉
