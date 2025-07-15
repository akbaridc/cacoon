@props(['title', 'icon' => null])

<li class="nav-item" x-data="{ open: false }">
    <a href="#" class="nav-link flex items-center justify-between" @click.prevent="open = !open">
        <div class="flex items-center">
            <i class="{{ $icon }} menu-icon"></i>
            <span>{{ $title }}</span>
        </div>
        <div>
            <i x-show="!open" class="iconoir-nav-arrow-right"></i>
            <i x-show="open" class="iconoir-nav-arrow-down"></i>
        </div>
    </a>
    <div x-show="open" x-collapse class="space-y-1">
        <ul class="nav flex-column">
            {{ $slot }}
        </ul>
    </div>
</li>

{{-- <li class="nav-item">
    <a class="nav-link" href="#sidebarApplications" data-bs-toggle="collapse" role="button"
        aria-expanded="false" aria-controls="sidebarApplications">
        <i class="iconoir-view-grid menu-icon"></i>
        <span>Master</span>
    </a>
    <div class="collapse" id="sidebarApplications">
        <ul class="nav flex-column">
            <li class="nav-item">
                <a class="nav-link" href="apps-chat.html">Chat</a>
            </li>
        </ul>
    </div>
</li> --}}
