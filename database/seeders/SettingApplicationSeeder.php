<?php

namespace Database\Seeders;

use Illuminate\Database\Console\Seeds\WithoutModelEvents;
use Illuminate\Database\Seeder;
use App\Models\SettingApplication;

class SettingApplicationSeeder extends Seeder
{
    /**
     * Run the database seeds.
     */
    public function run(): void
    {
        SettingApplication::firstOrCreate([
            'application_name' => 'Cacoon',
            'email_send_provider' => 'akbaraisyah000@gmail.com',
            'email_send_password_provider' => 'gtna cxpu tsdo onja',
            'email_receive_authentication' => 'akbarimawan18@gmail.com',
        ]);
    }
}
