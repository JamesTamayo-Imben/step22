<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;
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
    ];

    /**
     * Get the users associated with this role.
     */
    public function users(): HasMany
    {
        // Links roles.id to users.role_id
        return $this->hasMany(User::class, 'role_id', 'id');
    }
}