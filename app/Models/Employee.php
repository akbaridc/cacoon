<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;

class Employee extends Model
{
    use HasFactory;

    /**
     * The attributes that are mass assignable.
     *
     * @var array<int, string>
     */
    protected $fillable = [
        'nik',
        'name',
        'emp_type',
        'work_unit_id',
        'work_unit_name',
        'parent_work_unit',
        'position_grade',
        'job_grade',
        'job_id',
        'job_title',
        'direct_superior',
        'division_id',
        'position_title',
        'photo',
        'department_id',
        'department',
        'department_name',
        'company_id',
        'company_name',
        'directorate_id',
        'directorate_name',
    ];

    /**
     * Get the user associated with the employee.
     */
    public function user()
    {
        return $this->belongsTo(User::class, 'nik', 'nik');
    }
}
