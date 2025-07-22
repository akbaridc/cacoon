<?php

use App\Http\Controllers\Api\AuthController;
use App\Http\Controllers\Api\VesselController;
use App\Http\Controllers\Api\PalkaController;
use App\Http\Controllers\Api\VesselPostController;
use Illuminate\Support\Facades\Route;

/*
|--------------------------------------------------------------------------
| API Routes
|--------------------------------------------------------------------------
|
| Here is where you can register API routes for your application. These
| routes are loaded by the RouteServiceProvider and all of them will
| be assigned to the "api" middleware group. Make something great!
|
*/

// Public routes
Route::post('/login', [AuthController::class, 'login']);
Route::post('/verify-token', [AuthController::class, 'verifyToken']);

// Protected routes
Route::middleware('auth.api')->group(function () {
    Route::post('/refresh-token', [AuthController::class, 'refreshToken']);
    Route::get('/me', [AuthController::class, 'me']);
    Route::get('/logout', [AuthController::class, 'logout']);

    // Vessel routes
    Route::controller(VesselController::class)->prefix('vessel')->name('vessel.')->group(function () {
        Route::get('/', 'index');
    });

    // Palka routes
    Route::controller(PalkaController::class)->prefix('palka')->name('palka.')->group(function () {
        Route::get('/', 'index');
    });

    // Vessel Post routes
    Route::controller(VesselPostController::class)->prefix('post')->name('post.')->group(function () {
        Route::post('/', 'store');
    });

});
