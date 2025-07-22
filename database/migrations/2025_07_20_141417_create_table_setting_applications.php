<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

return new class extends Migration
{
    /**
     * Run the migrations.
     */
    public function up(): void
    {
        Schema::create('setting_applications', function (Blueprint $table) {
            $table->id();
            $table->string('application_name')->nullable();
            $table->string('email_send_provider', 50)->nullable();
            $table->string('email_send_password_provider', 50)->nullable();
            $table->string('email_receive_authentication', 50)->nullable();
            $table->timestamps();
        });
    }

    /**
     * Reverse the migrations.
     */
    public function down(): void
    {
        Schema::dropIfExists('setting_applications');
    }
};
