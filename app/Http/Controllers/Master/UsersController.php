<?php

namespace App\Http\Controllers\Master;

use App\Models\User;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\DB;
use App\Http\Controllers\Controller;
use Illuminate\Support\Facades\Hash;
use App\DataTables\Master\UsersDataTable;

class UsersController extends Controller
{
    /**
     * Display a listing of the resource.
     */
    public function index(UsersDataTable $dataTable)
    {
        return $dataTable->render('pages.master.users.index');
    }

    /**
     * Show the form for creating a new resource.
     */
    public function create()
    {
        $roles = \App\Models\Role::all();
        return view('pages.master.users.form', compact('roles'));
    }

    /**
     * Store a newly created resource in storage.
     */
    public function store(Request $request)
    {
        DB::beginTransaction();
        try {
            $data = $request->validate([
                'nik' => 'required|string|max:255',
                'name' => 'required|string|max:255',
                'email' => 'required|email|unique:users,email',
                'password' => 'required|string|min:8',
                'avatar' => 'nullable|image|max:1048',
                'role' => 'required|exists:roles,id',
                'is_active' => 'required|boolean',
            ]);

            $data['password'] = Hash::make($data['password']);
            $user = User::create($data);

            if ($request->hasFile('avatar')) {
                $user->addMediaFromRequest('avatar')->usingName('Avatar')->withCustomProperties(['uploaded_by' => auth()->user()->id])->toMediaCollection('avatars');
            }

            $role = \App\Models\Role::findOrFail($request->role);
            $user->avatar = $user->getFirstMediaUrl('avatars', 'thumb');
            $user->assignRole($role->name);

            DB::commit();
            return response()->json(['status' => true,'message' => 'User created successfully'], 201);
        } catch (\Exception $e) {
            DB::rollBack();
            return response()->json(['status' => false,'message' => $e->getMessage()], 400);
        }
    }

    /**
     * Display the specified resource.
     */
    public function show(User $user)
    {
         if (!$user) abort(404);

        $user = $user->load('roles');
        return view('pages.master.users.show', compact('user'));
    }

    /**
     * Show the form for editing the specified resource.
     */
    public function edit(User $user)
    {
        if (!$user) abort(404);
        $roles = \App\Models\Role::all();

        $user = $user->load('roles');
        return view('pages.master.users.form', compact('roles', 'user'));
    }

    /**
     * Update the specified resource in storage.
     */
    public function update(Request $request, User $user)
    {
        DB::beginTransaction();
        try {
            $data = $request->validate([
                'nik' => 'required|string|max:255',
                'name' => 'required|string|max:255',
                'email' => 'required|email|unique:users,email,' . $user->id,
                'password' => 'nullable|string|min:8',
                'avatar' => 'nullable|image|max:1048',
                'role' => 'required|exists:roles,id',
                'is_active' => 'required|in:0,1',
            ]);

            if($request->password){
                $data['password'] = Hash::make($data['password']);
            } else {
                unset($data['password']);
            }

            $user->update($data);

            if ($request->hasFile('avatar')) {
                // Hapus media lama
                $user->clearMediaCollection('avatars');

                // Upload avatar baru
                $user->addMediaFromRequest('avatar')
                    ->usingName('Avatar')
                    ->withCustomProperties(['uploaded_by' => auth()->user()->id])
                    ->toMediaCollection('avatars');

                $user->avatar = $user->getFirstMediaUrl('avatars', 'thumb');
                $user->save();
            }

            $role = \App\Models\Role::findOrFail($request->role);
            $user->assignRole($role->name);

            DB::commit();
            return response()->json(['status' => true,'message' => 'User updated successfully'], 201);
        } catch (\Exception $e) {
            DB::rollBack();
            return response()->json(['status' => false,'message' => $e->getMessage()], 400);
        }
    }

    /**
     * Remove the specified resource from storage.
     */
    public function destroy(User $user)
    {
        DB::beginTransaction();
        try {
            $user->clearMediaCollection('avatars');
            $user->delete();
            DB::commit();
            return response()->json(['status' => true,'message' => 'User deleted successfully'], 201);
        } catch (\Exception $e) {
            DB::rollBack();
            return response()->json(['status' => false,'message' => $e->getMessage()], 400);
        }
    }
}
