<?php

namespace App\Repositories;

use App\Models\User;
use Illuminate\Support\Facades\DB;

/**
 * Health Repository
 * Handles database health checks
 */
class HealthRepository extends BaseRepository
{
    /**
     * HealthRepository constructor.
     * Uses the User model as a baseline for the repository
     */
    public function __construct(User $user)
    {
        parent::__construct($user);
    }

    /**
     * Check if the database connection is active
     *
     * @return bool
     */
    public function checkDatabaseConnection(): bool
    {
        try {
            DB::connection()->getPdo();
            return true;
        } catch (\Exception $e) {
            return false;
        }
    }
}
