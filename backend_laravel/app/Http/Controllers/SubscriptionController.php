<?php

namespace App\Http\Controllers;

use App\Services\SubscriptionService;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Validator;

class SubscriptionController extends Controller
{
    protected $subscriptionService;

    public function __construct(SubscriptionService $subscriptionService)
    {
        $this->subscriptionService = $subscriptionService;
    }

    /**
     * Get the current authenticated user's subscription status.
     */
    public function status(Request $request)
    {
        $user = auth()->user();
        $status = $this->subscriptionService->getSubscriptionStatus($user->id);

        return response()->json([
            'success' => true,
            'data' => $status
        ]);
    }

    /**
     * Activate or upgrade a subscription plan.
     */
    public function activate(Request $request)
    {
        $user = auth()->user();

        // 1. Validation
        $validator = Validator::make($request->all(), [
            'provider' => 'required|string|in:razorpay,play_store,manual',
            'transaction_id' => 'required|string',
            'plan' => 'required|string|in:pro',
        ]);

        if ($validator->fails()) {
            return response()->json([
                'success' => false,
                'error' => 'Validation failed: ' . $validator->errors()->first()
            ], 422);
        }

        // 2. Proccess Activation
        try {
            $subscription = $this->subscriptionService->activateSubscription($user->id, $request->all());

            return response()->json([
                'success' => true,
                'data' => $subscription,
                'message' => 'Subscription activated successfully.'
            ]);
        } catch (\Exception $e) {
            return response()->json([
                'success' => false,
                'error' => 'Could not activate subscription: ' . $e->getMessage()
            ], 500);
        }
    }
}
