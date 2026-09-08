<?php

namespace App\Http\Controllers\CSG;

use App\Http\Controllers\Controller;
use App\Models\CSG\Meeting;
use App\Models\AuditLog;
use App\Models\User;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Auth;
use Illuminate\Support\Str;

class MeetingController extends Controller
{
    /**
     * Get all meetings
     */
    public function all(Request $request)
    {
        try {
            $query = Meeting::where('archive', false);

            // Optional filters
            if ($request->filled('student_id')) {
                $query->where('student_id', $request->input('student_id'));
            }

            if ($request->filled('is_done')) {
                $query->where('is_done', $request->input('is_done'));
            }

            if ($request->filled('archive')) {
                $query->where('archive', $request->input('archive'));
            }

            $meetings = $query->orderBy('scheduled_date', 'desc')->get();

            // Map meetings to include formatted data using model accessors
            $processedMeetings = $meetings->map(function($meeting) {
                return [
                    'id' => $meeting->id,
                    'student_id' => $meeting->student_id,
                    'title' => $meeting->title,
                    'description' => $meeting->description,
                    'scheduled_date' => $meeting->scheduled_date,
                    'created_at' => $meeting->created_at,
                    'is_done' => $meeting->is_done,
                    'minutes_content' => $meeting->minutes_content,
                    'minutes_file_url' => $meeting->minutes_file_url,
                    'minutes_file_name' => $meeting->minutes_file_name,
                    'expected_attendees' => $meeting->expected_attendees ?? 0,
                    'attendees' => $meeting->attendees ?? [],
                    'meeting_proof' => $meeting->meeting_proof,
                    'updated_at' => $meeting->updated_at,
                    'archive' => $meeting->archive,
                    'status' => $meeting->status,
                    'date' => $meeting->date,
                    'time' => $meeting->time,
                    'hasMinutes' => $meeting->has_minutes,
                ];
            });

            return response()->json($processedMeetings);
        } catch (\Exception $e) {
            return response()->json([
                'message' => 'Failed to fetch meetings',
            ], 500);
        }
    }

    private function getMeetingNotificationRecipients(?string $studentId, ?string $fallbackUserId = null): array
    {
        $recipientUserIds = [];

        $studentUser = null;
        $studentProfile = null;

        if ($studentId) {
            $studentProfile = \App\Models\Student::where('id', $studentId)->where('archive', false)->first();

            if ($studentProfile && $studentProfile->user_id) {
                $studentUser = User::find($studentProfile->user_id);
            }

            if (!$studentUser) {
                $studentUser = User::find($studentId);
            }

            if (!$studentUser) {
                $studentProfile = \App\Models\Student::where('user_id', $studentId)->where('archive', false)->first();
                if ($studentProfile && $studentProfile->user_id) {
                    $studentUser = User::find($studentProfile->user_id);
                }
            }
        }

        if (!$studentUser && $fallbackUserId) {
            $studentUser = User::find($fallbackUserId);
        }

        if ($studentUser) {
            $recipientUserIds[] = $studentUser->id;

            $studentProfile = $studentProfile ?: \App\Models\Student::where('user_id', $studentUser->id)->where('archive', false)->first();
            $teacherUserId = $studentProfile?->adviser?->user_id;

            if ($teacherUserId && !in_array($teacherUserId, $recipientUserIds, true)) {
                $recipientUserIds[] = $teacherUserId;
            }
        }

        if (empty($recipientUserIds) && $fallbackUserId) {
            $recipientUserIds[] = $fallbackUserId;
        }

        return array_values(array_unique($recipientUserIds));
    }

