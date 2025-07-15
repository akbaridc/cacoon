<?php

namespace Database\Seeders;

use App\Models\Employee;
use App\Models\User;
use Illuminate\Database\Console\Seeds\WithoutModelEvents;
use Illuminate\Database\Seeder;
use Illuminate\Support\Facades\Hash;

class UserSeeder extends Seeder
{
    /**
     * Run the database seeds.
     */
    public function run(): void
    {

        $users = [
            [
                'name' => 'Super Admin',
                'email' => 'superadmin@gmail.com',
                'password' => Hash::make('password'),
                'nik' => '1234567890',
                'is_active' => true,
                'email_verified_at' => now(),
                'role' => 'super admin',
            ],
            [
                'name' => 'Akbar Imawan Dwi Cahya',
                'email' => 'akbar@gmail.com',
                'password' => Hash::make('password'),
                'nik' => '0987654321',
                'is_active' => true,
                'email_verified_at' => now(),
                'role' => 'user',
            ],
            [
                'name' => 'Inactive User',
                'email' => 'inactive@gmail.com',
                'password' => Hash::make('password'),
                'nik' => '1111111111',
                'is_active' => false,
                'email_verified_at' => now(),
                'role' => 'user',
            ]
        ];

        foreach ($users as $user) {
            $data = User::create([
                'name' => $user['name'],
                'email' => $user['email'],
                'password' => $user['password'],
                'nik' => $user['nik'],
                'is_active' => $user['is_active'],
                'email_verified_at' => $user['email_verified_at'],
            ]);

            Employee::create([
                'nik' => $user['nik'],
                'name' => $user['name'],
                'emp_type' => 'emp',
            ]);

            $data->assignRole($user['role']);
        }
    }
}
