<?php

namespace App\Providers;

use App\Models\SettingApplication;
use Illuminate\Support\Facades\Schema;
use Illuminate\Support\ServiceProvider;

class AppServiceProvider extends ServiceProvider
{
    /**
     * Register any application services.
     */
    public function register(): void
    {
        //
    }

    /**
     * Bootstrap any application services.
     */
    public function boot(): void
    {
        if (Schema::hasTable('setting_applications')) {
            $appName = SettingApplication::value('application_name');
            config(['app.name' => $appName ?: config('app.name')]);

            $emailSendProvider = SettingApplication::value('email_send_provider');
            config(['mail.mailers.smtp.username' => $emailSendProvider ?: config('mail.mailers.smtp.username')]);

            $emailSendPasswordProvider = SettingApplication::value('email_send_password_provider');
            config(['mail.mailers.smtp.password' => $emailSendPasswordProvider ?: config('mail.mailers.smtp.password')]);
        }
    }
}
