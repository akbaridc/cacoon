<?php

use Illuminate\Support\Facades\Route;
use App\Http\Controllers\Setting\RolePermissionController;
use App\Http\Controllers\Setting\ApplicationSettingController;
use App\Http\Controllers\Master\VesselController;
use App\Http\Controllers\LogsController;

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

    Route::controller(ApplicationSettingController::class)->prefix('setting-application')->name('setting-application.')->group(function () {
        Route::get('/', 'index')->name('index')->middleware(['permission:view.setting-application']);
        Route::post('/', 'update')->name('update')->middleware(['permission:edit.setting-application']);
    });

    Route::controller(VesselController::class)->prefix('vessel')->name('vessel.')->group(function () {
        Route::get('/', 'index')->name('index')->middleware(['permission:view.vessel']);
        Route::get('/sync', 'sync')->name('sync')->middleware(['permission:synscronize.vessel']);
    });

    Route::get('logs', [LogsController::class, 'index'])->name('logs.index')->middleware(['permission:logs.read']);
});

require __DIR__.'/auth.php';
