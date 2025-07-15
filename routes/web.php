<?php

use App\Http\Controllers\ProfileController;
use Illuminate\Support\Facades\Route;
use App\Http\Controllers\Setting\RolePermissionController;

Route::get('/', function () {
    return redirect()->route('login');
});

Route::middleware('auth')->group(function () {
    Route::get('/dashboard', function () {
        return view('dashboard');
    })->middleware(['verified'])->name('dashboard');

    foreach (mappingRoutePermission() as $permission => $config) {
        Route::resource($config['url'], $config['controller'])
            ->only($config['methods'])
            ->middleware(['permission:' . $permission]);
    }

    Route::controller(RolePermissionController::class)->prefix('role-permission')->name('role-permission.')->group(function () {
        Route::get('/', 'index')->name('index')->middleware(['permission:view.permissions']);
        Route::post('/', 'store')->name('store')->middleware(['permission:create.permissions']);
        Route::get('/{role}', 'show')->name('show')->middleware(['permission:view.permissions']);
        Route::put('/{role}', 'update')->name('update')->middleware(['permission:edit.permissions']);
        Route::delete('/{role}', 'destroy')->name('destroy')->middleware(['permission:delete.permissions']);
    });

    Route::get('/profile', [ProfileController::class, 'edit'])->name('profile.edit');
    Route::patch('/profile', [ProfileController::class, 'update'])->name('profile.update');
    Route::delete('/profile', [ProfileController::class, 'destroy'])->name('profile.destroy');
});

require __DIR__.'/auth.php';
