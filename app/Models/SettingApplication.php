<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;

class SettingApplication extends Model
{
    use HasFactory;

    protected $table = 'setting_applications';

    protected $fillable = [
        'application_name',
        'email_send_provider',
        'email_send_password_provider',
        'email_receive_authentication',
    ];
}
