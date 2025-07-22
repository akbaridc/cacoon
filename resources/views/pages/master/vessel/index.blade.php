@extends('layouts.app')
@section('title', 'Vessel')

@section('content')
    <section x-data="vesselData()">
        <div class="row">
            <div class="col-12">
                <div class="card">
                    <div class="card-header d-flex align-items-center justify-content-between" x-data="">
                        <h5 class="card-title mb-0">Vessel</h5>
                        @if (auth()->user()->hasPermissionTo('synscronize.vessel'))
                            <x-button type="button" class="bg-success" @click="onSync()">
                                <i class="fas fa-plus-circle me-1"></i> Sync
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
    </section>
@endsection

@push('scripts')
    {!! $dataTable->scripts() !!}
@endpush
