<?php

namespace App\Services;

use App\Repositories\SubscriptionRepository;
use Carbon\Carbon;

class SubscriptionService
{
    protected $subscriptionRepository;

    public function __construct(SubscriptionRepository $subscriptionRepository)
    {
        $this->subscriptionRepository = $subscriptionRepository;
    }

    /**
     * Get current user subscription status.
     */
    public function getSubscriptionStatus(int $userId)
    {
        $subscription = $this->subscriptionRepository->getActiveForUser($userId);

        if (!$subscription) {
            return [
                'plan' => 'free',
                'status' => 'active',
                'expires_at' => null
            ];
        }

        return $subscription;
    }

    /**
     * Proccess payment verification and activate a subscription.
     */
    public function activateSubscription(int $userId, array $data)
    {
        // Placeholder for real provider verification logic (e.g., Razorpay API)
        // verifyTransaction($data['provider'], $data['transaction_id']);

        $duration = 30; // Default 30 days for Pro
        $startedAt = now();
        $expiresAt = $startedAt->copy()->addDays($duration);

        $subscription = $this->subscriptionRepository->updateOrCreate($userId, [
            'plan' => $data['plan'],
            'status' => 'active',
            'provider' => $data['provider'],
            'provider_transaction_id' => $data['transaction_id'],
            'started_at' => $startedAt,
            'expires_at' => $expiresAt,
        ]);

        // If activating Pro, ensure other plans are handled (optional)
        if ($data['plan'] === 'pro') {
            $this->subscriptionRepository->deactivateOthers($userId, $subscription->id);
        }

        return $subscription;
    }

    /**
     * Global helper logic to check if user has active Pro access.
     */
    public function userHasProAccess(int $userId): bool
    {
        $status = $this->getSubscriptionStatus($userId);
        
        if ($status instanceof \App\Models\Subscription) {
            return $status->plan === 'pro' && $status->status === 'active';
        }

        return ($status['plan'] ?? 'free') === 'pro';
    }
}
