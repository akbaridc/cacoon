@section('title', 'Login')
@push('scripts')
    @vite(['resources/js/authentication/index.js'])
@endpush

<x-guest-layout>
    <div class="card-body">
        <div class="row">
            <div class="col-lg-4 col-md-4 col-sm-8 col-sm-8 mx-auto">
                <div class="card">
                    <div class="card-body p-0 bg-black auth-header-box rounded-top">
                        <div class="text-center p-3">
                            <a href="{{ url('/') }}" class="logo logo-admin mb-3">
                                <img src="{{ asset('templates/images/logo-sm.png') }}" alt="logo-small" class="logo-sm">
                            </a>
                            <h4 class="mt-3 mb-1 fw-semibold text-white fs-18">Let's Get Started Cacoon</h4>
                            <p class="text-muted fw-medium mb-0">Sign in to continue to Cacoon.</p>
                        </div>
                    </div>
                    <div class="card-body pt-0">
                        <form class="my-4" id="loginForm" x-data="loginForm()">
                            <div class="form-group mb-2">
                                <x-form.input-label class="form-label" for="email" value="Email" />
                                <input type="email" class="form-control" id="email" name="email" placeholder="Enter email" @keyup="payload.email = $event.target.value; errorCustom.clearErrorInput('#email')">
                            </div>

                            <div class="form-group">
                                <x-form.input-label class="form-label" for="password" value="Password" />
                                <input type="password" class="form-control" name="password" id="password" placeholder="Enter password" @keyup="payload.password = $event.target.value; errorCustom.clearErrorInput('#password')">
                            </div>

                            <div class="form-group row mt-3">
                                <div class="col-sm-6">
                                    <div class="form-check form-switch form-switch-success">
                                        <input class="form-check-input" type="checkbox" id="remember_me" name="remember" x-model="payload.remember">
                                        <label class="form-check-label" for="remember_me">Remember me</label>
                                    </div>
                                </div>
                            </div>

                            <div class="form-group mb-0 row">
                                <div class="col-12">
                                    <div class="d-grid mt-3">
                                        <button class="btn btn-primary" type="submit" @click="login($event)">Log In <i class="fas fa-sign-in-alt ms-1"></i></button>
                                    </div>
                                </div>
                            </div>
                        </form>
                    </div>
                </div>
            </div>
        </div>
    </div>
</x-guest-layout>
