@extends('layouts.app')
@section('title', 'Create User')

@section('content')
    <section x-data="userForm()">
        <div class="row">
            <div class="col-12">
                <div class="card">
                    <div class="card-header d-flex align-items-center justify-content-between">
                        <h5 class="card-title mb-0">Create User</h5>
                    </div>
                    <div class="card-body">
                        <div class="mb-2 form-group">
                            <x-form.input-label for="nik" value="{{ __('NIK') }}" :mandatory="true" />
                            <x-form.text-input id="nik" name="nik" placeholder="enter nik" x-model="user.nik.value" />
                        </div>
                        <div class="mb-2 form-group">
                            <x-form.input-label for="name" value="{{ __('Name') }}" :mandatory="true" />
                            <x-form.text-input id="name" name="name" placeholder="enter name" x-model="user.name.value" />
                        </div>
                        <div class="mb-2 form-group">
                            <x-form.input-label for="email" value="{{ __('Email') }}" :mandatory="true" />
                            <x-form.text-input type="email" id="email" name="email" placeholder="enter email" x-model="user.email.value" />
                        </div>
                        <div class="mb-2 form-group">
                            <x-form.input-label for="password" :mandatory="true" >
                                {{ __('Password') }} <small class="font-size-10 text-muted" x-show="mode == 'edit'">Leave blank if not change</small>
                            </x-form.input-label>
                            <x-form.text-input type="password" id="password" name="password" placeholder="enter password" x-model="user.password.value" />
                        </div>
                        <div class="mb-2 form-group">
                            <x-form.input-label for="avatar">
                                {{ __('Avatar') }} <small class="font-size-10 text-muted" x-show="mode == 'edit'">Leave blank if not change</small>
                            </x-form.input-label>
                            <x-form.text-input type="file" id="avatar" name="avatar" placeholder="enter image" accept="image/*" @change="onFileChange($event)"/>
                        </div>
                        <div class="mb-2 form-group">
                            <x-form.input-label class="mb-1" for="email" value="{{ __('Role') }}" :mandatory="true" />
                            <select x-ref="roleSelected" id="role" name="role" class="form-control select-default" @change="onRoleChange($event)">
                                <option value="" selected disabled>Select Role</option>
                                @foreach($roles as $role)
                                    <option value="{{ $role->id }}">{{ $role->name }}</option>
                                @endforeach
                            </select>
                        </div>
                        <div class="mb-2 form-group">
                            <x-form.input-label class="mb-1" for="status" value="{{ __('Status') }}" />
                            <div class="status">
                                <x-form.radio-button identity="active" name="status" value="1" title="Active" x-model="user.is_active.value" />
                                <x-form.radio-button identity="inactive" name="status" value="0" title="Inactive" x-model="user.is_active.value" />
                            </div>
                        </div>

                        <div class="mt-5 flex gap-2">
                            <x-button type="button" class="bg-secondary" @click="window.location.href='{{ route('users.index') }}'" title="Back to User List">
                                <i class="far fa-arrow-alt-circle-left me-1"></i> Back
                            </x-button>

                            <x-button type="button" class="bg-primary" title="Save User" @click="onSaveUser">
                                <i class="far fa-save me-1"></i> Save
                            </x-button>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </section>
@endsection

@push('scripts')
    <script>
        let userData = @json(isset($user) ? $user : null);
    </script>
@endpush
