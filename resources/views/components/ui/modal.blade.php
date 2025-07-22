<div
    x-show="{{ $show ?? 'showModal' }}"
    x-transition
    @keydown.escape.window="{{ $show ?? 'showModal' }} = false"
    class="fixed inset-0 z-[9995] flex items-center justify-center bg-black bg-opacity-50"
    style="display: none;"
>
    <div {{ $attributes->merge(['class' => 'bg-white rounded-lg shadow-lg w-full max-w-4xl mx-4 max-h-[90vh]']) }}>
        <div class="flex items-center justify-between px-6 py-3 border-b border-gray-200">
            <h2 class="text-lg font-semibold text-gray-800">
                {{ $titleModal }}
            </h2>
        </div>

        <div class="px-6 py-4 space-y-4 overflow-y-auto max-h-[65vh]">
            {{ $slot }}
        </div>

        @if (isset($footerModal))
            <div class="flex items-center justify-end gap-2 px-6 py-2 border-t border-gray-200">
                {{ $footerModal }}
            </div>
        @endif
    </div>
</div>
