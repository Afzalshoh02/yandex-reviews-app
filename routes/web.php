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



Route::get('/debug-assets', function() {
    $manifestPath = public_path('build/manifest.json');

    return response()->json([
        'manifest_exists' => file_exists($manifestPath),
        'build_dir_exists' => is_dir(public_path('build')),
        'assets_in_manifest' => file_exists($manifestPath) ? json_decode(file_get_contents($manifestPath), true) : 'No manifest',
        'files_in_build' => file_exists(public_path('build')) ? array_slice(scandir(public_path('build')), 2) : []
    ]);
});
