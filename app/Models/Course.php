<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;

class Course extends Model
{
    use HasFactory;

    protected $table = 'course'; // Matches your SQL table name

    // Since your SQL shows ID is NOT a UUID (it's likely an auto-increment or int)
    // If it's a string ID, set $incrementing to false.
    protected $fillable = ['id', 'institute_id', 'name', 'description', 'archive'];
}