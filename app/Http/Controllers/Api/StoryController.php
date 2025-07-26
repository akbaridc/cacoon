<?php

namespace App\Http\Controllers\Api;

use App\Models\StoryView;
use App\Models\VesselPost;
use Illuminate\Http\Request;
use App\Http\Controllers\Controller;
use Illuminate\Support\Facades\Validator;

class StoryController extends Controller
{
    public function index(Request $request)
    {
        $validator = Validator::make($request->all(), [
            'page' => 'nullable|integer|min:1',
            'limit' => 'nullable|integer|min:1|max:100',
        ]);

        if ($validator->fails()) {
            return response()->json([
                'message' => 'Bad request',
                'errors' => $validator->errors(),
            ], 400);
        }

        $user = $request->user();
        $page = (int) $request->input('page', 1);
        $limit = (int) $request->input('limit', 10);
        $offset = ($page - 1) * $limit;

        // Ambil user yang punya story hari ini (kecuali user login)
        $usersWithStories = VesselPost::whereDate('created_at', now()->toDateString())
            ->where('vp_user_id', '!=', $user->id)
            ->select('vp_user_id')
            ->distinct()
            ->pluck('vp_user_id');

        $total = $usersWithStories->count();

        // Ambil user ID untuk halaman ini
        $paginatedUserIds = $usersWithStories->slice($offset, $limit)->values();

        $response = [];

        if($paginatedUserIds->isNotEmpty()) {
            // Ambil semua story dari user tersebut di hari ini
            $stories = VesselPost::with('user')
                ->whereDate('created_at', now()->toDateString())
                ->whereIn('vp_user_id', $paginatedUserIds)
                ->orderBy('created_at', 'asc')
                ->get();

            // Ambil semua view milik user login untuk story ini
            $storyIds = $stories->pluck('vp_id');
            $viewedStoryIds = StoryView::where('sv_user_id', $user->id)
                ->whereIn('sv_vp_id', $storyIds)
                ->pluck('sv_vp_id')
                ->toArray();

            // Kelompokkan berdasarkan user, hitung total, dan flag apakah semua sudah dilihat
            $response = $stories
                ->groupBy('vp_user_id')
                ->map(function ($posts, $vp_user_id) use ($viewedStoryIds) {
                    $userInfo = $posts->first()->user;

                    $formattedStories = $posts->map(function ($story) use ($viewedStoryIds) {
                        return [
                            'vp_id' => $story->vp_id,
                            'post' => $story->vp_photo_vessel,
                            'created_at' => $story->created_at,
                            'viewed' => in_array($story->vp_id, $viewedStoryIds),
                        ];
                    });

                    // True jika semua post user ini sudah dilihat
                    $allViewed = $formattedStories->every(fn ($story) => $story['viewed']);

                    return [
                        'user_id' => $vp_user_id,
                        'username' => $userInfo->name,
                        'avatar' => $userInfo->avatar,
                        'total_stories' => $formattedStories->count(),
                        'viewed' => $allViewed,
                        'stories' => $formattedStories->values()
                    ];
                })->values();
        }

        return response()->json([
            'status' => 'success',
            'message' => 'Get story list successfully',
            'meta' => [
                'total' => $total,
                'page' => $page,
                'limit' => $limit,
                'last_page' => ceil($total / $limit),
            ],
            'data' => $response,
        ]);
    }


    public function markAsViewed(Request $request)
    {
        $validator = Validator::make($request->all(), [
            'vp_id' => 'required|integer|exists:vessel_posts,vp_id',
        ]);

        if ($validator->fails()) {
            return response()->json([
                'message' => 'Bad request',
                'errors' => $validator->errors(),
            ], 400);
        }

        $user = $request->user();

        $story = VesselPost::findOrFail($request->vp_id);

        // Lewati jika sudah lebih dari 24 jam
        if (now()->diffInHours($story->created_at) >= 24) {
            return response()->json([
                'status' => 'success',
                'message' => 'Story is expired and will not be marked as viewed',
            ]);
        }

        // Skip if already viewed
        $alreadyViewed = StoryView::where('sv_vp_id', $story->vp_id)->where('sv_user_id', $user->id)->exists();

        if (!$alreadyViewed) {
            StoryView::create([
                'sv_vp_id' => $story->vp_id,
                'sv_user_id' => $user->id,
                'sv_viewed_at' => now(),
            ]);
        }

        return response()->json([
            'status' => 'success',
            'message' => 'Story marked as viewed',
        ]);
    }
}
