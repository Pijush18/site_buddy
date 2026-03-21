<?php

namespace App\Http\Controllers\API;

use App\Http\Controllers\Controller;
use App\Helpers\ApiResponse;
use Illuminate\Http\JsonResponse;

/**
 * Base Controller for API
 * All API controllers should extend this class
 */
abstract class BaseController extends Controller
{
    /**
     * Send success response
     */
    protected function success(string $message = 'Success', mixed $data = null, int $code = 200): JsonResponse
    {
        return ApiResponse::success($message, $data, $code);
    }

    /**
     * Send error response
     */
    protected function error(string $message = 'Error', mixed $errors = null, int $code = 400): JsonResponse
    {
        return ApiResponse::error($message, $errors, $code);
    }
}
