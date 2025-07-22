@props(['title', 'identity' => '', 'checked' => false, 'value' => '', 'name' => '', 'xModel' => ''])

<div class="form-check form-check-inline">
    <input type="radio" id="{{ $identity }}" name="{{ $name }}" value="{{ $value }}" @if ($xModel) x-model="{{ $xModel }}" @endif  {{ $attributes->merge(['class' => 'form-check-input']) }}>
    <label class="form-check-label" for="{{ $identity }}">{{ $title }}</label>
</div>
