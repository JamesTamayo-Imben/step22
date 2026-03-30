<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\Relations\HasMany;

class Chain extends Model
{
    protected $table = 'chain';
    protected $primaryKey = 'id';
    public $incrementing = false;
    protected $keyType = 'string';

    protected $fillable = [
        'id',
        'project_id',
        'block_index',
        'prev_hash',
        'hash',
        'data_snapshot',
    ];

    protected $casts = [
        'created_at' => 'datetime',
        'data_snapshot' => 'array',
    ];

    public $timestamps = false;

    public function getCreatedAtColumn()
    {
        return 'created_at';
    }
}
