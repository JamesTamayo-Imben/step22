<?php

namespace App\Models\CSG;

use Illuminate\Database\Eloquent\Model;
use Illuminate\Support\Str;

class Approval extends Model
{
    protected $table = 'approval';
    protected $primaryKey = 'id';
    public $incrementing = false;
    protected $keyType = 'string';

    protected $fillable = [
        'id',
        'employee_id',
        'project_id',
        'reference_type',
        'approvable_type',
        'status',
        'rejection_reason',
        'reviewed_at',
        'officers_approved',
        'created_at',
        'updated_at',
    ];

    protected $casts = [
        'reviewed_at' => 'datetime',
        'officers_approved' => 'array',
        'created_at' => 'datetime',
        'updated_at' => 'datetime',
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
     * Get the project associated with this approval
     */
    public function project()
    {
        return $this->belongsTo(Project::class, 'project_id');
    }

    /**
     * Get the employee (teacher/adviser) associated with this approval
     * Note: employee_id references teachers.employee_id, not teachers.id
     */
    public function employee()
    {
        return $this->belongsTo(\App\Models\Teacher::class, 'employee_id', 'employee_id');
    }
}