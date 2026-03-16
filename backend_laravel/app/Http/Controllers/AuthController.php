<?php

namespace App\Http\Controllers;

use App\Services\AuthService;
use Illuminate\Http\Request;

class AuthController extends Controller
{
    protected $authService;

    public function __construct(AuthService $authService)
    {
        $this->authService = $authService;
    }

    public function sync(Request $request)
    {
        // In real scenario, the middleware already verified the token.
        // This endpoint could update profile data or just return user info.
        $userData = $request->all();
        $user = $this->authService->syncUser($userData);

        return response()->json([
            'success' => true,
            'data' => $user,
            'message' => 'User synced successfully.'
        ]);
    }
}
