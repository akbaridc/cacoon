@extends('layouts.app')
@section('title', 'Setting Application')

@section('content')
    <section x-data="settingApplication()" x-init='Object.assign(payload, @json($initialPayload))'>
        <div class="row">
            <div class="col-12">
                <div class="card">
                    <div class="card-header d-flex align-items-center justify-content-between">
                        <h5 class="card-title mb-0">Setting Application</h5>
                    </div>
                    <div class="card-body">
                        <div class="row">
                            <div class="col-md-3 mb-3">
                                <x-form.input-label class="mb-2" value="{{ __('Application Name') }}" />
                                <p x-show="!editMode" x-text="payload.application_name"></p>
                                <x-form.text-input x-show="editMode" class="ps-0 w-full lg:w-full sm:w-full" type="text" id="application_name" name="application_name" placeholder="enter application name" x-model="payload.application_name" />
                            </div>

                            <div class="col-md-3 mb-3">
                                <x-form.input-label class="mb-2" value="{{ __('Email Provider') }}" />
                                <p x-show="!editMode" x-text="payload.email_send_provider"></p>
                                <x-form.text-input x-show="editMode" class="ps-0 w-full lg:w-full sm:w-full" type="text" id="email_send_provider" name="email_send_provider" placeholder="enter email provider" x-model="payload.email_send_provider" />
                            </div>

                            <div class="col-md-3 mb-3">
                                <x-form.input-label class="mb-2" value="{{ __('Password Email Provider') }}" />
                                <p x-show="!editMode" x-text="payload.email_send_password_provider"></p>
                                <x-form.text-input x-show="editMode" class="ps-0 w-full lg:w-full sm:w-full" type="text" id="email_send_password_provider" name="email_send_password_provider" placeholder="enter password email provider" x-model="payload.email_send_password_provider" />
                            </div>

                            <div class="col-md-3 mb-3">
                                <x-form.input-label class="mb-2" value="{{ __('Email Receive Authentication') }}" />
                                <p x-show="!editMode" x-text="payload.email_receive_authentication"></p>
                                <x-form.text-input x-show="editMode" class="ps-0 w-full lg:w-full sm:w-full" type="text" id="email_receive_authentication" name="email_receive_authentication" placeholder="enter email receive authentication" x-model="payload.email_receive_authentication" />
                            </div>
                        </div>

                        <div class="mt-5 flex gap-2 section-button">
                            @if (auth()->user()->hasPermissionTo('edit.permissions'))
                                <x-button x-show="!editMode" type="button" class="bg-warning" @click="editMode = true">
                                    <i class="fas fa-pencil-alt me-1"></i> Edit
                                </x-button>
                            @endif

                            <x-button x-show="editMode" class="bg-danger" type="button" @click="editMode = false">
                                <i class="fas fa-times-circle me-1"></i> Cancel
                            </x-button>

                            <x-button x-show="editMode" class="bg-primary" type="button" @click="onSubmit($event)">
                                <i class="far fa-save me-1"></i> Save
                            </x-button>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </section>
@endsection
