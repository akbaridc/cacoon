<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

return new class extends Migration
{
    public function up(): void
    {
        Schema::create('vessel_posts', function (Blueprint $table) {
            $table->id('vp_id');
            $table->foreignId('vp_user_id')->constrained('users', 'id')->onDelete('cascade');
            $table->string('vp_vsl_code', 20);
            $table->foreign('vp_vsl_code')->references('vsl_code')->on('vessels')->onDelete('cascade');
            $table->foreignId('vp_pk_id')->constrained('palkas', 'pk_id')->onDelete('cascade');

            $table->date('vp_post_date');
            $table->time('vp_post_time');
            $table->decimal('vp_latitude', 10, 6);
            $table->decimal('vp_longitude', 10, 6);
            $table->string('vp_location_name')->nullable();

            $table->string('vp_shift')->nullable();
            $table->text('vp_note')->nullable();

            $table->timestamps();
        });
    }

    public function down(): void
    {
        Schema::dropIfExists('vessel_posts');
    }
};
