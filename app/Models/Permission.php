<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\Relations\BelongsToMany;
use Illuminate\Support\Str;

class Permission extends Model
{
    protected $table = 'permission';

    public $incrementing = false;

    protected $keyType = 'string';

    protected $fillable = [
        'id',
        'module',
        'action',
        'permission',
        'description',
        'archive',
    ];

    protected $casts = [
        'archive' => 'boolean',
    ];

    protected static function booted(): void
    {
        static::creating(function (Permission $permission) {
            if (empty($permission->id)) {
                $permission->id = (string) Str::uuid();
            }
        });
    }

    public function roles(): BelongsToMany
    {
        return $this->belongsToMany(Role::class, 'role_permission', 'permission_id', 'role_id')
            ->withPivot('id', 'user_id', 'created_at');
    }
}
