<?php

namespace App\Http\Controllers\Setting;

use App\Models\Role;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\DB;
use App\Http\Controllers\Controller;
use Spatie\Permission\Models\Permission;
use App\Datatables\RolePermissionDataTable;

class RolePermissionController extends Controller
{
    public function index(RolePermissionDataTable $dataTable)
    {
        return $dataTable->render('pages.settings.role-permission.index');
    }

    public function show(Role $role)
    {
        return response()->json(['status' => true,'data' => $role->permissions->pluck('name')->toArray()]);
    }

    public function store(Request $request)
    {
        DB::beginTransaction();

        try {
            $checekNameRole = Role::where('name', $request->role)->first();
            if($checekNameRole) return response()->json(['status' => false,'message' => 'Role already exists']);

            $role = Role::create(['name' => $request->role]);

            foreach ($request->permissions as $permission) {
                Permission::firstOrCreate(['name' => $permission]);
            }

            $role->givePermissionTo($request->permissions);

            DB::commit();

            return response()->json(['status' => true,'message' => 'Role created successfully']);
        } catch (\Throwable $th) {
            DB::rollBack();
            return response()->json(['status' => false,'message' => $th->getMessage()]);
        }
    }

    public function update(Request $request, Role $role)
    {
        DB::beginTransaction();

        try {
            $checekNameRole = Role::where('name', $request->role)->where('id', '!=', $role->id)->first();
            if($checekNameRole) return response()->json(['status' => false,'message' => 'Role already exists']);

            $role->update(['name' => $request->role]);

            foreach ($request->permissions as $permission) {
                Permission::firstOrCreate(['name' => $permission]);
            }

            $role->revokePermissionTo($role->permissions);
            $role->givePermissionTo($request->permissions);

            DB::commit();

            return response()->json(['status' => true,'message' => 'Role updated successfully']);
        } catch (\Throwable $th) {
            DB::rollBack();
            return response()->json(['status' => false,'message' => $th->getMessage()]);
        }
    }

    public function destroy(Role $role)
    {
        DB::beginTransaction();

        try {
            $roleName = $role->name;
            $role->delete();
            DB::commit();

            return response()->json(['status' => true,'message' => 'Role deleted successfully']);
        } catch (\Throwable $th) {
            DB::rollBack();
            return response()->json(['status' => false,'message' => $th->getMessage()]);
        }
    }
}
