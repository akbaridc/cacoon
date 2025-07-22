<?php

use Illuminate\Support\Str;
use App\Http\Controllers\Master\UsersController;
use App\Http\Controllers\Master\PalkaController;
use App\Models\SettingApplication;

if (!function_exists('collapseSidebar')) {
    function collapseSidebar($routes, $output = true)
    {
        foreach ($routes as $route) {
            if (Str::is($route . '.*', request()->route()->getName())) {
                return $output === 'd-block' ? 'd-block' : true;
            }
        }

        return $output === 'd-block' ? '' : false;
    }
}

if (!function_exists('menus')) {
    function menus($string = 'module')
    {
        $menu = [
            [
                'module' => 'Master',
                'menu' => [
                    [
                        'name' => 'Users',
                        'permission_name' => 'users'
                    ],
                    [
                        'name' => 'Vessel',
                        'permission_name' => 'vessel'
                    ],
                    [
                        'name' => 'Palka',
                        'permission_name' => 'palka'
                    ],
                ]
            ],
            [
                'module' => 'Setting',
                'menu' => [
                    [
                        'name' => 'Role and Permission',
                        'permission_name' => 'permissions'
                    ],
                    [
                        'name' => 'Setting Application',
                        'permission_name' => 'setting-application'
                    ],
                ]
            ],
        ];

        $mappingModule = collect($menu)->map(fn ($value) => $value['module']);

        return $string == 'module' ? $mappingModule : $menu;
    }
}

if (!function_exists('mappingRoutePermission')) {
    function mappingRoutePermission()
    {
        return [
            'create.users' => ['url'=> 'users', 'controller' => UsersController::class, 'methods' => ['create', 'store']],
            'view.users'=> ['url'=> 'users', 'controller' => UsersController::class, 'methods' => ['index', 'show']],
            'edit.users' => ['url'=> 'users', 'controller' => UsersController::class, 'methods' => ['edit', 'update']],
            'delete.users' => ['url'=> 'users', 'controller' => UsersController::class, 'methods' => ['destroy']],

            //palka
            'create.palka' => ['url'=> 'palka', 'controller' => PalkaController::class, 'methods' => ['create', 'store']],
            'view.palka'=> ['url'=> 'palka', 'controller' => PalkaController::class, 'methods' => ['index', 'show']],
            'edit.palka' => ['url'=> 'palka', 'controller' => PalkaController::class, 'methods' => ['edit', 'update']],
            'delete.palka' => ['url'=> 'palka', 'controller' => PalkaController::class, 'methods' => ['destroy']],
        ];
    }
}

if (!function_exists('settingApp')) {
    function settingApp()
    {
        return SettingApplication::first() ?? null;
    }
}
