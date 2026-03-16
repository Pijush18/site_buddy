import 'package:dio/dio.dart';
import 'package:site_buddy/features/auth/domain/auth_repository.dart';

/// Interceptor to attach Firebase Auth Token to every request.
/// Also handles 401 Unauthorized responses for token refresh or logout.
class AuthInterceptor extends Interceptor {
  final AuthRepository _authRepository;

  AuthInterceptor(this._authRepository);

  @override
  void onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    // Attach authentication token from Firebase
    final token = await _authRepository.getIdToken();
    if (token != null) {
      options.headers['Authorization'] = 'Bearer $token';
    }
    return handler.next(options);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) async {
    if (err.response?.statusCode == 401) {
      try {
        // 1. Attempt to refresh the Firebase token
        final newToken = await _authRepository.getIdToken(forceRefresh: true);
        
        if (newToken != null) {
          // 2. Clone the original request with the new token
          final requestOptions = err.requestOptions;
          requestOptions.headers['Authorization'] = 'Bearer $newToken';

          // 3. Retry the request using a fresh Dio instance (to avoid interceptor loops if misconfigured)
          final dio = Dio(); 
          final response = await dio.fetch(requestOptions);
          
          return handler.resolve(response);
        }
      } catch (e) {
        // If refresh fails, let the error propagate or trigger logout
        _authRepository.logout();
      }
    }
    return handler.next(err);
  }
}
