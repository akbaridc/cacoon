<?php

use Illuminate\Support\Str;
use App\Http\Controllers\Master\UsersController;

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
                ]
            ],
            [
                'module' => 'Setting',
                'menu' => [
                    [
                        'name' => 'Role and Permission',
                        'permission_name' => 'permissions'
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
        ];
    }
}
