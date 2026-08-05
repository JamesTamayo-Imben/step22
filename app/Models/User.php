<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Relations\BelongsTo;
use Illuminate\Database\Eloquent\Relations\HasOne;
use Illuminate\Database\Eloquent\Relations\HasMany;
use Illuminate\Foundation\Auth\User as Authenticatable;
use Illuminate\Notifications\Notifiable;

class User extends Authenticatable
{
    use HasFactory, Notifiable;

    /**
     * Set to false because users table uses UUID (char 36)
     */
    public $incrementing = false;
    protected $keyType = 'string';

    /**
     * Fillable columns matching your SQL schema exactly.
     * Added: avatar_url, profile_completed, email_verified_at, invitation_token, token_expires_at, is_token_expired
     */
    protected $fillable = [
        'id',
        'role_id',
        'name',
        'email',
        'phone',
        'password',
        'status',
        'last_login_at',
        'archive',
        'avatar_url',
        'profile_completed',
        'email_verified_at',
        'invitation_token',
        'token_expires_at',
        'is_token_expired',
    ];

    protected $hidden = [
        'password',
        'remember_token',
    ];

    /**
     * Casts for data integrity.
     */
    protected function casts(): array
    {
        return [
            'email_verified_at' => 'datetime',
            'password' => 'hashed',
            'last_login_at' => 'datetime',
            'token_expires_at' => 'datetime',
            'archive' => 'boolean',
            'is_token_expired' => 'boolean',
        ];
    }

    /**
     * Relationship to Role
     */
    public function role(): BelongsTo
    {
        return $this->belongsTo(Role::class, 'role_id');
    }

    /**
     * Relationship to Student (student_csg_officers table)
     */
    public function student(): HasOne
    {
        // Use the StudentCsgOfficer model which maps to the
        // `student_csg_officers` table. Some parts of the codebase
        // reference StudentCsgOfficer directly, so ensure the
        // relation points to that model to avoid mismatch.
        return $this->hasOne(\App\Models\StudentCsgOfficer::class, 'user_id');
    }

    /**
     * Relationship to Teacher (teacher_adviser table)
     */
    public function teacher(): HasOne
    {
        return $this->hasOne(Teacher::class, 'user_id');
    }

    public function ratings(): HasMany
    {
        return $this->hasMany(Rating::class, 'user_id', 'id');
    }

    // Role Helper Methods
    public function hasRole(string $roleName): bool
    {
        return $this->role && $this->role->name === $roleName;
    }

    public function hasAnyRole(array $roleNames): bool
    {
        return $this->role && in_array($this->role->name, $roleNames);
    }

    /**
     * Check a module.action permission slug (e.g. projects.create).
     * CSG officers are evaluated against their council position grants.
     */
    public function hasPermission(string $permissionSlug): bool
    {
        return app(\App\Services\RolePermissionService::class)->userCan($this, $permissionSlug);
    }

    /**
     * @return array<int, string>
     */
    public function permissionSlugs(): array
    {
        return app(\App\Services\RolePermissionService::class)->permissionSlugsForUser($this);
    }

    /**
     * Generate a new invitation token (64 character random hash)
     * Valid for 3 days (259200 seconds)
     */
    public function generateInvitationToken(): void
    {
        $this->invitation_token = bin2hex(random_bytes(32)); // 64 character hex string
        $this->token_expires_at = now()->addDays(3);
        $this->is_token_expired = false;
        $this->save();
    }

    /**
     * Check if the invitation token is valid (not expired and not already used)
     */
    public function isTokenValid(): bool
    {
        // Token is invalid if marked as expired
        if ($this->is_token_expired) {
            return false;
        }

        // Token is invalid if no token exists
        if (!$this->invitation_token) {
            return false;
        }

        // Token is invalid if already passed expiry date
        if ($this->token_expires_at && now()->isAfter($this->token_expires_at)) {
            $this->markTokenAsExpired();
            return false;
        }

        return true;
    }

    /**
     * Mark the token as expired (used or timed out)
     */
    public function markTokenAsExpired(): void
    {
        $this->is_token_expired = true;
        $this->invitation_token = null;
        $this->token_expires_at = null;
        $this->save();
    }

    /**
     * Get a user by invitation token if valid
     */
    public static function findByValidToken(string $token): ?User
    {
        $user = static::where('invitation_token', $token)->first();

        if ($user && $user->isTokenValid()) {
            return $user;
        }

        // Mark token as expired if user found but token invalid
        if ($user) {
            $user->markTokenAsExpired();
        }

        return null;
    }
}