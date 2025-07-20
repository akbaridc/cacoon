@extends('layouts.app')
@section('title', 'Users')

@section('content')
    <section x-data="rolePermission()">
        <div class="row">
            <div class="col-12">
                <div class="card">
                    <div class="card-header d-flex align-items-center justify-content-between" x-data="">
                        <h5 class="card-title mb-0">Users</h5>
                        @if (auth()->user()->hasPermissionTo('create.users'))
                            <x-button.primary-button type="button" @click="window.location.href='{{ route('users.create') }}'">
                                <i class="fas fa-plus-circle me-1"></i> Add User
                            </x-button.primary-button>
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
