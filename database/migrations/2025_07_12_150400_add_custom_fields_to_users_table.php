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
        Schema::table('users', function (Blueprint $table) {
            $table->string('avatar')->nullable()->after('email_verified_at');
            $table->string('nik')->unique()->nullable()->after('email');
            $table->text('token')->nullable()->after('password');
            $table->string('token_text')->nullable()->after('token');
            $table->boolean('is_active')->default(true)->after('token_text');
            $table->timestamp('token_expires_at')->nullable()->after('is_active');
            $table->boolean('is_organic')->default(true)->after('token_expires_at');
        });
    }

    /**
     * Reverse the migrations.
     */
    public function down(): void
    {
        Schema::table('users', function (Blueprint $table) {
            $table->dropColumn(['avatar', 'nik', 'token_text', 'token', 'is_active', 'token_expires_at', 'is_organic']);
        });
    }
};
