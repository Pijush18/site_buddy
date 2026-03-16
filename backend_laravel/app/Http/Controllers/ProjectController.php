<?php

namespace App\Http\Controllers;

use App\Services\ProjectService;
use Illuminate\Http\Request;

class ProjectController extends Controller
{
    protected $projectService;

    public function __construct(ProjectService $projectService)
    {
        $this->projectService = $projectService;
    }

    public function index(Request $request)
    {
        $user = $request->get('user');
        $projects = $this->projectService->listUserProjects($user->id);

        return response()->json([
            'success' => true,
            'data' => $projects
        ]);
    }

    public function show(Request $request, $id)
    {
        $user = $request->get('user');
        $project = $this->projectService->getProject($id, $user->id);

        if (!$project) {
            return response()->json([
                'success' => false,
                'error' => 'Project not found.'
            ], 404);
        }

        return response()->json([
            'success' => true,
            'data' => $project
        ]);
    }

    public function store(Request $request)
    {
        $user = $request->get('user');
        $data = $request->validate([
            'name' => 'required|string',
            'type' => 'required|string',
        ]);
        $data['user_id'] = $user->id;

        $project = $this->projectService->createProject($data);

        return response()->json([
            'success' => true,
            'data' => $project,
            'message' => 'Project created successfully.'
        ], 201);
    }
}
