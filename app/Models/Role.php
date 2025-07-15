<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;
use Spatie\Permission\Models\Role as SpatieRole;

class Role extends SpatieRole
{
    public function getPermissionsStringAttribute()
    {
        return implode(', ', $this->permissions->pluck('name')->toArray());
    }

    public function getPermissionsLabelAttribute()
    {
        $labels = '<div class="d-flex gap-3 flex-wrap">';
        $permissions = $this->permissions->pluck('name')->toArray();
        if($permissions){
            foreach ($permissions as $key => $value) {
                $labels .= '<span class="badge bg-primary">' . $value . '</span>';
            }
        }
        $labels .= '</div>';
        return $labels;
    }

    public function getPermissionsMappingAttribute()
    {
        $listPermissions = explode(',', $this->getPermissionsStringAttribute());

        // Map menjadi array dengan struktur berdasarkan module
        $statePermissions = collect($listPermissions)
            ->map(function ($permission) {
                return trim($permission); // Hapus spasi di awal dan akhir setiap permission
            })
            ->mapToGroups(function ($permission) {
                [$action, $module] = explode('.', $permission);
                return [$module => $permission];
            })
            ->toArray();

        return (object)$statePermissions;
    }
}
