<?php

namespace App\Http\Controllers\API\V1;

use App\Http\Controllers\API\BaseController;
use App\Services\HealthService;
use Illuminate\Http\JsonResponse;

/**
 * Health Controller
 * Demonstrates the full layered architecture for a simple health check
 */
class HealthController extends BaseController
{
    protected $healthService;

    /**
     * HealthController constructor.
     * @param HealthService $healthService
     */
    public function __construct(HealthService $healthService)
    {
        $this->healthService = $healthService;
    }

    /**
     * API Health Check
     * 
     * @return JsonResponse
     */
    public function check(): JsonResponse
    {
        $status = $this->healthService->getApiStatus();

        return $this->success('API is healthy and running', $status);
    }
}
