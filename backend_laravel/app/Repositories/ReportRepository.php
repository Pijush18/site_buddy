<?php

namespace App\Repositories;

use App\Models\Report;

class ReportRepository
{
    public function getByProjectId(int $projectId)
    {
        return Report::with('project')->where('project_id', $projectId)->get();
    }

    public function create(array $data)
    {
        return Report::create($data);
    }
}