    /**
     * Store a new meeting
     */
    public function store(Request $request)
    {
        try {
            if (!Auth::user()?->hasPermission('meetings.create')) {
                return response()->json([
                    'message' => 'You do not have permission to create meetings.',
                ], 403);
            }

            $validated = $request->validate([
                'student_id' => 'nullable|string',
                'title' => 'required|string|max:255',
                'description' => 'nullable|string',
                'scheduled_date' => 'required|date_format:Y-m-d\TH:i',
                'expected_attendees' => 'nullable|integer|min:0',
                'attendees' => 'nullable|string', // Accept as string
                'meeting_proof' => 'nullable|file|mimes:pdf,jpg,jpeg,png,doc,docx|max:10240',
            ]);

            // Handle file upload
            $meeting_proof = null;
            $meetingProofHash = null;
            if ($request->hasFile('meeting_proof')) {
                $file = $request->file('meeting_proof');
                $uploadedProof = $this->storeMeetingProofFile($file);
                $meeting_proof = $uploadedProof['path'];
                $meetingProofHash = $uploadedProof['hash'];
            }

            // Handle attendees properly - convert comma-separated string to array for JSON storage
            $attendeesArray = [];
            if ($request->has('attendees') && !empty($request->input('attendees'))) {
                $attendeesString = $request->input('attendees');
                $attendeesArray = array_map('trim', explode(',', $attendeesString));
                $attendeesArray = array_filter($attendeesArray);
            }

            $meeting = Meeting::create([
                'id' => Str::uuid()->toString(),
                'student_id' => $request->input('student_id'),
                'title' => $request->input('title'),
                'description' => $request->input('description'),
                'scheduled_date' => $request->input('scheduled_date'),
                'expected_attendees' => $request->input('expected_attendees'),
                'attendees' => $attendeesArray,
                'meeting_proof' => $meeting_proof,
                'file_content_hash' => $meetingProofHash,
                'is_done' => false,
                'archive' => false,
            ]);

            AuditLog::create([
                'id' => (string) Str::uuid(),
                'user_id' => Auth::id(),
                'actionable_id' => $meeting->id,
                'actionable_type' => 'meeting',
                'action' => 'Meeting Created',
                'module' => 'meetings',
                'action_type' => 'create',
                'status' => 'Success',
                'details' => 'Created meeting "' . ($meeting->title ?? $meeting->id) . '"',
                'ip_address' => request()->ip(),
                'browser_info' => substr((string) request()->userAgent(), 0, 500),
                'archive' => 0,
            ]);

            $meetingDateFormatted = date('F j, Y, g:i A', strtotime($meeting->scheduled_date));
            $this->createNotification(
                'New Meeting Scheduled',
                "A new meeting titled '{$meeting->title}' has been scheduled for {$meetingDateFormatted}",
                'meeting',
                null
            );

            return response()->json([
                'message' => 'Meeting created successfully',
                'id' => $meeting->id,
            ], 201);
        } catch (\Exception $e) {
            return response()->json([
                'message' => 'Failed to create meeting',
            ], 500);
        }
    }

