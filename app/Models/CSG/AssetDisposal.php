<?php

namespace App\Models\CSG;

use App\Models\User;
use Illuminate\Database\Eloquent\Model;
use Illuminate\Support\Str;

class AssetDisposal extends Model
{
    protected $table = 'asset_disposals';

    protected $keyType = 'string';

    public $incrementing = false;

    protected $fillable = [
        'id',
        'asset_id',
        'source_ledger_entry_id',
        'asset_name',
        'asset_category',
        'project_name',
        'quantity',
        'reason',
        'disposed_by',
    ];

    protected $casts = [
        'quantity' => 'integer',
    ];

    protected static function booted(): void
    {
        static::creating(function (AssetDisposal $disposal): void {
            $disposal->id ??= (string) Str::uuid();
        });
    }

    public function user()
    {
        return $this->belongsTo(User::class, 'disposed_by');
    }
}