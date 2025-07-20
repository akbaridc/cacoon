<button {{ $attributes->merge(['type' => 'button', 'class' => 'btn btn-sm bg-secondary inline-flex items-center border-transparent rounded-md font-semibold text-xs text-white uppercase tracking-widest transition ease-in-out duration-150']) }}>
    {{ $slot }}
</button>
