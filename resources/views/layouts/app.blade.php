<!DOCTYPE html>
<html lang="en" dir="ltr" data-startbar="light" data-bs-theme="light">

<head>
    <meta charset="utf-8" />
    <title>{{ config('app.name', 'Laravel') }} | @yield('title')</title>
    <meta name="csrf-token" content="{{ csrf_token() }}">

    <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">
    <meta content="Premium Multipurpose Admin & Dashboard Template" name="description" />
    <meta content="" name="author" />
    <meta http-equiv="X-UA-Compatible" content="IE=edge" />

    <link rel="shortcut icon" href="{{ asset('templates/images/favicon.ico') }}">

    <link href="{{ asset('templates/libs/datatables.net-bs5/css/dataTables.bootstrap5.min.css') }} " rel="stylesheet" type="text/css" />
    <link href="{{ asset('templates/libs/datatables.net-responsive-bs5/css/responsive.bootstrap5.min.css') }} " rel="stylesheet" type="text/css" />
    <link href="{{ asset('templates/libs/datatables.net-buttons-bs5/css/buttons.bootstrap5.min.css') }} " rel="stylesheet" type="text/css" />
    <link href="{{ asset('templates/libs/datatables.net-select-bs5/css//select.bootstrap5.min.css') }} " rel="stylesheet" type="text/css" />
    <link href="{{ asset('templates/css/bootstrap.min.css') }}" rel="stylesheet" type="text/css" />
    <link href="{{ asset('templates/css/icons.min.css') }}" rel="stylesheet" type="text/css" />
    <link href="{{ asset('templates/css/app.min.css') }}" rel="stylesheet" type="text/css" />

    <script>
        const csrfToken = "{{ csrf_token() }}";
    </script>

    @vite(['resources/css/app.css','resources/js/app.js'])
</head>

<body>
    <div class="topbar d-print-none">
        <div class="container-xxl">
            <x-layouts.navbar />
        </div>
    </div>
    <div class="startbar d-print-none">
        <div class="brand">
            <a href="index.html" class="logo">
                <span>
                    <img src="{{ asset('templates/images/logo-sm.png') }}" alt="logo-small" class="logo-sm">
                </span>
                <span class="">
                    <img src="{{ asset('templates/images/logo-light.png') }}" alt="logo-large" class="logo-lg logo-light">
                    <img src="{{ asset('templates/images/logo-dark.png') }}" alt="logo-large" class="logo-lg logo-dark">
                </span>
            </a>
        </div>
        <x-layouts.sidebar />
    </div>
    <div class="startbar-overlay d-print-none"></div>

    <div class="page-wrapper">

        <div class="page-content">
            <div class="container-xxl">
                @yield('content')
            </div>

            <x-layouts.footer />
        </div>
    </div>

    <x-dialog.confirm-dialog />

    <script src="https://code.jquery.com/jquery-3.7.1.min.js"></script>
    <script src="{{ asset('templates/libs/bootstrap/js/bootstrap.bundle.min.js') }}"></script>
    <script src="{{ asset('templates/libs/datatables.net/js/jquery.dataTables.min.js') }}"></script>
    <script src="{{ asset('templates/libs/datatables.net-bs5/js/dataTables.bootstrap5.min.js') }}"></script>
    <script src="{{ asset('templates/libs/datatables.net-responsive/js/dataTables.responsive.min.js') }}"></script>
    <script src="{{ asset('templates/libs/datatables.net-responsive-bs5/js/responsive.bootstrap5.min.js') }}"></script>
    <script src="{{ asset('templates/libs/datatables.net-buttons/js/dataTables.buttons.min.js') }}"></script>
    <script src="{{ asset('templates/libs/datatables.net-buttons-bs5/js/buttons.bootstrap5.min.js') }}"></script>
    <script src="{{ asset('templates/libs/datatables.net-buttons/js/buttons.html5.min.js') }}"></script>
    <script src="{{ asset('templates/libs/datatables.net-buttons/js/buttons.flash.min.js') }}"></script>
    <script src="{{ asset('templates/libs/datatables.net-buttons/js/buttons.print.min.js') }}"></script>
    <script src="{{ asset('templates/libs/datatables.net-keytable/js/dataTables.keyTable.min.js') }}"></script>
    <script src="{{ asset('templates/libs/datatables.net-select/js/dataTables.select.min.js') }}"></script>
    <script src="{{ asset('templates/js/app.js') }}"></script>

    <script>
        const darkMode = localStorage.getItem('dark_mode');
        if (darkMode === 'true') {
            document.body.classList.add('dark-mode');
        } else {
            document.body.classList.remove('dark-mode');
        }

        //ubah di tag html attribute data-bs-theme
        const isDark = document.body.classList.contains('dark-mode');
        document.querySelector('html').setAttribute('data-bs-theme', isDark ? 'dark' : 'light');
    </script>

    @stack('scripts')
</body>
</html>
