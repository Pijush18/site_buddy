<?php

namespace App\Helpers;

use Illuminate\Http\JsonResponse;

/**
 * Standard API Response Helper
 * Ensures consistent response format across entire backend
 */
class ApiResponse
{
    public static function success(
        string $message = 'Success',
        mixed $data = null,
        int $code = 200
        ): JsonResponse
    {
        return response()->json([
            'status' => true,
            'message' => $message,
            'data' => $data,
            'errors' => null,
        ], $code);
    }

    public static function error(
        string $message = 'Something went wrong',
        mixed $errors = null,
        int $code = 400
        ): JsonResponse
    {
        return response()->json([
            'status' => false,
            'message' => $message,
            'data' => null,
            'errors' => $errors,
        ], $code);
    }
}