    /**
     * Update a meeting
     */
  // In MeetingController.php - update method
public function update(Request $request, $id)
{
    try {
        $meeting = Meeting::findOrFail($id);

        $validated = $request->validate([
            'title' => 'required|string|max:255',
            'description' => 'required|string',
            'scheduled_date' => 'required|date_format:Y-m-d\TH:i',
            'expected_attendees' => 'required|integer|min:0',
            'attendees' => 'required|string', // Accept as string
            'is_done' => 'nullable|boolean',
            'minutes_content' => 'nullable|string',
            'meeting_proof' => 'nullable|file|mimes:pdf,jpg,jpeg,png,doc,docx|max:10240',
            'proof' => 'nullable|file|mimes:pdf,jpg,jpeg,png|max:10240',
        ]);

        $updateData = [
            'title' => $request->input('title'),
            'description' => $request->input('description'),
            'scheduled_date' => $request->input('scheduled_date'),
            'expected_attendees' => $request->input('expected_attendees'),
            'is_done' => $request->input('is_done') ? true : false,
            'minutes_content' => $request->input('minutes_content'),
        ];

        $meetingProofHash = $meeting->file_content_hash;
        if (! $meeting->meeting_proof && ! $request->hasFile('meeting_proof') && ! $request->hasFile('proof')) {
            return response()->json([
                'message' => 'A meeting proof or minutes file is required.',
            ], 422);
        }

        // Handle attendees properly - convert comma-separated string to array for JSON storage
        if ($request->has('attendees') && !empty($request->input('attendees'))) {
            $attendeesString = $request->input('attendees');
            // Split by comma and trim each attendee name
            $attendeesArray = array_map('trim', explode(',', $attendeesString));
            // Remove empty values
            $attendeesArray = array_filter($attendeesArray);
            $updateData['attendees'] = $attendeesArray;
        } elseif ($request->has('attendees') && $request->input('attendees') === '') {
            $updateData['attendees'] = [];
        }

        // Handle proof file upload
        if ($request->hasFile('proof')) {
            $file = $request->file('proof');
            $uploadedProof = $this->storeMeetingProofFile($file);
            $updateData['meeting_proof'] = $uploadedProof['path'];
            $meetingProofHash = $uploadedProof['hash'];
        } elseif ($request->hasFile('meeting_proof')) {
            $file = $request->file('meeting_proof');
            $uploadedProof = $this->storeMeetingProofFile($file);
            $updateData['meeting_proof'] = $uploadedProof['path'];
            $meetingProofHash = $uploadedProof['hash'];
        }

        if ($meetingProofHash) {
            $updateData['file_content_hash'] = $meetingProofHash;
        }

        $meeting->update($updateData);

        AuditLog::create([
            'id' => (string) Str::uuid(),
            'user_id' => Auth::id(),
            'actionable_id' => $meeting->id,
            'actionable_type' => 'meeting',
            'action' => 'Meeting Updated',
            'module' => 'meetings',
            'action_type' => 'update',
            'status' => 'Success',
            'details' => 'Updated meeting "' . ($meeting->title ?? $meeting->id) . '"',
            'ip_address' => request()->ip(),
            'browser_info' => substr((string) request()->userAgent(), 0, 500),
            'archive' => 0,
        ]);

        $meetingDateFormatted = date('F j, Y, g:i A', strtotime($meeting->scheduled_date));
        $this->createNotification(
            'Meeting Updated',
            "The meeting titled '{$meeting->title}' was updated for {$meetingDateFormatted}",
            'meeting',
            null
        );

        return response()->json(['message' => 'Meeting updated successfully']);
    } catch (\Exception $e) {
        return response()->json([
            'message' => 'Failed to update meeting',
        ], 500);
    }
}

    private function storeMeetingProofFile($file): array
    {
        $fileHash = hash_file('sha256', $file->getRealPath());
        $extension = $file->getClientOriginalExtension();
        $fileName = $fileHash . ($extension ? '.' . $extension : '');
        $filePath = $file->storeAs('meeting_proofs', $fileName, 'supabase');

        return [
            'path' => $filePath,
            'hash' => $fileHash,
        ];
    }

    /**
     * Delete a meeting (soft delete via archive)
     */
    public function destroy($id)
    {
        try {
            $meeting = Meeting::findOrFail($id);
            $meeting->archive = true;
            $meeting->updated_at = now();
            $meeting->save();

            AuditLog::create([
                'id' => (string) Str::uuid(),
                'user_id' => Auth::id(),
                'actionable_id' => $meeting->id,
                'actionable_type' => 'meeting',
                'action' => 'Meeting Archived',
                'module' => 'meetings',
                'action_type' => 'archive',
                'status' => 'Success',
                'details' => 'Archived meeting "' . ($meeting->title ?? $meeting->id) . '"',
                'ip_address' => request()->ip(),
                'browser_info' => substr((string) request()->userAgent(), 0, 500),
                'archive' => 0,
            ]);

            return response()->json(['message' => 'Meeting archived successfully']);
        } catch (\Exception $e) {
            return response()->json([
                'message' => 'Failed to delete meeting',
            ], 500);
        }
    }

