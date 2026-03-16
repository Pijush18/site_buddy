<?php

namespace App\Services;

use App\Repositories\UserRepository;
use App\Models\User;

class AuthService
{
    protected $userRepository;

    public function __construct(UserRepository $userRepository)
    {
        $this->userRepository = $userRepository;
    }

    /**
     * Find an existing user or create a new one based on Firebase data.
     */
    public function findOrCreateUser(array $firebaseData): User
    {
        $user = $this->userRepository->findByFirebaseUid($firebaseData['uid']);

        if (!$user) {
            return $this->userRepository->create([
                'firebase_uid' => $firebaseData['uid'],
                'email' => $firebaseData['email'],
                'name' => $firebaseData['name'] ?? null,
            ]);
        }

        return $user;
    }
}
