@props(['name',  'disabled' => false, 'readonly' => false])

@php
    $identityName = "checklist-permissions-{$name}";
    $identity = "checklist-permissions-{$name}-";
    if($name == 'logs') {
        $checklistList = ['View'];
    } else {
        $checklistList = ['Create', 'View', 'Update', 'Delete', 'Print'];
    }

    // if($name == 'tickets') array_push($checklistList, 'Self Ticket', 'Assign Ticket', 'Auto Fill Client', 'Comment', 'Upload Progress', 'Complete Ticket', 'Approve', 'Reject');

@endphp

<div class="d-flex flex-wrap gap-3 ms-4">
    @foreach ($checklistList as $index => $item)
        @php
            $nameFormat = strtolower(str_replace(' ', '-', $name));
            $valueName = strtolower(str_replace(' ', '-', $item)) . '.' . $nameFormat;
            $nameLower = $nameFormat;
        @endphp
        <div class="form-check mb-3">
            <input @disabled($disabled) @readonly($readonly) id="{{ $identity . $index }}" name="{{ $identityName }}"
                {{ $attributes->merge([
                    'type' => 'checkbox',
                    'class' => 'form-check-input scale-100 item-check mt-2 ' . str_replace('.', '-', $valueName) . ' ' . $identity . strtolower(str_replace(' ', '-', $item)) . ' '  . ($disabled || $readonly ? ' bg-slate-100 cursor-not-allowed' : ''),
                ]) }}
                value="{{ $valueName }}" />
            <x-form.input-label class="form-check-label" for="{{ $identity . $index  }}" value="{{ __($item) }}" />
        </div>
    @endforeach
</div>
