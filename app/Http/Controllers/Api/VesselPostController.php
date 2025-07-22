<?php

namespace App\Http\Controllers\Api;

use App\Models\VesselPost;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\DB;
use App\Http\Controllers\Controller;
use Illuminate\Support\Facades\Validator;

class VesselPostController extends Controller
{
    public function store(Request $request)
    {
        $validator = Validator::make($request->all(), [
            'user' => 'required:exists:users,id',
            'vessel' => 'required:exists:vessels,id',
            'palka' => 'required:exists:palkas,id',
            'date' => 'required|date',
            'time' => 'required|date_format:H:i:s',
            'lat' => 'required',
            'long' => 'required',
            'shift' => 'required|in:1,2,3',
            'photo_vessel' => 'required|image|mimes:jpeg,png,jpg,gif,svg',
            'photo_selfie' => 'required|image|mimes:jpeg,png,jpg,gif,svg',
            'note' => 'nullable|string'
        ]);

        if ($validator->fails()) {
            return response()->json([
                'message' => 'Bad request',
                'error' => $validator->errors(),
            ], 400);
        }

        DB::beginTransaction();
        try {

            $vesselPost = VesselPost::create([
                'vp_user_id' => $request->user,
                'vp_vsl_id' => $request->vessel,
                'vp_pk_id' => $request->palka,
                'vp_post_date' => $request->date,
                'vp_post_time' => $request->time,
                'vp_latitude' => $request->lat,
                'vp_longitude' => $request->long,
                'vp_shift' => $request->shift,
                'vp_note' => $request->note
            ]);

            // Simpan media
            $vesselPost->addMediaFromRequest('photo_vessel')->usingName('Photo Vessel')->withCustomProperties(['uploaded_by' => $request->user])->toMediaCollection('photo_vessel');
            $vesselPost->addMediaFromRequest('photo_selfie')->usingName('Photo Selfie')->withCustomProperties(['uploaded_by' => $request->user])->toMediaCollection('photo_selfie');

            DB::commit();
            return response()->json(['status' => true,'message' => 'Vessel post successfully'], 201);
        } catch (\Throwable $th) {
            DB::rollBack();
            return response()->json(['status' => false,'message' => $th->getMessage()], 400);
        }
    }
}
