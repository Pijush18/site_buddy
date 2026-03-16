<?php

use Illuminate\Support\Facades\Route;
use App\Http\Controllers\AuthController;
use App\Http\Controllers\ProjectController;
use App\Http\Controllers\ReportController;
use App\Http\Controllers\SubscriptionController;
use App\Http\Controllers\AssistantController;
use App\Http\Middleware\FirebaseAuthMiddleware;

/*
|--------------------------------------------------------------------------
| API Routes
|--------------------------------------------------------------------------
*/

Route::prefix('v1')->group(function () {

    // Health Check (Public)
    Route::get('/health', function () {
        return response()->json(['status' => 'ok']);
    });

    // Protected Routes (Require Firebase ID Token)
    Route::middleware([FirebaseAuthMiddleware::class])->group(function () {
        
        // Test Endpoint: Return authenticated user info
        Route::get('/me', function () {
            return response()->json([
                'success' => true,
                'data' => auth()->user()
            ]);
        });

        // Projects
        Route::get('/projects', [ProjectController::class, 'index']);
        Route::get('/projects/{id}', [ProjectController::class, 'show']);
        Route::post('/projects', [ProjectController::class, 'store']);

        // Reports
        Route::get('/reports/project/{projectId}', [ReportController::class, 'projectReports']);
        Route::post('/reports/upload', [ReportController::class, 'upload']);

        // Subscriptions
        Route::get('/subscription/status', [SubscriptionController::class, 'status']);
        Route::post('/subscription/activate', [SubscriptionController::class, 'activate']);

        // Assistant
        Route::post('/assistant/query', [AssistantController::class, 'query']);

        // Data Sync
        Route::post('/sync/calculations', [\App\Http\Controllers\SyncController::class, 'syncCalculations']);
    });
});
