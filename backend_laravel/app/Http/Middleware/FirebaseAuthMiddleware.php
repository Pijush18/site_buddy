<?php

namespace App\Http\Middleware;

use Closure;
use Illuminate\Http\Request;
use Symfony\Component\HttpFoundation\Response;
use App\Services\AuthService;
use Kreait\Laravel\Firebase\Facades\Firebase;
use Firebase\Auth\Token\Exception\InvalidToken;

class FirebaseAuthMiddleware
{
    protected $authService;

    public function __construct(AuthService $authService)
    {
        $this->authService = $authService;
    }

    /**
     * Handle an incoming request.
     */
    public function handle(Request $request, Closure $next): Response
    {
        $token = $request->bearerToken();

        if (!$token) {
            return response()->json([
                'success' => false,
                'error' => 'Unauthorized: Token not provided.'
            ], 401);
        }

        try {
            // Verify the Firebase ID Token
            $auth = Firebase::auth();
            $verifiedIdToken = $auth->verifyIdToken($token);

            // Extract claims (UID, Email, Name)
            $uid = $verifiedIdToken->claims()->get('sub');
            $email = $verifiedIdToken->claims()->get('email');
            $name = $verifiedIdToken->claims()->get('name');

            // Find or Register User in Local DB
            $user = $this->authService->findOrCreateUser([
                'uid' => $uid,
                'email' => $email,
                'name' => $name,
            ]);

            // Authenticate user for the current request
            auth()->login($user);

            return $next($request);
        } catch (InvalidToken $e) {
            return response()->json([
                'success' => false,
                'error' => 'Unauthorized: Invalid token.'
            ], 401);
        } catch (\Exception $e) {
            return response()->json([
                'success' => false,
                'error' => 'Unauthorized: ' . $e->getMessage()
            ], 401);
        }
    }
}
