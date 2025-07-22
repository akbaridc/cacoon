@extends('layouts.app')
@section('title', 'Palka')

@section('content')
    <section x-data="palkaData()">
        <div class="row">
            <div class="col-12">
                <div class="card">
                    <div class="card-header d-flex align-items-center justify-content-between" x-data="">
                        <h5 class="card-title mb-0">Palka</h5>
                        @if (auth()->user()->hasPermissionTo('create.palka'))
                            <x-button type="button" class="bg-primary" @click="showModal = true; modalTitle = 'Add Palka'">
                                <i class="fas fa-plus-circle me-1"></i> Add Palka
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

        <x-ui.modal show="showModal" class="w-[90%] sm:w-[50%] md:w-1/4">
            <x-slot:titleModal>
                <span x-text="modalTitle"></span>
            </x-slot:titleModal>

            <!-- SLOT = Body content -->
            <div class="mb-3">
                <x-form.input-label for="palka" value="{{ __('Name') }}" />
                <x-form.text-input id="palka" name="palka" class="mt-1 w-full lg:w-full sm:w-full" x-model="payload.palka.value" />
            </div>

            <div class="mb-3">
                <x-form.input-label for="status" value="{{ __('Status') }}" />
                <div class="status">
                    <x-form.radio-button identity="active" name="status" value="1" title="Active" x-model="payload.status.value" />
                    <x-form.radio-button identity="inactive" name="status" value="0" title="Inactive" x-model="payload.status.value" />
                </div>
            </div>

            <!-- SLOT: Footer -->
            <x-slot:footerModal>
                <x-button type="button" class="bg-secondary"
                    @click="showModal = false; clearField()">
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
