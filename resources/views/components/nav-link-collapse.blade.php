@props(['title', 'icon' => null, 'active' => false])

<li class="nav-item" x-data="{ open: '{{ $active ? true : false }}' }">
    <a href="#" class="nav-link flex items-center justify-between" x-bind:class="{ 'active': open }" @click.prevent="open = !open">
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
