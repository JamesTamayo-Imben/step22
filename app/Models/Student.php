<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\Relations\BelongsTo;

class Student extends Model
{
    use HasFactory;

    /**
     * The table associated with the model.
     * Aligned with your SQL: student_csg_officers
     */
    protected $table = 'student_csg_officers';

    /**
     * The Primary Key is the Student ID (e.g., "2024-0001"), which is a string.
     */
    public $incrementing = false;
    protected $keyType = 'string';

    /**
     * Fillable columns matching your SQL schema exactly.
     * Removed: year_level, course (string), department, gpa, enrollment_date, etc.
     */
    protected $fillable = [
        'id',               // The actual Student ID (Primary Key)
        'user_id',          // Foreign key to users table
        'adviser_id',       // Foreign key to teacher_adviser table
        'is_csg',
        'csg_position',
        'csg_term_start',
        'csg_term_end',
        'csg_is_active',
        'archive',
    ];

    /**
     * Casts for data integrity.
     */
    protected $casts = [
        'is_csg' => 'boolean',
        'csg_is_active' => 'boolean',
        'archive' => 'boolean',
        'csg_term_start' => 'date',
        'csg_term_end' => 'date',
    ];

    /**
     * Get the core User account associated with this student profile.
     */
    public function user(): BelongsTo
    {
        return $this->belongsTo(User::class, 'user_id');
    }

    /**
     * Get the Teacher/Adviser assigned to this student.
     * Links to the 'id' column in the teacher_adviser table.
     */
    public function adviser(): BelongsTo
    {
        return $this->belongsTo(Teacher::class, 'adviser_id');
    }

}