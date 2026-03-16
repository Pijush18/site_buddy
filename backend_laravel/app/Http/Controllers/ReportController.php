<?php

namespace App\Http\Controllers;

use App\Services\ReportService;
use Illuminate\Http\Request;

class ReportController extends Controller
{
    protected $reportService;

    public function __construct(ReportService $reportService)
    {
        $this->reportService = $reportService;
    }

    public function projectReports(Request $request, $projectId)
    {
        // Add project ownership check in real scenario
        $reports = $this->reportService->getProjectReports($projectId);

        return response()->json([
            'success' => true,
            'data' => $reports
        ]);
    }

    public function upload(Request $request)
    {
        $data = $request->validate([
            'project_id' => 'required|exists:projects,id',
            'file_url' => 'required|url'
        ]);

        $report = $this->reportService->uploadReport($data);

        return response()->json([
            'success' => true,
            'data' => $report,
            'message' => 'Report uploaded successfully.'
        ]);
    }
}
