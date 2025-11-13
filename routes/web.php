<?php

use Illuminate\Support\Facades\DB;
use Illuminate\Support\Facades\Route;

/*
|--------------------------------------------------------------------------
| Web Routes
|--------------------------------------------------------------------------
|
| Here is where you can register web routes for your application. These
| routes are loaded by the RouteServiceProvider and all of them will
| be assigned to the "web" middleware group. Make something great!
|
*/

Route::get('/{any}', function () {
    return view('app');
})->where('any', '.*');

Route::get('/health', function () {
    return response()->json([
        'status' => 'ok',
        'timestamp' => now(),
        'environment' => app()->environment(),
    ]);
});
Route::get('/debug', function () {
    try {
        DB::statement('SELECT 1');
        $db = 'Database connection: OK';
    } catch (\Exception $e) {
        $db = 'Database connection failed: ' . $e->getMessage();
    }

    return response()->json([
        'php_version' => PHP_VERSION,
        'laravel_version' => app()->version(),
        'environment' => app()->environment(),
        'debug_mode' => config('app.debug'),
        'database' => $db,
        'storage_writable' => is_writable(storage_path()),
        'bootstrap_writable' => is_writable(base_path('bootstrap/cache')),
    ]);
});
