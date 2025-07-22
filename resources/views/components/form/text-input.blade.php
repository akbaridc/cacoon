@props(['type' => 'text', 'disabled' => false])

<input type="{{ $type }}" @disabled($disabled) {{ $attributes->merge(['class' => 'form-control mt-1 w-[50%] lg:w-[50%] sm:w-full' . ($disabled ? ' cursor-not-allowed' : '')]) }}>
