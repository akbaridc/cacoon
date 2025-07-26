<?php

namespace App\Http\Controllers\Api;

use App\Models\User;
use App\Models\VesselPost;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\DB;
use App\Http\Controllers\Controller;
use Illuminate\Support\Facades\Validator;

class VesselPostController extends Controller
{
    public function index(Request $request)
    {
        $validator = Validator::make($request->all(), [
            'page' => 'nullable|integer|min:1',
            'limit' => 'nullable|integer|min:1|max:100',
            'sort_by' => 'nullable|string',
            'sort_order' => 'nullable|string|in:asc,desc',
        ]);

        if ($validator->fails()) {
            return response()->json([
                'status' => 'fail',
                'message' => 'Bad request',
                'error' => $validator->errors(),
            ], 400);
        }

        $allowedKeys = ['page', 'limit', 'sort_by', 'sort_order'];

        $inputKeys = array_keys($request->query());
        $invalidKeys = array_diff($inputKeys, $allowedKeys);

        if (!empty($invalidKeys)) {
            return response()->json([
                'message' => 'Invalid query parameter(s): ' . implode(', ', $invalidKeys),
            ], 400);
        }

        $query = VesselPost::with('user');

        if ($request->filled('sort_by') && $request->filled('sort_order')) {
            $query->orderBy($request->input('sort_by'), $request->input('sort_order'));
        } else {
            $query->orderBy('created_at', 'desc');
        }

        $total = $query->count();

        $perPage = (int)$request->input('limit', 10);
        $page = (int)$request->input('page', 1);
        $vessel = $query->offset(($page - 1) * $perPage)->limit($perPage)->get();

        return response()->json([
            'status' => 'success',
            'message' => 'Vessel post get successfully',
            'meta' => [
                'total' => $total,
                'page' => $page,
                'limit' => $perPage,
                'last_page' => ceil($total / $perPage)
            ],
            'data' => $vessel
        ]);
    }

    public function store(Request $request)
    {
        $validator = Validator::make($request->all(), [
            'user' => 'required:exists:users,id',
            'vessel_code' => 'required:string',
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

            $user = User::where('id', $request->user)->first();

            $vesselPost = VesselPost::create([
                'vp_user_id' => $request->user,
                'vp_vsl_code' => $request->vessel_code,
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

            logActivity('Mobile API', "{$user->name} progress vessel post", [], $user->id);

            DB::commit();
            return response()->json(['status' => true,'message' => 'Vessel post successfully'], 201);
        } catch (\Throwable $th) {
            DB::rollBack();
            return response()->json(['status' => false,'message' => $th->getMessage()], 400);
        }
    }
}
