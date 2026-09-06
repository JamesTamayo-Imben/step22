<?php

namespace Tests\Feature;

use App\Mail\TamperingDetectedMail;
use App\Models\Role;
use App\Models\User;
use App\Models\User\Project;
use App\Services\TamperingEmailService;
use Illuminate\Support\Facades\Mail;
use Illuminate\Support\Facades\Schema;
use Illuminate\Support\Str;
use Tests\TestCase;

class TamperingEmailServiceTest extends TestCase
{
    public function test_student_project_creator_receives_tampering_email(): void
    {
        $this->ensureRequiredTables();

        $studentRole = Role::query()->firstOrCreate(
            ['slug' => 'student'],
            ['id' => (string) Str::uuid(), 'name' => 'Student', 'archive' => false],
        );

        $adminRole = Role::query()->firstOrCreate(
            ['slug' => 'admin'],
            ['id' => (string) Str::uuid(), 'name' => 'Admin/Adviser', 'archive' => false],
        );

        $student = User::factory()->create([
            'id' => (string) Str::uuid(),
            'role_id' => $studentRole->id,
            'email' => 'student@example.com',
            'archive' => false,
        ]);

        User::factory()->create([
            'id' => (string) Str::uuid(),
            'role_id' => $adminRole->id,
            'email' => 'admin@example.com',
            'archive' => false,
        ]);

        $project = Project::query()->create([
            'id' => (string) Str::uuid(),
            'title' => 'Tampering Test Project',
            'created_by' => $student->id,
            'archive' => false,
        ]);

        Mail::fake();

        app(TamperingEmailService::class)->sendIfNew((string) $project->id, [
            'tamperedBlocks' => [
                ['ledgerId' => 'ledger-1', 'issues' => ['Amount tampered']],
            ],
        ]);

        Mail::assertSent(TamperingDetectedMail::class, function (TamperingDetectedMail $mail) use ($student) {
            return collect($mail->to)->contains(fn ($recipient) => ($recipient['address'] ?? null) === $student->email);
        });
    }

    public function test_student_project_creator_receives_budget_mismatch_email(): void
    {
        $this->ensureRequiredTables();

        $studentRole = Role::query()->firstOrCreate(
            ['slug' => 'student'],
            ['id' => (string) Str::uuid(), 'name' => 'Student', 'archive' => false],
        );

        $student = User::factory()->create([
            'id' => (string) Str::uuid(),
            'role_id' => $studentRole->id,
            'email' => 'student-mismatch@example.com',
            'archive' => false,
        ]);

        $project = Project::query()->create([
            'id' => (string) Str::uuid(),
            'title' => 'Mismatch Test Project',
            'budget' => 100.00,
            'created_by' => $student->id,
            'archive' => false,
        ]);

        Mail::fake();

        app(TamperingEmailService::class)->sendBudgetMismatchIfNew(
            (string) $project->id,
            'Mismatch Test Project',
            100.00,
            175.00,
        );

        Mail::assertSent(TamperingDetectedMail::class, function (TamperingDetectedMail $mail) use ($student) {
            return collect($mail->to)->contains(fn ($recipient) => ($recipient['address'] ?? null) === $student->email);
        });
    }

    private function ensureRequiredTables(): void
    {
        if (! Schema::hasTable('roles')) {
            Schema::create('roles', function ($table) {
                $table->uuid('id')->primary();
                $table->string('name')->nullable();
                $table->string('slug')->nullable();
                $table->text('description')->nullable();
                $table->boolean('archive')->default(false);
                $table->timestamps();
            });
        }

        if (! Schema::hasTable('users')) {
            Schema::create('users', function ($table) {
                $table->uuid('id')->primary();
                $table->uuid('role_id')->nullable();
                $table->string('name')->nullable();
                $table->string('email')->nullable();
                $table->timestamp('email_verified_at')->nullable();
                $table->string('password')->nullable();
                $table->string('remember_token')->nullable();
                $table->string('status')->default('active');
                $table->boolean('archive')->default(false);
                $table->timestamps();
            });
        }

        if (! Schema::hasTable('audit_logs')) {
            Schema::create('audit_logs', function ($table) {
                $table->uuid('id')->primary();
                $table->uuid('user_id')->nullable();
                $table->string('actionable_id')->nullable();
                $table->string('actionable_type')->nullable();
                $table->string('action')->nullable();
                $table->string('module')->nullable();
                $table->string('action_type')->nullable();
                $table->string('status')->nullable();
                $table->text('details')->nullable();
                $table->boolean('archive')->default(false);
                $table->timestamps();
            });
        }

        if (! Schema::hasTable('projects')) {
            Schema::create('projects', function ($table) {
                $table->uuid('id')->primary();
                $table->string('title')->nullable();
                $table->decimal('budget', 15, 2)->nullable();
                $table->uuid('created_by')->nullable();
                $table->boolean('archive')->default(false);
                $table->timestamps();
            });
        }
    }
}
