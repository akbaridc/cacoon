<?php

namespace App\Http\Middleware;

use App\Models\User;
use Closure;
use Illuminate\Http\Request;
use Symfony\Component\HttpFoundation\Response;

class CheckApiTokenMiddleware
{
    /**
     * Handle an incoming request.
     *
     * @param  \Closure(\Illuminate\Http\Request): (\Symfony\Component\HttpFoundation\Response)  $next
     */
    public function handle(Request $request, Closure $next): Response
    {
        // Get token from Authorization header
        $token = $request->bearerToken();

        if (!$token) {
            return response()->json([
                'message' => 'Unauthorized. Token not provided.',
            ], 401);
        }

        // Find user
        $user = User::where('token_text', $token)->first();

        if (!$user) {
            return response()->json([
                'message' => 'Unauthorized. Invalid token.',
            ], 401);
        }

        // Check if user is active
        if (!$user->is_active) {
            return response()->json([
                'message' => 'Unauthorized. Account is inactive.',
            ], 401);
        }

        // Check if mobile token is expired
        if (!$user->token_expires_at || $user->token_expires_at->isPast()) {
            return response()->json([
                'message' => 'Unauthorized. Token has expired.',
            ], 401);
        }

        // Set the authenticated user
        $request->setUserResolver(function () use ($user) {
            return $user;
        });

        return $next($request);
    }
}
