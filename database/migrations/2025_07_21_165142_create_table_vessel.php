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
        Schema::create('vessels', function (Blueprint $table) {
            $table->bigIncrements('vsl_id');
            $table->unsignedBigInteger('vsl_orgn_id')->nullable();
            $table->string('vsl_code', 20)->nullable();
            $table->string('vsl_name')->nullable();
            $table->string('vsl_type')->nullable();
            $table->string('vsl_origin_location')->nullable();
            $table->string('vsl_origin_destination')->nullable();
            $table->string('vsl_arrival_type')->nullable();
            $table->double('vsl_bl_tonnage')->nullable();
            $table->double('vsl_contract_tonnage')->nullable();
            $table->timestamps();
        });
    }

    /**
     * Reverse the migrations.
     */
    public function down(): void
    {
        Schema::dropIfExists('vessels');
    }
};
