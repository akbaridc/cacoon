<?php

namespace App\Http\Controllers\Master;

use App\Models\Palka;
use Illuminate\Http\Request;
use Illuminate\Validation\Rule;
use Illuminate\Support\Facades\DB;
use App\Http\Controllers\Controller;
use Illuminate\Support\Facades\Validator;
use App\DataTables\Master\PalkasDataTable;

class PalkaController extends Controller
{
    /**
     * Display a listing of the resource.
     */
    public function index(PalkasDataTable $dataTable)
    {
        return $dataTable->render('pages.master.palka.index');
    }

    /**
     * Show the form for creating a new resource.
     */
    public function create()
    {
        //
    }

    /**
     * Store a newly created resource in storage.
     */
    public function store(Request $request)
    {
        DB::beginTransaction();
        try {
            $validator = Validator::make($request->all(), [
                'name' => 'required:string|max:255|unique:palkas,pk_name',
                'status' => 'required|in:0,1',
            ]);

            if ($validator->fails()) {
                return response()->json([
                    'message' => 'Bad request',
                    'error' => $validator->errors(),
                ], 400);
            }

            Palka::create([
                'pk_name' => $request->name,
                'pk_is_active' => $request->status,
            ]);

            DB::commit();
            return response()->json(['status' => true,'message' => 'Palka created successfully'], 201);

        } catch (\Throwable $th) {
            DB::rollBack();
            return response()->json(['status' => false,'message' => $th->getMessage()], 400);
        }
    }

    /**
     * Display the specified resource.
     */
    public function show(Palka $palka)
    {
        //
    }

    /**
     * Show the form for editing the specified resource.
     */
    public function edit(Palka $palka)
    {
        //
    }

    /**
     * Update the specified resource in storage.
     */
    public function update(Request $request, Palka $palka)
    {
        DB::beginTransaction();
        try {
            $validator = Validator::make($request->all(), [
                'name' => 'required:string|max:255', Rule::unique('palkas', 'pk_name')->ignore($palka->pk_id, 'pk_id'),
                'status' => 'required|in:0,1',
            ]);

            if ($validator->fails()) {
                return response()->json([
                    'message' => 'Bad request',
                    'error' => $validator->errors(),
                ], 400);
            }

            $palka->update([
                'pk_name' => $request->name,
                'pk_is_active' => $request->status
            ]);

            DB::commit();
            return response()->json(['status' => true,'message' => 'Palka updated successfully'], 201);

        } catch (\Throwable $th) {
            DB::rollBack();
            return response()->json(['status' => false,'message' => $th->getMessage()], 400);
        }
    }

    /**
     * Remove the specified resource from storage.
     */
    public function destroy(Palka $palka)
    {
        DB::beginTransaction();
        try {
            $palka->delete();
            DB::commit();
            return response()->json(['status' => true,'message' => 'Palka deleted successfully'], 201);
        } catch (\Throwable $th) {
            DB::rollBack();
            return response()->json(['status' => false,'message' => $th->getMessage()], 400);
        }
    }
}
