<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;

class AuditLog extends Model
{
    public $incrementing = false;

    protected $keyType = 'string';

    protected $table = 'audit_logs';

    const UPDATED_AT = null;

    protected $fillable = [
        'id',
        'user_id',
        'actionable_id',
        'actionable_type',
        'action',
        'module',
        'action_type',
        'status',
        'details',
        'ip_address',
        'browser_info',
        'archive',
    ];

    protected $casts = [
        'archive' => 'boolean',
        'created_at' => 'datetime',
    ];

    public function user()
    {
        return $this->belongsTo(User::class, 'user_id', 'id');
    }
}
