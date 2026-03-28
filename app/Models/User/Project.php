<?php

namespace App\Models\User;

use App\Models\Student;
use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\Relations\BelongsTo;
use Illuminate\Database\Eloquent\Relations\HasMany;

class Project extends Model
{
    use HasFactory;

    protected $table = 'projects';
    public $incrementing = false;
    protected $keyType = 'string';

    protected $fillable = [
        'id',
        'student_id',
        'title',
        'description',
        'category',
        'budget',
        'budget_breakdown',
        'status',
        'proposed_by',
        'note',
        'start_date',
        'end_date',
        'approve_by',
        'approval_status',
        'approved_at',
        'created_by',
        'updated_by',
        'archive',
    ];

    protected $casts = [
        'budget' => 'decimal:2',
        'start_date' => 'date',
        'end_date' => 'date',
        'approved_at' => 'datetime',
        'archive' => 'boolean',
    ];

    public function student(): BelongsTo
    {
        return $this->belongsTo(Student::class, 'student_id', 'id');
    }

    public function ratings(): HasMany
    {
        return $this->hasMany(Rating::class, 'project_id', 'id');
    }

    public function ledgerEntries(): HasMany
    {
        return $this->hasMany(LedgerEntry::class, 'project_id', 'id');
    }
}
