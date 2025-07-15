@extends('layouts.app')
@section('title', 'Role & Permission')

@section('content')
    <section x-data="rolePermission()">
        <div class="row">
            <div class="col-12">
                <div class="card">
                    <div class="card-header d-flex align-items-center justify-content-between" x-data="">
                        <h5 class="card-title mb-0">Role & Permission</h5>
                        @if (auth()->user()->hasPermissionTo('create.permissions'))
                            <button class="btn btn-primary" onclick="$('#modalRoles').modal('show'); $('#modalRoles .modal-title').html('Add Role')">Add Data</button>
                        @endif
                    </div>
                    <div class="card-body">
                        <div class="table-responsive">
                            {!! $dataTable->table(['class' => 'table table-striped dt-responsive nowrap align-middle w-100']) !!}
                        </div>
                    </div>
                </div>
            </div>
        </div>

        <div class="modal fade" id="modalRoles" data-bs-backdrop="static" data-bs-keyboard="false" tabindex="-1" aria-labelledby="modalRolesLabel" aria-hidden="true">
            <div class="modal-dialog modal-lg">
                <div class="modal-content">
                    <form>
                        <div class="modal-header">
                            <h1 class="modal-title fs-5" id="modalRolesLabel">Modal title</h1>
                        </div>
                        <div class="modal-body">
                            <div class="row">
                                <div class="col-md-6">
                                    <x-form.input-label for="role" value="{{ __('Role Name') }}" />
                                    <x-form.text-input id="role" name="role" class="mt-1" x-model="payload.role"/>
                                </div>
                                <hr class="my-3">
                                <div class="col-md-12">
                                    <x-form.input-label value="{{ __('Permissions') }}" />
                                    <div class="w-full overflow-x-auto" x-data="{ activeTab: '{{ menus()[0] }}' }">
                                        <ul class="flex gap-4 whitespace-nowrap border-b border-gray-300">
                                            @foreach (menus() as $module)
                                                <li>
                                                    <button type="button" class="px-4 py-2 text-sm font-medium text-gray-600 border-b-2 border-transparent hover:border-blue-500 focus:border-blue-500 focus:outline-none"
                                                        @click="activeTab = '{{ $module }}'"
                                                        :class="activeTab === '{{ $module }}' ? 'border-blue-500 text-blue-600' : ''">
                                                        {{ $module }}
                                                    </button>
                                                </li>
                                            @endforeach
                                        </ul>

                                        <!-- Tab Content -->
                                        <div class="mt-4">
                                            @foreach (menus() as $module)
                                                <div x-show="activeTab === '{{ $module }}'" class="p-4  border rounded">
                                                    <div class="row">
                                                        @foreach (collect(menus('menu'))->filter(function($mn) use($module) {
                                                            return $mn['module'] == $module;
                                                        }) as $moduleData)
                                                            @foreach ($moduleData['menu'] as $value)
                                                                <div class="col-xl-12 col-lg-12 col-md-12 col-sm-12 col-xs-12 mb-3">
                                                                    <x-form.input-label for="{{ $value['permission_name'] }}" value="{{ __($value['name']) }}" />
                                                                    <x-checklist-permissions name="{{ $value['permission_name'] }}" class="{{ $value['permission_name'] }}" />
                                                                </div>
                                                            @endforeach
                                                        @endforeach
                                                    </div>
                                                </div>
                                            @endforeach
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </div>
                        <div class="modal-footer">
                            <button type="button" class="btn btn-secondary" @click="$('#modalRoles').modal('hide'); roleId='';clearChecked()">Close</button>
                            <button type="button" class="btn btn-primary" @click="onSubmit($event)">Submit</button>
                        </div>
                    </form>
                </div>
            </div>
        </div>
    </section>
@endsection

@push('scripts')
    {!! $dataTable->scripts() !!}
    @vite(['resources/js/pages/settings/role-permission/index.js'])
@endpush
