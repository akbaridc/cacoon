<div class="startbar-menu" >
    <div class="startbar-collapse" id="startbarCollapse" data-simplebar>
        <div class="d-flex align-items-start flex-column w-100">
            <ul class="navbar-nav mb-auto w-100">

                <x-nav-link-label title="Main Menu" class="pt-0 mt-0" />
                <x-nav-link :href="route('dashboard')" typeNav="sub" title="Dashboard" icon="iconoir-home-simple" :active="collapseSidebar(['dashbaord'])"  />
                <x-nav-link-collapse title="Master Data" icon="iconoir-database">
                    <x-nav-link :href="route('users.index')" typeNav="sub" title="Users" :active="collapseSidebar(['users'])" />
                </x-nav-link-collapse>

                <x-nav-link-label title="Setting" class="mt-2" />
                <x-nav-link :href="route('role-permission.index')" typeNav="sub" title="Role & Permission" icon="iconoir-home-simple" :active="collapseSidebar(['role-permission'])"  />
            </ul>
        </div>
    </div>
</div>
