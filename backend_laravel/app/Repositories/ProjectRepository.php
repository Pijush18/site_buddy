<?php

namespace App\Repositories;

use App\Models\Project;

class ProjectRepository
{
    public function getAllForUser(int $userId)
    {
        return Project::with(['reports', 'calculations'])
            ->where('user_id', $userId)
            ->get();
    }

    public function findByIdForUser(int $id, int $userId)
    {
        return Project::with(['reports', 'calculations'])
            ->where('id', $id)
            ->where('user_id', $userId)
            ->first();
    }

    public function create(array $data)
    {
        return Project::create($data);
    }
}
