<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;

class CsgPosition extends Model
{
    use HasFactory;

    protected $table = 'position';
    protected $keyType = 'string';
    public $incrementing = false;

    protected $fillable = [
        'id',
        'position_name',
    ];
}
