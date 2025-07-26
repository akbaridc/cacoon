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
        'vsl_code',
        'vsl_name',
        'vsl_arrival_type',
        'vsl_survey_draught',
        'vsl_contract_tonnage',
        'vsl_cargo_name',
        'vsl_destination',
        'vsl_est_time_arrival',
        'vsl_time_unberthing'
    ];
}
