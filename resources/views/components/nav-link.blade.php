@props(['active', 'title' => 'Menu', 'icon' => '', 'typeNav' => 'parent'])

{{-- <li class="menu-item {{ $typeNav != 'parent' && $active ? 'menuitem-active' : '' }}">
    <a {{ $attributes->merge(['class' => "menu-link " . ($active ? 'active' : '')]) }}>
        @if ($typeNav == 'parent')
            <span class="menu-icon"><i data-feather="{{ $icon }}"></i></span>
        @else
            <span class="menu-text"> {{ $title }} </span>
        @endif
    </a>
</li> --}}

<li class="nav-item">
    <a {{ $attributes->merge(['class' => "nav-link " . ($active ? 'active' : '')]) }}>
        @if ($icon)
            <i class="{{ $icon }} menu-icon"></i>
        @endif
        <span>{{ $title }}</span>
    </a>
</li>

