<?php

namespace Tests\Feature;

use App\Http\Controllers\CSG\MeetingController;
use App\Models\CSG\Meeting;
use App\Models\User;
use Illuminate\Http\Request;
use Illuminate\Http\UploadedFile;
use Illuminate\Support\Facades\Schema;
use Illuminate\Support\Facades\Storage;
use Illuminate\Support\Str;
use Tests\TestCase;

class MeetingProofUploadTest extends TestCase
{
    protected function setUp(): void
    {
        parent::setUp();

        if (!Schema::hasTable('users')) {
            Schema::create('users', function ($table) {
                $table->id();
                $table->string('name');
                $table->string('email')->unique();
                $table->string('password');
                $table->timestamps();
            });
        }

        if (!Schema::hasTable('meeting')) {
            Schema::create('meeting', function ($table) {
                $table->string('id')->primary();
                $table->string('student_id')->nullable();
                $table->string('title');
                $table->text('description')->nullable();
                $table->dateTime('scheduled_date');
                $table->boolean('is_done')->default(false);
                $table->text('minutes_content')->nullable();
                $table->text('action_items')->nullable();
                $table->integer('expected_attendees')->default(0);
                $table->json('attendees')->nullable();
                $table->string('meeting_proof')->nullable();
                $table->string('file_content_hash')->nullable();
                $table->boolean('archive')->default(false);
                $table->timestamps();
            });
        }

        if (!Schema::hasTable('audit_logs')) {
            Schema::create('audit_logs', function ($table) {
                $table->string('id')->primary();
                $table->unsignedInteger('user_id')->nullable();
                $table->string('actionable_id')->nullable();
                $table->string('actionable_type')->nullable();
                $table->string('action');
                $table->string('module');
                $table->string('action_type')->nullable();
                $table->string('status')->nullable();
                $table->text('details')->nullable();
                $table->string('ip_address')->nullable();
                $table->text('browser_info')->nullable();
                $table->boolean('archive')->default(false);
                $table->timestamps();
            });
        }
    }

    public function test_store_persists_uploaded_meeting_proof_path_and_hash(): void
    {
        Storage::fake('public');

        $user = User::create([
            'name' => 'Meeting Tester',
            'email' => 'meeting' . Str::random(4) . '@example.com',
            'password' => bcrypt('password'),
        ]);

        $request = Request::create('/api/meetings', 'POST', [
            'title' => 'Weekly Review',
            'description' => 'Upload proof for the weekly review',
            'scheduled_date' => '2026-08-05T10:00',
            'expected_attendees' => 8,
            'attendees' => 'Alice, Bob',
        ]);
        $request->setUserResolver(fn () => $user);
        $request->files->add([
            'meeting_proof' => UploadedFile::fake()->create('proof.pdf', 120, 'application/pdf'),
        ]);

        $response = (new MeetingController())->store($request);

        $this->assertEquals(201, $response->getStatusCode());

        $meeting = Meeting::query()->latest('created_at')->first();
        $this->assertNotNull($meeting);
        $this->assertNotNull($meeting->meeting_proof);
        $this->assertStringContainsString('storage/meeting_proofs/', $meeting->meeting_proof);
        $this->assertNotNull($meeting->file_content_hash);
    }
}
