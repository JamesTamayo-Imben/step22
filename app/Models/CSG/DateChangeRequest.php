<?php

namespace App\Models\CSG;

use Illuminate\Database\Eloquent\Model;
use Illuminate\Support\Str;

class DateChangeRequest extends Model
{
    protected $table = 'date_change_requests';
    protected $primaryKey = 'id';
    public $incrementing = false;
    protected $keyType = 'string';

    protected $fillable = [
        'id',
        'project_id',
        'requested_by',
        'current_start_date',
        'current_end_date',
        'proposed_start_date',
        'proposed_end_date',
        'reason',
        'status',
        'reviewed_by',
        'reviewed_at',
        'rejection_reason',
        'created_at',
        'updated_at',
    ];

    protected $casts = [
        'created_at' => 'datetime',
        'updated_at' => 'datetime',
        'reviewed_at' => 'datetime',
    ];

    /**
     * Boot the model
     */
    protected static function boot()
    {
        parent::boot();

        static::creating(function ($model) {
            if (empty($model->id)) {
                $model->id = Str::uuid()->toString();
            }
        });
    }

    /**
     * Get the project that owns this change request
     */
    public function project()
    {
        return $this->belongsTo(Project::class);
    }

    /**
     * Get the user who requested the change
     */
    public function requestedByUser()
    {
        return $this->belongsTo(\App\Models\User::class, 'requested_by');
    }

    /**
     * Get the user who reviewed the change
     */
    public function reviewedByUser()
    {
        return $this->belongsTo(\App\Models\User::class, 'reviewed_by');
    }
}
