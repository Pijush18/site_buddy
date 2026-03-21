<?php

use Illuminate\Support\Facades\Route;
use App\Http\Controllers\API\V1\HealthController;
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
| Version: V1
| Architecture: Controller -> Service -> Repository
*/

Route::prefix('v1')->group(function () {

    /**
     * Public Routes
     */
    Route::get('/health', [HealthController::class, 'check']);

    /**
     * Protected Routes (Require Firebase ID Token)
     */
    Route::middleware([FirebaseAuthMiddleware::class])->group(function () {
        
        // Authenticated User
        Route::get('/me', function () {
            return response()->json([
                'status' => true,
                'message' => 'User retrieved',
                'data' => auth()->user(),
                'errors' => null
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

        // AI Assistant
        Route::post('/assistant/query', [AssistantController::class, 'query']);

        // Data Sync
        Route::post('/sync/calculations', [\App\Http\Controllers\SyncController::class, 'syncCalculations']);
    });
});
