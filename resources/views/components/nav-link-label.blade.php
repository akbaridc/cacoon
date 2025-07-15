@props(['title'])

<li {{ $attributes->merge(['class' => 'menu-label']) }}>
    <span>{{ $title }}</span>
</li>
