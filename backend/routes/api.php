<?php

use Illuminate\Support\Facades\Route;
use App\Http\Controllers\AuthController;
use App\Http\Controllers\ProductController;
<<<<<<< HEAD
use App\Http\Controllers\Auth\ForgotPasswordController; // ADD THIS
use App\Http\Controllers\CategoryController;
=======
>>>>>>> 433df56c2af04b054ab4899e73a887e23f80d614

Route::get('/products', [ProductController::class, 'index']);
Route::post('/products', [ProductController::class, 'store']);
Route::post('/register', [AuthController::class, 'register']);
Route::post('/login', [AuthController::class, 'login']);
Route::put('/products/{product}/categories', [ProductController::class, 'updateCategories']);

Route::get('/categories', [CategoryController::class, 'index']);
Route::post('/categories', [CategoryController::class, 'store']);
Route::get('/categories/{slug}', [CategoryController::class, 'showBySlug']);


// ADD THESE ROUTES
Route::post('/forgot-password', [ForgotPasswordController::class, 'sendResetLinkEmail']);
Route::post('/reset-password', [ForgotPasswordController::class, 'resetPassword']);

<<<<<<< HEAD
=======
// Products
Route::get('/products', [ProductController::class, 'index']);
Route::post('/products', [ProductController::class, 'store']);

// Test route to check if API is working
>>>>>>> 433df56c2af04b054ab4899e73a887e23f80d614
Route::get('/test', function() {
    return response()->json(['message' => 'API is working!']);
});


