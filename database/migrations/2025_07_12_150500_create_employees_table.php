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
        Schema::create('employees', function (Blueprint $table) {
            $table->id();
            $table->string('nik')->unique();
            $table->string('name');
            $table->string('emp_type');

            $table->string('work_unit_id')->nullable();
            $table->string('work_unit_name')->nullable();
            $table->string('parent_work_unit')->nullable();

            $table->string('position_grade')->nullable();
            $table->string('job_grade')->nullable();
            $table->string('job_id')->nullable();
            $table->string('job_title')->nullable();

            $table->string('direct_superior')->nullable();

            $table->string('division_id')->nullable();
            $table->string('position_title')->nullable();

            $table->string('photo')->nullable();

            $table->string('department_id')->nullable();
            $table->string('department')->nullable();
            $table->string('department_name')->nullable();

            $table->string('company_id')->nullable();
            $table->string('company_name')->nullable();

            $table->string('directorate_id')->nullable();
            $table->string('directorate_name')->nullable();
            $table->timestamps();

            $table->foreign('nik')->references('nik')->on('users')->onDelete('cascade');
        });

    }

    /**
     * Reverse the migrations.
     */
    public function down(): void
    {
        Schema::dropIfExists('employees');
    }
};
