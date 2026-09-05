<?php

namespace Tests\Unit;

use App\Http\Controllers\CSG\MeetingController;
use Illuminate\Http\UploadedFile;
use Illuminate\Support\Facades\Storage;
use Tests\TestCase;

class MeetingProofFileStorageTest extends TestCase
{
    public function test_store_meeting_proof_file_returns_hashed_path_and_hash(): void
    {
        Storage::fake('supabase');

        $controller = new MeetingController();
        $method = new \ReflectionMethod($controller, 'storeMeetingProofFile');
        $method->setAccessible(true);

        $file = UploadedFile::fake()->create('proof.pdf', 120, 'application/pdf');

        $result = $method->invoke($controller, $file);

        $this->assertArrayHasKey('path', $result);
        $this->assertArrayHasKey('hash', $result);
        $this->assertStringContainsString('meeting_proofs/', $result['path']);
        $this->assertSame(hash_file('sha256', $file->getRealPath()), $result['hash']);
        Storage::disk('supabase')->assertExists($result['path']);
    }
}
