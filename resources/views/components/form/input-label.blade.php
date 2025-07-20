@props(['value', 'mandatory' => false])

<label {{ $attributes->merge(['class' => 'block font-medium text-sm']) }}>
    {{ $value ?? $slot }} @if($mandatory) <x-form.indicator-required /> @endif
</label>
