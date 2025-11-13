{{--<!DOCTYPE html>--}}
{{--<html lang="{{ str_replace('_', '-', app()->getLocale()) }}">--}}
{{--<head>--}}
{{--    <meta charset="utf-8">--}}
{{--    <meta name="viewport" content="width=device-width, initial-scale=1">--}}
{{--    <title>Review Manager</title>--}}

{{--    <!-- Fonts -->--}}
{{--    <link rel="preconnect" href="https://fonts.bunny.net">--}}
{{--    <link href="https://fonts.bunny.net/css?family=inter:400,500,600,700" rel="stylesheet" />--}}

{{--    @vite(['resources/css/app.css', 'resources/js/app.js'])--}}
{{--</head>--}}
{{--<body class="font-sans antialiased">--}}
{{--<div id="app"></div>--}}
{{--</body>--}}
{{--</html>--}}



    <!DOCTYPE html>
<html>
<head>
    <meta charset="utf-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <title>Your App</title>

    <!-- Используйте прямые пути вместо mix() -->
    <link rel="stylesheet" href="{{ asset('css/app.css') }}">
</head>
<body>
<div id="app"></div>

<!-- Используйте прямые пути вместо mix() -->
<script src="{{ asset('js/app.js') }}"></script>
</body>
</html>

