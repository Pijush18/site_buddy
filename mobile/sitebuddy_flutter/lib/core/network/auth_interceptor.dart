import 'dart:async';
import 'package:dio/dio.dart';
import 'package:site_buddy/features/auth/domain/auth_repository.dart';

/// INTERCEPTOR: AuthInterceptor
/// PURPOSE: Attaches Bearer tokens and handles synchronized 401 token refreshes.
/// 
/// IMPLEMENTATION:
/// - Uses a static [Completer] to ensure only ONE refresh call is in flight.
/// - Concurrent 401s will wait for the same future and then retry.
class AuthInterceptor extends Interceptor {
  final AuthRepository _authRepository;
  
  // Static completer to synchronize multiple 401 requests
  static Completer<String?>? _refreshCompleter;

  AuthInterceptor(this._authRepository);

  @override
  void onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    // 1. Attach current token
    final token = await _authRepository.getIdToken();
    if (token != null) {
      options.headers['Authorization'] = 'Bearer $token';
    }
    return handler.next(options);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) async {
    // 2. Handle 401 Unauthorized
    if (err.response?.statusCode == 401) {
      
      // Prevent infinite retry loops if the metadata indicates this is already a retry
      if (err.requestOptions.extra['isRetry'] == true) {
         return handler.next(err);
      }

      final String? newToken;
      
      try {
        // 3. Coordinate Refresh
        if (_refreshCompleter != null) {
          // Already refreshing, wait for existing future
          newToken = await _refreshCompleter!.future;
        } else {
          // Initial 401, start refresh flow
          _refreshCompleter = Completer<String?>();
          
          try {
            final refreshedToken = await _authRepository.getIdToken(forceRefresh: true);
            _refreshCompleter?.complete(refreshedToken);
            newToken = refreshedToken;
          } catch (e) {
            _refreshCompleter?.completeError(e);
            _refreshCompleter = null;
            rethrow;
          } finally {
            _refreshCompleter = null;
          }
        }

        // 4. Retry Logic
        if (newToken != null) {
          final options = err.requestOptions;
          options.headers['Authorization'] = 'Bearer $newToken';
          
          // Mark as retry to prevent loops
          options.extra['isRetry'] = true;

          // Use a fresh Dio instance for retry to avoid recursive interceptor logic
          // and ensure the retry doesn't trigger another interceptor cycle if it fails again
          final dio = Dio(); 
          final response = await dio.fetch(options);
          return handler.resolve(response);
        }
      } catch (e) {
        // 5. Fatal Failure: Refresh failed or Token lost
        await _authRepository.logout();
      }
    }
    
    return handler.next(err);
  }
}



