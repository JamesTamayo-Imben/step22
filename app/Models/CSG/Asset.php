<?php

namespace App\Models\CSG;

use Illuminate\Database\Eloquent\Model;
use Illuminate\Support\Str;

class Asset extends Model
{
    protected $table = 'assets';
    protected $keyType = 'string';
    public $incrementing = false;

    protected $fillable = [
        'id',
        'source_ledger_entry_id',
        'project_id',
        'name',
        'asset_category',
        'description',
        'quantity',
        'available_quantity',
        'unit_cost',
        'status',
        'archive',
    ];

    protected $casts = [
        'quantity' => 'integer',
        'available_quantity' => 'integer',
        'unit_cost' => 'decimal:2',
        'archive' => 'integer',
    ];

    protected static function booted(): void
    {
        static::creating(function (Asset $asset): void {
            $asset->id ??= (string) Str::uuid();
        });
    }

    public function sourceLedgerEntry()
    {
        return $this->belongsTo(LedgerEntry::class, 'source_ledger_entry_id');
    }

    public function project()
    {
        return $this->belongsTo(Project::class);
    }

    public function usages()
    {
        return $this->hasMany(AssetUsage::class);
    }
}
