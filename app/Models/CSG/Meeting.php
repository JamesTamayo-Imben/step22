<?php

namespace App\Models\CSG;

use Illuminate\Database\Eloquent\Model;
use Carbon\Carbon;

class Meeting extends Model
{
    protected $table = 'meeting';
    protected $primaryKey = 'id';
    public $incrementing = false;
    protected $keyType = 'string';
    
    protected $fillable = [
        'id',
        'student_id',
        'title',
        'description',
        'scheduled_date',
        'is_done',
        'minutes_content',
        'action_items',
        'expected_attendees',
        'attendees',
        'meeting_proof',
        'archive',
        'created_at',
        'updated_at',
    ];

    protected $casts = [
        'is_done' => 'boolean',
        'archive' => 'boolean',
        'expected_attendees' => 'integer',
        'attendees' => 'json',
        'scheduled_date' => 'datetime',
        'created_at' => 'datetime',
        'updated_at' => 'datetime',
    ];

    /**
     * Get the formatted date for the meeting
     */
    public function getDateAttribute()
    {
        return $this->scheduled_date ? $this->scheduled_date->format('Y-m-d') : null;
    }

    /**
     * Get the formatted time for the meeting
     */
    public function getTimeAttribute()
    {
        return $this->scheduled_date ? $this->scheduled_date->format('h:i A') : null;
    }

    /**
     * Get the meeting status (Scheduled or Completed)
     */
    public function getStatusAttribute()
    {
        return $this->is_done ? 'Completed' : 'Scheduled';
    }

    /**
     * Check if meeting has minutes
     */
    public function getHasMinutesAttribute()
    {
        return !empty($this->meeting_proof);
    }

    /**
     * Get the URL for meeting proof file
     */
    public function getMinutesFileUrlAttribute()
    {
        return $this->meeting_proof ? asset('storage/' . $this->meeting_proof) : null;
    }

    /**
     * Get the file name from meeting proof path
     */
    public function getMinutesFileNameAttribute()
    {
        return $this->meeting_proof ? basename($this->meeting_proof) : null;
    }

    /**
     * Relationship to User (student)
     */
    public function student()
    {
        return $this->belongsTo(\App\Models\User::class, 'student_id', 'id');
    }

    /**
     * Scope to filter active meetings (not archived)
     */
    public function scopeActive($query)
    {
        return $query->where('archive', false);
    }

    /**
     * Scope to filter scheduled meetings
     */
    public function scopeScheduled($query)
    {
        return $query->where('is_done', false);
    }

    /**
     * Scope to filter completed meetings
     */
    public function scopeCompleted($query)
    {
        return $query->where('is_done', true);
    }

    /**
     * Scope to filter archived meetings
     */
    public function scopeArchived($query)
    {
        return $query->where('archive', true);
    }
}
