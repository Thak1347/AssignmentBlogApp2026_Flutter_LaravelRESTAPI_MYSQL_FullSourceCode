<?php

use App\Http\Controllers\AuthController;
use App\Http\Controllers\CommentController;
use App\Http\Controllers\PostController;
use Illuminate\Support\Facades\Route;

// Public routes - no authentication required
Route::post('/register', [AuthController::class, 'register']);
Route::post('/login', [AuthController::class, 'login']);

// Protected routes - require authentication
Route::middleware('auth:sanctum')->group(function () {
    // User routes
    Route::get('/current-user', [AuthController::class, 'currentUser']);
    Route::post('/logout', [AuthController::class, 'logout']);

    // Post routes
    Route::get('/posts', [PostController::class, 'index']);
    Route::post('/posts', [PostController::class, 'store']);
    Route::get('/posts/{id}', [PostController::class, 'show']);
    Route::put('/posts/{id}', [PostController::class, 'update']); 
    Route::delete('/posts/{id}', [PostController::class, 'destroy']);

    // Comment routes
    Route::get('/posts/{postId}/comments', [CommentController::class, 'index']);
    Route::post('/posts/{postId}/comments', [CommentController::class, 'store']);
    Route::delete('/comments/{id}', [CommentController::class, 'destroy']);
});