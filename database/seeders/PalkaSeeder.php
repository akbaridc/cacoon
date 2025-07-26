<?php

namespace Database\Seeders;

use Illuminate\Database\Console\Seeds\WithoutModelEvents;
use Illuminate\Database\Seeder;

class PalkaSeeder extends Seeder
{
    /**
     * Run the database seeds.
     */
    public function run(): void
    {
        foreach (['Palka 1', 'Palka 2', 'Palka 3', 'Palka 4'] as $palka) {
            \App\Models\Palka::create([
                'pk_name' => $palka,
            ]);
        }
    }
}
