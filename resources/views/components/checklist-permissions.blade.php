@props(['name',  'disabled' => false, 'readonly' => false])

@php
    $identityName = "checklist-permissions-{$name}";
    $identity = "checklist-permissions-!!titlePermission!!-{$name}";
    if($name == 'logs') {
        $checklistList = ['View'];
    } else {
        $checklistList = ['Create', 'View', 'Update', 'Delete'];
    }

    // if($name == 'tickets') array_push($checklistList, 'Self Ticket', 'Assign Ticket', 'Auto Fill Client', 'Comment', 'Upload Progress', 'Complete Ticket', 'Approve', 'Reject');

@endphp

<div class="flex flex-wrap items-center gap-x-6 gap-y-4 ms-4">
    @foreach ($checklistList as $index => $item)
        @php
            $nameFormat = strtolower(str_replace(' ', '-', $name));
            $valueName = strtolower(str_replace(' ', '-', $item)) . '.' . $nameFormat;
            $nameLower = $nameFormat;
        @endphp
        <label class="inline-flex items-center space-x-2">
            <input
                @disabled($disabled)
                @readonly($readonly)
                id="{{ str_replace("!!titlePermission!!", $index, $identity) }}"
                name="{{ $identityName }}"
                value="{{ $valueName }}"
                {{ $attributes->merge([
                    'type' => 'checkbox',
                    'class' => 'form-checkbox h-4 w-4 item-check text-primary cursor-pointer ' . str_replace('.', '-', $valueName) . ' ' . $identity . strtolower(str_replace(' ', '-', $item)) . ($disabled || $readonly ? ' bg-slate-100 cursor-not-allowed' : ''),
                ]) }}
            />
            <span class="text-sm font-medium text-gray-700">{{ __($item) }}</span>
        </label>
    @endforeach
</div>

