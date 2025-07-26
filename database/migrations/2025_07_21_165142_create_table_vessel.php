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
            $table->string('vsl_code', 20)->unique()->nullable();
            $table->string('vsl_name')->nullable();
            $table->string('vsl_arrival_type')->nullable();
            $table->double('vsl_survey_draught')->nullable();
            $table->double('vsl_contract_tonnage')->nullable();
            $table->string('vsl_cargo_name')->nullable();
            $table->string('vsl_destination')->nullable();
            $table->dateTime('vsl_est_time_arrival')->nullable();
            $table->dateTime('vsl_time_berthing')->nullable();
            $table->dateTime('vsl_time_unberthing')->nullable();
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
