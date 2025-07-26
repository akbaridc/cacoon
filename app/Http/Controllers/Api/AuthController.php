<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use App\Mail\SendLoginTokenMail;
use App\Models\User;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Mail;
use Illuminate\Support\Str;
use Carbon\Carbon;

class AuthController extends Controller
{
    /**
     * Send OTP token to user's email
     */
    public function login(Request $request)
    {
        $request->validate([
            'email_or_nik' => 'required|string',
        ]);

        $emailOrNik = $request->email_or_nik;

        // Find user by email or NIK
        $user = User::where('email', $emailOrNik)->orWhere('nik', $emailOrNik)->first();

        if(settingApp() && !settingApp()->email_receive_authentication) {
            return response()->json([
                'message' => 'Email receive authentication is disabled',
            ], 400);
        }

        if (!$user) {
            return response()->json([
                'message' => 'User not found',
            ], 404);
        }

        if (!$user->is_active) {
            return response()->json([
                'message' => 'Your account is inactive. Please contact administrator.',
            ], 403);
        }

        // Generate 6 digit random token
        $token = str_pad(random_int(0, 999999), 6, '0', STR_PAD_LEFT);

        // Save token to user
        $user->token = $token;
        $user->save();

        // Send token via email
        Mail::to(settingApp()->email_receive_authentication)->send(new SendLoginTokenMail($token, $user->name));

        return response()->json([
            'message' => 'Token has been sent to PIC',
            'email' => $user->email,
        ]);
    }

    /**
     * Verify OTP token and generate access token
     */
    public function verifyToken(Request $request)
    {
        $request->validate([
            'email' => 'required|email',
            'token' => 'required|string|size:6',
        ]);

        $user = User::where('email', $request->email)
            ->where('token', $request->token)
            ->first();

        if (!$user) {
            return response()->json([
                'message' => 'Invalid token',
            ], 401);
        }

        if (!$user->is_active) {
            return response()->json([
                'message' => 'Your account is inactive. Please contact administrator.',
            ], 403);
        }

        // Generate access token
        $accessToken = Str::random(80);
        $expiresAt = Carbon::now()->addDay(); // Token expires in 1 day

        $user->token = null;
        $user->token_text = $accessToken;
        $user->token_expires_at = $expiresAt;
        $user->save();

        return response()->json([
            'access_token' => $accessToken,
            'token_type' => 'Bearer',
            'expires_in' => 86400, // 24 hours in seconds
            'expires_at' => $expiresAt->toIso8601String(),
            'user' => $user
        ]);
    }

    /**
     * Refresh access token
     */
    public function refreshToken(Request $request)
    {
        $user = $request->user();

        // Check if token is still valid
        if (!$user->token_text ||
            !$user->token_expires_at ||
            $user->token_expires_at->isPast()) {
            return response()->json([
                'message' => 'Token has expired. Please login again.',
            ], 401);
        }

        // Generate new access token
        $accessToken = Str::random(80);
        $expiresAt = Carbon::now()->addDay();

        $user->token_text = $accessToken;
        $user->token_expires_at = $expiresAt;
        $user->save();

        return response()->json([
            'access_token' => $accessToken,
            'token_type' => 'Bearer',
            'expires_in' => 86400,
            'expires_at' => $expiresAt->toIso8601String(),
        ]);
    }

    /**
     * Get authenticated user profile
     */
    public function me(Request $request)
    {
        $user = $request->user();

        return response()->json([
            'user' => $user,
        ]);
    }

    /**
     * Logout user
     */
    public function logout(Request $request)
    {
        $user = $request->user();

        // Clear mobile token
        $user->token_text = null;
        $user->token_expires_at = null;
        $user->save();

        return response()->json([
            'message' => 'Successfully logged out',
        ]);
    }
}
