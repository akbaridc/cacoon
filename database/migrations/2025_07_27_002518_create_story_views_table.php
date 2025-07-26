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
        Schema::create('story_views', function (Blueprint $table) {
            $table->id('sv_id');
            $table->foreignId('sv_vp_id')->constrained('vessel_posts', 'vp_id')->onDelete('cascade');
            $table->foreignId('sv_user_id')->constrained('users')->onDelete('cascade');
            $table->timestamp('sv_viewed_at')->nullable();
            $table->unique(['sv_vp_id', 'sv_user_id']);
            $table->timestamps();
        });
    }

    /**
     * Reverse the migrations.
     */
    public function down(): void
    {
        Schema::dropIfExists('story_views');
    }
};
