<?php

namespace App\Repositories;

use App\Models\Subscription;

class SubscriptionRepository
{
    /**
     * Get the current active subscription for a user.
     */
    public function getActiveForUser(int $userId)
    {
        return Subscription::where('user_id', $userId)
            ->where('status', 'active')
            ->where(function ($query) {
                $query->whereNull('expires_at')
                      ->orWhere('expires_at', '>', now());
            })
            ->latest()
            ->first();
    }

    /**
     * Create or update a subscription record.
     */
    public function updateOrCreate(int $userId, array $data)
    {
        return Subscription::updateOrCreate(
            ['user_id' => $userId, 'plan' => $data['plan']],
            $data
        );
    }

    /**
     * Deactivate previous active plans for a user.
     */
    public function deactivateOthers(int $userId, int $currentSubscriptionId)
    {
        Subscription::where('user_id', $userId)
            ->where('id', '!=', $currentSubscriptionId)
            ->update(['status' => 'cancelled']);
    }
}
