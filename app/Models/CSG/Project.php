<?php

namespace App\Models\CSG;

use Illuminate\Database\Eloquent\Model;
use Carbon\Carbon;

class Project extends Model
{
    protected $table = 'projects';
    protected $primaryKey = 'id';
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
        'created_at',
        'updated_at',
        'created_by',
        'updated_by',
        'archive',
        'objective', // Add this
        'venue',     // Add this
        'project_proof', // Add this
    ];

    /**
     * Get the computed status based on approval status and dates
     */
    public function getStatusAttribute($value)
    {
        // If not approved, return stored status or 'Draft'
        if ($this->approval_status !== 'Approved') {
            return $value ?: 'Draft';
        }

        $today = Carbon::today();

        // If approved and start_date is today or in the past, it's Ongoing
        if ($this->start_date && Carbon::parse($this->start_date)->lte($today)) {
            // If end_date is yesterday or earlier, it's Complete
            if ($this->end_date && Carbon::parse($this->end_date)->lt($today)) {
                return 'Complete';
            }
            return 'Ongoing';
        }

        // If approved but start_date is in the future, keep as approved status
        return $value ?: 'Approved';
    }
}