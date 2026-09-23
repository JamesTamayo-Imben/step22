<?php

namespace App\Http\Controllers\SAdmin;

use App\Http\Controllers\Controller;
use App\Models\Course;
use App\Models\CsgPosition;
use App\Models\Institute;
use Illuminate\Http\Request;
use Illuminate\Support\Str;
use Inertia\Inertia;

class SAdminMasterDataController extends Controller
{
    public function index()
    {
        return Inertia::render('SAdmin/MasterData', [
            'institutes' => Institute::query()
                ->orderBy('archive')
                ->orderBy('name')
                ->get(['id', 'name', 'description', 'archive'])
                ->map(fn ($institute) => [
                    'id' => $institute->id,
                    'name' => $institute->name,
                    'description' => $institute->description,
                    'archive' => (bool) $institute->archive,
                ])
                ->values(),
            'courses' => Course::query()
                ->with('institute:id,name')
                ->orderBy('archive')
                ->orderBy('name')
                ->get(['id', 'name', 'description', 'institute_id', 'archive'])
                ->map(fn ($course) => [
                    'id' => $course->id,
                    'name' => $course->name,
                    'description' => $course->description,
                    'institute_id' => $course->institute_id,
                    'institute_name' => $course->institute?->name,
                    'archive' => (bool) $course->archive,
                ])
                ->values(),
            'positions' => CsgPosition::query()
                ->orderBy('position_name')
                ->get(['id', 'position_name'])
                ->map(fn ($position) => [
                    'id' => $position->id,
                    'name' => $position->position_name,
                    'description' => null,
                ])
                ->values(),
        ]);
    }

    public function storeInstitute(Request $request)
    {
        $validated = $request->validate([
            'name' => ['required', 'string', 'max:255'],
            'description' => ['nullable', 'string'],
        ]);

        $institute = Institute::create([
            'id' => (string) Str::uuid(),
            'name' => trim($validated['name']),
            'description' => $validated['description'] ?? null,
            'archive' => false,
        ]);

        return redirect()->route('sadmin.master-data')->with('success', 'Institute created successfully.');
    }

    public function updateInstitute(Request $request, string $id)
    {
        $validated = $request->validate([
            'name' => ['required', 'string', 'max:255'],
            'description' => ['nullable', 'string'],
        ]);

        $institute = Institute::findOrFail($id);
        $institute->update([
            'name' => trim($validated['name']),
            'description' => $validated['description'] ?? null,
        ]);

        return redirect()->route('sadmin.master-data')->with('success', 'Institute updated successfully.');
    }

    public function destroyInstitute(string $id)
    {
        $institute = Institute::findOrFail($id);
        $institute->update(['archive' => ! $institute->archive]);

        return redirect()->route('sadmin.master-data')->with('success', $institute->archive ? 'Institute restored successfully.' : 'Institute archived successfully.');
    }

    public function storeCourse(Request $request)
    {
        $validated = $request->validate([
            'name' => ['required', 'string', 'max:255'],
            'description' => ['nullable', 'string'],
            'institute_id' => ['nullable', 'string', 'exists:institute,id'],
        ]);

        Course::create([
            'id' => (string) Str::uuid(),
            'institute_id' => $validated['institute_id'] ?? null,
            'name' => trim($validated['name']),
            'description' => $validated['description'] ?? null,
            'archive' => false,
        ]);

        return redirect()->route('sadmin.master-data')->with('success', 'Course created successfully.');
    }

    public function updateCourse(Request $request, string $id)
    {
        $validated = $request->validate([
            'name' => ['required', 'string', 'max:255'],
            'description' => ['nullable', 'string'],
            'institute_id' => ['nullable', 'string', 'exists:institute,id'],
        ]);

        $course = Course::findOrFail($id);
        $course->update([
            'institute_id' => $validated['institute_id'] ?? null,
            'name' => trim($validated['name']),
            'description' => $validated['description'] ?? null,
        ]);

        return redirect()->route('sadmin.master-data')->with('success', 'Course updated successfully.');
    }

    public function destroyCourse(string $id)
    {
        $course = Course::findOrFail($id);
        $course->update(['archive' => ! $course->archive]);

        return redirect()->route('sadmin.master-data')->with('success', $course->archive ? 'Course restored successfully.' : 'Course archived successfully.');
    }

    public function storePosition(Request $request)
    {
        $validated = $request->validate([
            'name' => ['required', 'string', 'max:255'],
        ]);

        CsgPosition::create([
            'id' => str_replace('-', '', (string) Str::uuid()),
            'position_name' => trim($validated['name']),
        ]);

        return redirect()->route('sadmin.master-data')->with('success', 'Position created successfully.');
    }

    public function updatePosition(Request $request, string $id)
    {
        $validated = $request->validate([
            'name' => ['required', 'string', 'max:255'],
        ]);

        $position = CsgPosition::findOrFail($id);
        $position->update(['position_name' => trim($validated['name'])]);

        return redirect()->route('sadmin.master-data')->with('success', 'Position updated successfully.');
    }

    public function destroyPosition(string $id)
    {
        $position = CsgPosition::findOrFail($id);
        $position->delete();

        return redirect()->route('sadmin.master-data')->with('success', 'Position deleted successfully.');
    }
}

