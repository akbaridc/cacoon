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
                            <x-button type="button" class="bg-success" @click="showModal = true; modalTitle = 'Add Role'">
                                <i class="fas fa-plus-circle me-1"></i> Add Data
                            </x-button>
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

        <x-ui.modal show="showModal">
            <x-slot:titleModal>
                <span x-text="modalTitle"></span>
            </x-slot:titleModal>

            <!-- SLOT = Body content -->
            <div class="grid grid-cols-1 md:grid-cols-2 gap-4">
                <div>
                    <x-form.input-label for="role" value="{{ __('Role Name') }}" />
                    <x-form.text-input id="role" name="role" class="mt-1 w-[70%]" x-model="payload.role" />
                </div>
            </div>

            <hr class="border-t border-gray-300">

            <!-- Permissions Tab -->
            <div>
                <x-form.input-label value="{{ __('Permissions') }}" />
                <div class="w-full overflow-x-auto" x-data="{ activeTab: '{{ menus()[0] }}' }">
                    <ul class="flex gap-4 whitespace-nowrap border-b border-gray-300">
                        @foreach (menus() as $module)
                            <li>
                                <button type="button"
                                    class="px-4 py-2 text-sm font-medium text-gray-600 border-b-2 border-transparent hover:border-blue-500 focus:border-blue-500 focus:outline-none"
                                    @click="activeTab = '{{ $module }}'"
                                    :class="activeTab === '{{ $module }}' ? 'border-blue-500 text-blue-600' : ''">
                                    {{ $module }}
                                </button>
                            </li>
                        @endforeach
                    </ul>

                    <div class="mt-4">
                        @foreach (menus() as $module)
                            <div x-show="activeTab === '{{ $module }}'" class="p-4 border rounded-md">
                                <div class="grid grid-cols-1 gap-4">
                                    @foreach (collect(menus('menu'))->filter(fn($mn) => $mn['module'] == $module) as $moduleData)
                                        @foreach ($moduleData['menu'] as $value)
                                            <div>
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

            <!-- SLOT: Footer -->
            <x-slot:footerModal>
                <x-button type="button" class="bg-secondary"
                    @click="showModal = false; roleId=''; clearChecked()">
                    <i class="fas fa-times-circle me-1"></i> Cancel
                </x-button>

                <x-button type="button" class="bg-primary"
                    @click="onSubmit($event);">
                    <i class="far fa-save me-1"></i> Submit
                </x-button>
            </x-slot:footerModal>
        </x-ui.modal>
    </section>
@endsection

@push('scripts')
    {!! $dataTable->scripts() !!}
@endpush
