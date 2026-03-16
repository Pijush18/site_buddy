<?php

namespace App\Repositories;

use App\Models\Calculation;

class CalculationRepository
{
    /**
     * Find an existing calculation by unique client-side identifiers for idempotency.
     */
    public function findExisting(int $userId, string $deviceId, string $createdAt)
    {
        return Calculation::where('user_id', $userId)
            ->where('device_id', $deviceId)
            ->where('created_at', $createdAt)
            ->first();
    }

    /**
     * Create or update a calculation record.
     */
    public function updateOrCreate(array $attributes, array $values)
    {
        return Calculation::updateOrCreate($attributes, $values);
    }

    /**
     * Get all calculations for a specific project.
     */
    public function getByProjectId(int $projectId)
    {
        return Calculation::where('project_id', $projectId)->get();
    }
}
