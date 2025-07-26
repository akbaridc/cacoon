<?php

namespace Database\Seeders;

use Illuminate\Database\Seeder;
use Illuminate\Support\Facades\DB;
use Spatie\Permission\Models\Role;
use Spatie\Permission\Models\Permission;
use Illuminate\Database\Console\Seeds\WithoutModelEvents;


class InsertPermissionList extends Seeder
{
    /**
     * Run the database seeds.
     */
    public function run(): void
    {
        DB::beginTransaction();
        try {
            // Ambil semua permission yang sudah ada di database
            $existingPermissions = Permission::pluck('name')->toArray();

            $addPermission = [
                //setting application
                'view.setting-application',
                'edit.setting-application',

                //master vessel
                'view.vessel',
                'synscronize.vessel',

                //master palka
                'create.palka',
                'view.palka',
                'edit.palka',
                'delete.palka',

                //Logs
                'logs.read',
            ];

            dump('Insert permission running...');
            $count = 0;

            foreach ($addPermission as $permission) {
                // Cek apakah permission sudah ada, jika ada maka lanjutkan (skip)
                if (in_array($permission, $existingPermissions)) {
                    continue;
                }

                // Insert permission baru
                Permission::create(['name' => $permission]);
                dump('Inserted permission: ' . $permission);
                $count++;
            }

            //jika ada permission baru set permission ke super admin otomatis
            if($count > 0) {
                // Ambil semua permission terbaru dari database
                $allPermissions = Permission::all();

                // Ambil atau buat role yang ingin diberikan semua permission
                $role = Role::firstOrCreate(['name' => 'super admin']);

                // Berikan semua permission ke role
                $role->syncPermissions($allPermissions);
                dump('Assigned all permissions to role: ' . $role->name);
            }


            dump("Insert permission completed, total new insert : {$count}");
            DB::commit();
        } catch (\Throwable $th) {
            DB::rollBack();
            dump($th->getMessage());
        }

    }
}
