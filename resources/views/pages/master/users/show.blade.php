@extends('layouts.app')
@section('title', 'View User')

@section('content')
    <section>
        <div class="row">
            <div class="col-12">
                <div class="card">
                    <div class="card-header d-flex align-items-center justify-content-between">
                        <h5 class="card-title mb-0">View User</h5>
                    </div>
                    <div class="card-body">
                        <div class="row">
                            <div class="col-md-3 mb-3">
                                <x-form.input-label class="mb-2" value="{{ __('Picture') }}" />
                                <img src="{{ $user->getFirstMediaUrl('avatars', 'thumb') ?? asset('images/default-image.png') }}" alt="user picture" class="thumb-xl rounded-circle">
                            </div>

                            <div class="col-md-3 mb-3">
                                <x-form.input-label class="mb-2" value="{{ __('NIK') }}" />
                                <p>{{ $user->nik ?? '-' }}</p>
                            </div>

                            <div class="col-md-3 mb-3">
                                <x-form.input-label class="mb-2" value="{{ __('Name') }}" />
                                <p>{{ $user->name ?? '-' }}</p>
                            </div>

                            <div class="col-md-3 mb-3">
                                <x-form.input-label class="mb-2" value="{{ __('Email') }}" />
                                <p>{{ $user->email ?? '-' }}</p>
                            </div>

                            <div class="col-md-3 mb-3">
                                <x-form.input-label class="mb-2" value="{{ __('Role') }}" />
                                <p>{{ $user->role_name ?? '-' }}</p>
                            </div>
                        </div>

                        <div class="mt-5 flex gap-2">
                            <x-button.secondary-button type="button" onclick="window.location.href='{{ route('users.index') }}'" title="Back to User List">
                                <i class="far fa-arrow-alt-circle-left me-1"></i> Back
                            </x-button.secondary-button>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </section>
@endsection
