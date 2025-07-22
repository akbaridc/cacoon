<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;

class Palka extends Model
{
    use HasFactory;

    protected $table = 'palkas';
    protected $primaryKey = 'pk_id';

    protected $fillable = [
        'pk_id',
        'pk_name',
        'pk_is_active',
    ];

    public function scopeIsActive($query)
    {
        return $query->where('pk_is_active', 1);
    }
}
