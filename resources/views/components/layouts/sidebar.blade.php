<div class="startbar-menu" >
    <div class="startbar-collapse" id="startbarCollapse" data-simplebar>
        <div class="d-flex align-items-start flex-column w-100">
            <ul class="navbar-nav mb-auto w-100">

                <x-nav-link-label title="Main Menu" class="pt-0 mt-0" />
                <x-nav-link :href="route('dashboard')" typeNav="sub" title="Dashboard" icon="iconoir-home-simple" :active="collapseSidebar(['dashbaord'])"  />

                @if (auth()->user()->hasAnyPermission(['view.users', 'view.vessel', 'view.palka']))
                    <x-nav-link-collapse title="Master Data" icon="iconoir-database" :active="collapseSidebar(['users','vessel','palka'])">
                        @if (auth()->user()->hasAnyPermission(['view.users']))
                            <x-nav-link :href="route('users.index')" typeNav="sub" title="Users" :active="collapseSidebar(['users'])" />
                        @endif

                        @if (auth()->user()->hasAnyPermission(['view.vessel']))
                            <x-nav-link :href="route('vessel.index')" typeNav="sub" title="Vessel" :active="collapseSidebar(['vessel'])" />
                        @endif

                        @if (auth()->user()->hasAnyPermission(['view.palka']))
                            <x-nav-link :href="route('palka.index')" typeNav="sub" title="Palka" :active="collapseSidebar(['palka'])" />
                        @endif
                    </x-nav-link-collapse>
                @endif

                @if (auth()->user()->hasAnyPermission(['view.permissions', 'view.setting-application']))
                    <x-nav-link-label title="Setting" class="mt-2" />

                    @if (auth()->user()->hasAnyPermission(['view.permissions']))
                        <x-nav-link :href="route('role-permission.index')" typeNav="sub" title="Role & Permission" icon="iconoir-home-simple" :active="collapseSidebar(['role-permission'])"  />
                    @endif

                    @if (auth()->user()->hasAnyPermission(['view.setting-application']))
                        <x-nav-link :href="route('setting-application.index')" typeNav="sub" title="Setting Application" icon="iconoir-home-simple" :active="collapseSidebar(['setting-application'])"  />
                    @endif
                @endif

                @if (auth()->user()->hasAnyPermission(['view.logs']))
                    <x-nav-link-label title="Logs" class="mt-2" />

                    @if (auth()->user()->hasAnyPermission(['view.logs']))
                        <x-nav-link :href="route('logs.index')" typeNav="sub" title="Logs" icon="iconoir-book" :active="collapseSidebar(['logs'])"  />
                    @endif
                @endif
            </ul>
        </div>
    </div>
</div>
