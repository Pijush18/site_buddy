<?php

namespace App\Services;

use App\Repositories\HealthRepository;

/**
 * Health Service
 * Handles the business logic for the API health check
 */
class HealthService extends BaseService
{
    protected $healthRepository;

    /**
     * HealthService constructor.
     * @param HealthRepository $healthRepository
     */
    public function __construct(HealthRepository $healthRepository)
    {
        $this->healthRepository = $healthRepository;
    }

    /**
     * Get API Status
     * Returns the current API status and checks the DB connection
     *
     * @return array
     */
    public function getApiStatus(): array
    {
        $dbStatus = $this->healthRepository->checkDatabaseConnection();

        return [
            'version' => '1.0.0',
            'status' => 'ok',
            'database' => $dbStatus ? 'connected' : 'disconnected',
            'environment' => config('app.env'),
            'timestamp' => now()->toIso8601String()
        ];
    }
}
