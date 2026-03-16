<?php

namespace App\Http\Controllers;

use App\Services\SyncService;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Validator;

class SyncController extends Controller
{
    protected $syncService;

    public function __construct(SyncService $syncService)
    {
        $this->syncService = $syncService;
    }

    /**
     * Handle batch synchronization of engineering calculations.
     */
    public function syncCalculations(Request $request)
    {
        $user = auth()->user();

        // 1. Validation
        $validator = Validator::make($request->all(), [
            'batch' => 'required|array|min:1',
            'batch.*.project_id' => 'required|exists:projects,id',
            'batch.*.type' => 'required|string',
            'batch.*.input_data' => 'required|array',
            'batch.*.result_data' => 'required|array',
            'batch.*.device_id' => 'required|string',
            'batch.*.created_at' => 'required|date',
        ]);

        if ($validator->fails()) {
            return response()->json([
                'success' => false,
                'error' => 'Validation failed: ' . $validator->errors()->first()
            ], 422);
        }

        // 2. Process Sync via Service
        $result = $this->syncService->syncCalculations($user->id, $request->input('batch'));

        // 3. Response
        if ($result['errors'] > 0) {
            return response()->json([
                'success' => false,
                'error' => 'Sync partially failed.',
                'details' => $result
            ], 500);
        }

        return response()->json([
            'success' => true,
            'data' => $result,
            'message' => 'Calculations synchronized successfully.'
        ]);
    }
}
