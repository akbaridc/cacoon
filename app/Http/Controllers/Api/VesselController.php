<?php

namespace App\Http\Controllers\Api;

use App\Models\Vessel;
use Illuminate\Http\Request;
use App\Http\Controllers\Controller;
use Illuminate\Support\Facades\Validator;

class VesselController extends Controller
{
    public function index(Request $request)
    {
        $validator = Validator::make($request->all(), [
            'type' => 'nullable|string|in:Discharging,Loading',
            'search' => 'nullable|string',
            'page' => 'nullable|integer|min:1',
            'limit' => 'nullable|integer|min:1|max:100',
            'sort_by' => 'nullable|string',
            'sort_order' => 'nullable|string|in:asc,desc',
        ]);

        if ($validator->fails()) {
            return response()->json([
                'message' => 'Bad request',
                'error' => $validator->errors(),
            ], 400);
        }

        $allowedKeys = ['type', 'search', 'page', 'limit', 'sort_by', 'sort_order'];

        $inputKeys = array_keys($request->query());
        $invalidKeys = array_diff($inputKeys, $allowedKeys);

        if (!empty($invalidKeys)) {
            return response()->json([
                'message' => 'Invalid query parameter(s): ' . implode(', ', $invalidKeys),
            ], 400);
        }

        $query = Vessel::query();

        if ($request->filled('search')) {
            $search = $request->input('search');
            $query->where(function ($q) use ($search) {
                $q->where('vsl_code', 'like', "%{$search}%")
                    ->orWhere('vsl_name', 'like', "%{$search}%")
                    ->orWhere('vsl_destination', 'like', "%{$search}%")
                    ->orWhere('vsl_cargo_name', 'like', "%{$search}%");
            });
        }

        if ($request->filled('type')) {
            $arrivalType = $request->input('type');
            $query->where(function ($q) use ($arrivalType) {
                $q->where("vsl_arrival_type", $arrivalType);
            });
        }


        if ($request->filled('sort_by') && $request->filled('sort_order')) {
            $query->orderBy($request->input('sort_by'), $request->input('sort_order'));
        } else {
            $query->orderBy('vsl_est_time_arrival');
        }

        $total = $query->count();

        $perPage = (int)$request->input('limit', 10);
        $page = (int)$request->input('page', 1);
        $vessel = $query->offset(($page - 1) * $perPage)->limit($perPage)->get();

        return response()->json([
            'meta' => [
                'total' => $total,
                'page' => $page,
                'limit' => $perPage,
                'last_page' => ceil($total / $perPage)
            ],
            'data' => $vessel
        ]);
    }
}
