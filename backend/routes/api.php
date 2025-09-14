<?php

use Illuminate\Support\Facades\Route;
use App\Http\Controllers\AuthController;

Route::post('/register', [AuthController::class, 'register']);
Route::post('/login', [AuthController::class, 'login']);

// Test route to check if API is working
Route::get('/test', function() {
    return response()->json(['message' => 'API is working!']);
});
