<?php

namespace App\Services;

use App\Repositories\ReportRepository;

class ReportService
{
    protected $reportRepository;

    public function __construct(ReportRepository $reportRepository)
    {
        $this->reportRepository = $reportRepository;
    }

    public function getProjectReports(int $projectId)
    {
        return $this->reportRepository->getByProjectId($projectId);
    }

    public function uploadReport(array $data)
    {
        // Handle file upload to Google Drive or Local storage in future
        return $this->reportRepository->create($data);
    }
}
