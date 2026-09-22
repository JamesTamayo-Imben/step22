<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\Relations\BelongsTo;

class Course extends Model
{
    use HasFactory;

    protected $table = 'course';

    public $incrementing = false;

    protected $keyType = 'string';

    protected $fillable = ['id', 'institute_id', 'name', 'description', 'archive'];

    public function institute(): BelongsTo
    {
        return $this->belongsTo(Institute::class, 'institute_id', 'id');
    }
}