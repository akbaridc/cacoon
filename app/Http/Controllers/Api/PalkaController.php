<?php

namespace App\Http\Controllers\Api;

use App\Models\Palka;
use Illuminate\Http\Request;
use App\Http\Controllers\Controller;
use Illuminate\Support\Facades\Validator;

class PalkaController extends Controller
{
    public function index(Request $request)
    {
        $validator = Validator::make($request->all(), [
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

        $allowedKeys = ['search', 'page', 'limit', 'sort_by', 'sort_order'];

        $inputKeys = array_keys($request->query());
        $invalidKeys = array_diff($inputKeys, $allowedKeys);

        if (!empty($invalidKeys)) {
            return response()->json([
                'message' => 'Invalid query parameter(s): ' . implode(', ', $invalidKeys),
            ], 400);
        }

        $query = Palka::isActive();

        if ($request->filled('search')) {
            $search = $request->input('search');
            $query->where(function ($q) use ($search) {
                $q->where('pk_namme', 'like', "%{$search}%");
            });
        }


        if ($request->filled('sort_by') && $request->filled('sort_order')) {
            $query->orderBy($request->input('sort_by'), $request->input('sort_order'));
        } else {
            $query->orderBy('pk_name');
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
