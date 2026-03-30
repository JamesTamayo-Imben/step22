<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;

class Approval extends Model
{
    use HasFactory;

    protected $table = 'approval';
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
    ];

    protected $casts = [
        'reviewed_at' => 'datetime',
        'created_at' => 'datetime',
        'updated_at' => 'datetime',
    ];
}
