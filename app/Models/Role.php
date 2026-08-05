<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\Relations\BelongsToMany;
use Illuminate\Database\Eloquent\Relations\HasMany;

class Role extends Model
{
    use HasFactory;

    /**
     * The table associated with the model.
     * Matches your SQL: roles
     */
    protected $table = 'roles';

    /**
     * Set to false because we are using UUIDs (char 36), 
     * not auto-incrementing integers.
     */
    public $incrementing = false;

    /**
     * The "type" of the primary key ID.
     */
    protected $keyType = 'string';

    /**
     * The attributes that are mass assignable.
     * CRITICAL: Added 'id' here so UUIDs can be saved.
     */
    protected $fillable = [
        'id',
        'name',
        'slug',
        'description',
        'permission_id',
        'archive',
    ];

    protected $casts = [
        'archive' => 'boolean',
    ];

    /**
     * Get the users associated with this role.
     */
    public function users(): HasMany
    {
        // Links roles.id to users.role_id
        return $this->hasMany(User::class, 'role_id', 'id');
    }

    /**
     * Role-level permissions (role_permission rows with no user_id).
     */
    public function permissions(): BelongsToMany
    {
        return $this->belongsToMany(Permission::class, 'role_permission', 'role_id', 'permission_id')
            ->withPivot('id', 'user_id', 'created_at')
            ->wherePivotNull('user_id');
    }
}