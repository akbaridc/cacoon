<!DOCTYPE html>
<html lang="en" dir="ltr" data-startbar="light" data-bs-theme="light">
<head>
    <meta charset="utf-8" />
    <title>{{ config('app.name', 'Laravel') }} | @yield('title')</title>
    <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">
    <meta content="Premium Multipurpose Admin & Dashboard Template" name="description" />
    <meta content="" name="author" />
    <meta http-equiv="X-UA-Compatible" content="IE=edge" />
    <meta name="csrf-token" content="{{ csrf_token() }}">

    <link rel="shortcut icon" href="{{ asset('templates/') }}images/favicon.ico">

    <link href="{{ asset('templates/css/bootstrap.min.css') }}" rel="stylesheet" type="text/css" />
    <link href="{{ asset('templates/css/icons.min.css') }}" rel="stylesheet" type="text/css" />
    <link href="{{ asset('templates/css/app.min.css') }}" rel="stylesheet" type="text/css" />

    <script>
        const csrfToken = "{{ csrf_token() }}";
    </script>

    @vite(['resources/js/app.js'])
</head>
<body>
    <div class="container-xxl">
        <div class="row vh-100 d-flex justify-content-center">
            <div class="col-12 align-self-center">
                {{ $slot }}
            </div>
        </div>
    </div>

    <x-ui.loading />

    @stack('scripts')
</body>
</html>
