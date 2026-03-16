<?php

namespace App\Services;

use App\Repositories\CalculationRepository;
use Illuminate\Support\Facades\DB;

class SyncService
{
    protected $calculationRepository;

    public function __construct(CalculationRepository $calculationRepository)
    {
        $this->calculationRepository = $calculationRepository;
    }

    /**
     * Synchronize a batch of calculation records from a client device.
     */
    public function syncCalculations(int $userId, array $batch)
    {
        $results = [
            'synced' => 0,
            'errors' => 0,
            'details' => []
        ];

        DB::beginTransaction();
        try {
            foreach ($batch as $item) {
                // Ensure idempotency using device_id and client-side created_at
                $attributes = [
                    'user_id' => $userId,
                    'device_id' => $item['device_id'] ?? 'unknown',
                    'created_at' => $item['created_at'],
                ];

                $values = [
                    'project_id' => $item['project_id'],
                    'type' => $item['type'],
                    'input_data' => $item['input_data'],
                    'result_data' => $item['result_data'],
                    'synced_at' => now(),
                ];

                $this->calculationRepository->updateOrCreate($attributes, $values);
                $results['synced']++;
            }
            DB::commit();
        } catch (\Exception $e) {
            DB::rollBack();
            $results['errors']++;
            $results['details'][] = $e->getMessage();
        }

        return $results;
    }
}
