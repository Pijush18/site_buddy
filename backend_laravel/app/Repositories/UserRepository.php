<?php

namespace App\Repositories;

use App\Models\User;

class UserRepository
{
    /**
     * Find a user by their Firebase Unique identifier.
     */
    public function findByFirebaseUid(string $uid)
    {
        return User::where('firebase_uid', $uid)->first();
    }

    /**
     * Create a new user in the database.
     */
    public function create(array $data)
    {
        return User::create($data);
    }

    /**
     * Update an existing user.
     */
    public function update(User $user, array $data)
    {
        $user->update($data);
        return $user;
    }
}
