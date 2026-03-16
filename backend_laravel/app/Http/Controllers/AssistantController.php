<?php

namespace App\Http\Controllers;

use App\Services\AssistantService;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Validator;

class AssistantController extends Controller
{
    protected $assistantService;

    public function __construct(AssistantService $assistantService)
    {
        $this->assistantService = $assistantService;
    }

    /**
     * Process an engineering query and return suggestions.
     */
    public function query(Request $request)
    {
        // 1. Validation
        $validator = Validator::make($request->all(), [
            'query' => 'required|string|max:500',
        ]);

        if ($validator->fails()) {
            return response()->json([
                'success' => false,
                'error' => 'Invalid query: ' . $validator->errors()->first()
            ], 422);
        }

        // 2. Process query via Service
        try {
            $result = $this->assistantService->query($request->input('query'));

            // 3. Return Standardized JSON Response
            return response()->json([
                'success' => true,
                'data' => $result
            ]);
        } catch (\Exception $e) {
            return response()->json([
                'success' => false,
                'error' => 'An unexpected error occurred processing your query.'
            ], 500);
        }
    }
}
