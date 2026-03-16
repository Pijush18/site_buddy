<?php

namespace App\Services;

use App\Repositories\ProjectRepository;

class ProjectService
{
    protected $projectRepository;

    public function __construct(ProjectRepository $projectRepository)
    {
        $this->projectRepository = $projectRepository;
    }

    public function listUserProjects(int $userId)
    {
        return $this->projectRepository->getAllForUser($userId);
    }

    public function getProject(int $id, int $userId)
    {
        return $this->projectRepository->findByIdForUser($id, $userId);
    }

    public function createProject(array $data)
    {
        return $this->projectRepository->create($data);
    }
}
