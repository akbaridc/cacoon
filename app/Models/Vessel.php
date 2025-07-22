<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;

class Vessel extends Model
{
    use HasFactory;

    protected $table = 'vessels';
    protected $primaryKey = 'vsl_id';

    protected $fillable = [
        'vsl_id',
        'vsl_orgn_id',
        'vsl_code',
        'vsl_name',
        'vsl_type',
        'vsl_origin_location',
        'vsl_origin_destination',
        'vsl_arrival_type',
        'vsl_bl_tonnage',
        'vsl_contract_tonnage'
    ];
}
