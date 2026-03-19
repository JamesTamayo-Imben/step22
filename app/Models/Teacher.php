<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\Relations\BelongsTo;
use Illuminate\Database\Eloquent\Relations\HasMany;
use App\Models\Course;

class Teacher extends Model
{
    use HasFactory;

    /**
     * The table associated with the model.
     * Matches your SQL: teacher_adviser
     */
    protected $table = 'teacher_adviser';

    /**
     * The Primary Key is the Employee ID (e.g., "EMP-12345"), which is a string.
     */
    public $incrementing = false;
    protected $keyType = 'string';

    /**
     * Fillable columns matching your SQL schema exactly.
     * Only includes columns that exist in the teacher_adviser table.
     */
    protected $fillable = [
        'id',               // This is the Employee ID (Primary Key)
        'user_id',          // Foreign key to users table
        'permission_id',    // Foreign key to permission table
        'office_location',
        'specialization',
        'is_adviser',
        'archive',
    ];

    /**
     * Casts for data integrity.
     */
    protected $casts = [
        'is_adviser' => 'boolean',
        'archive' => 'boolean',
    ];

    /**
     * Get the core User account associated with this teacher profile.
     */
    public function user(): BelongsTo
    {
        return $this->belongsTo(User::class, 'user_id');
    }

    /**
     * Get the course/department this teacher is associated with.
     */
    public function course(): BelongsTo
    {
        return $this->belongsTo(Course::class, 'course_id');
    }

    /**
     * Get the students assigned to this teacher (if they are an adviser).
     */
    public function students(): HasMany
    {
        // Links teacher_adviser.id to student_csg_officers.adviser_id
        return $this->hasMany(Student::class, 'adviser_id', 'id');
    }
}