    /**
     * Toggle archive status
     */
    public function toggleArchive($id)
    {
        try {
            $meeting = Meeting::findOrFail($id);
            $meeting->archive = !$meeting->archive;
            $meeting->save();

            $action = $meeting->archive ? 'Meeting Archived' : 'Meeting Unarchived';
            $actionType = $meeting->archive ? 'archive' : 'restore';

            AuditLog::create([
                'id' => (string) Str::uuid(),
                'user_id' => Auth::id(),
                'actionable_id' => $meeting->id,
                'actionable_type' => 'meeting',
                'action' => $action,
                'module' => 'meetings',
                'action_type' => $actionType,
                'status' => 'Success',
                'details' => $action . ' for "' . ($meeting->title ?? $meeting->id) . '"',
                'ip_address' => request()->ip(),
                'browser_info' => substr((string) request()->userAgent(), 0, 500),
                'archive' => 0,
            ]);

            return response()->json(['message' => 'Meeting archive status updated']);
        } catch (\Exception $e) {
            return response()->json([
                'message' => 'Failed to update meeting',
            ], 500);
        }
    }

    /**
     * Mark meeting as done
     */
    public function markAsDone($id, Request $request)
    {
        try {
            $meeting = Meeting::findOrFail($id);

            $updateData = [
                'is_done' => true,
            ];

            // Handle file upload for minutes
            if ($request->hasFile('minutes_content')) {
                $file = $request->file('minutes_content');
                $uploadedProof = $this->storeMeetingProofFile($file);
                $updateData['meeting_proof'] = $uploadedProof['path'];
                $updateData['file_content_hash'] = $uploadedProof['hash'];
            } elseif ($request->input('minutes_content')) {
                $updateData['minutes_content'] = $request->input('minutes_content');
            }

            if ($request->input('attendees')) {
                $updateData['attendees'] = $request->input('attendees');
            }

            $meeting->update($updateData);

            AuditLog::create([
                'id' => (string) Str::uuid(),
                'user_id' => Auth::id(),
                'actionable_id' => $meeting->id,
                'actionable_type' => 'meeting',
                'action' => 'Meeting Marked Completed',
                'module' => 'meetings',
                'action_type' => 'update',
                'status' => 'Success',
                'details' => 'Marked meeting as completed "' . ($meeting->title ?? $meeting->id) . '"',
                'ip_address' => request()->ip(),
                'browser_info' => substr((string) request()->userAgent(), 0, 500),
                'archive' => 0,
            ]);

            return response()->json(['message' => 'Meeting marked as completed']);
        } catch (\Exception $e) {
            return response()->json([
                'message' => 'Failed to mark meeting as done',
            ], 500);
        }
    }

    /**
     * Get count of upcoming meetings
     * Meetings with scheduled_date >= now and is_done = false
     */
    public function countUpcoming()
    {
        try {
            $count = Meeting::countUpcoming();
            
            return response()->json([
                'upcoming_count' => $count,
                'message' => "You have {$count} upcoming meetings",
            ], 200);
        } catch (\Exception $e) {
            return response()->json([
                'message' => 'Failed to count upcoming meetings',
            ], 500);
        }
    }

    /**
     * Get all upcoming meetings
     * Meetings with scheduled_date >= now and is_done = false
     */
    public function getUpcomingMeetings()
    {
        try {
            $meetings = Meeting::getUpcoming();
            
            $processedMeetings = $meetings->map(function($meeting) {
                return [
                    'id' => $meeting->id,
                    'student_id' => $meeting->student_id,
                    'title' => $meeting->title,
                    'description' => $meeting->description,
                    'scheduled_date' => $meeting->scheduled_date,
                    'created_at' => $meeting->created_at,
                    'is_done' => $meeting->is_done,
                    'expected_attendees' => $meeting->expected_attendees ?? 0,
                    'attendees' => $meeting->attendees ?? [],
                    'status' => $meeting->status,
                    'date' => $meeting->date,
                    'time' => $meeting->time,
                ];
            });
            
            return response()->json([
                'upcoming_meetings' => $processedMeetings,
                'count' => $processedMeetings->count(),
            ], 200);
        } catch (\Exception $e) {
            return response()->json([
                'message' => 'Failed to fetch upcoming meetings',
            ], 500);
        }
    }
}