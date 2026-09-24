<?php

namespace App\Models\CSG;

use Illuminate\Database\Eloquent\Model;
use Illuminate\Support\Str;

class AssetUsage extends Model
{
    protected $table = 'asset_usages';
    protected $keyType = 'string';
    public $incrementing = false;

    protected $fillable = [
        'id',
        'asset_id',
        'project_id',
        'ledger_entry_id',
        'quantity',
        'status',
        'assigned_at',
        'returned_quantity',
        'returned_at',
        'returned_by',
    ];

    protected static function booted(): void
    {
        static::creating(function (AssetUsage $usage): void {
            $usage->id ??= (string) Str::uuid();
        });
    }

    protected $casts = [
        'returned_quantity' => 'integer',
        'returned_at' => 'datetime',
        'assigned_at' => 'datetime',
    ];

    public function asset()
    {
        return $this->belongsTo(Asset::class);
    }

    public function ledgerEntry()
    {
        return $this->belongsTo(LedgerEntry::class);
    }

    public function project()
    {
        return $this->belongsTo(Project::class);
    }
}
