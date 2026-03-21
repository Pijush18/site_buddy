import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:site_buddy/core/network/network_exceptions.dart';
import 'package:site_buddy/core/network/connectivity_service.dart';
import 'package:site_buddy/core/network/auth_interceptor.dart';
import 'package:site_buddy/core/backend/backend_config.dart';
import 'package:site_buddy/features/auth/domain/auth_repository.dart';
import 'package:site_buddy/features/auth/application/auth_providers.dart';

/// Riverpod provider for ApiClient.
final apiClientProvider = Provider<ApiClient>((ref) {
  final connectivity = ref.watch(connectivityServiceProvider);
  final authRepository = ref.watch(authRepositoryProvider);
  return ApiClient(
    connectivity: connectivity,
    authRepository: authRepository,
    baseUrl: BackendConfig.baseUrl,
  );
});

/// Generic response wrapper for API calls.
class ApiResponse<T> {
  final T? data;
  final int? statusCode;
  final String? message;

  ApiResponse({this.data, this.statusCode, this.message});
}

/// CLASS: ApiClient
/// PURPOSE: Standardized Dio HTTP client for SiteBuddy backend communication.
/// 
/// FEATURES:
/// - Automated connectivity checks.
/// - Production-grade Token Management (via AuthInterceptor).
/// - Centralized error mapping to domain exceptions.
class ApiClient {
  final ConnectivityService _connectivity;
  final AuthRepository _authRepository;
  late final Dio _dio;

  ApiClient({
    required ConnectivityService connectivity,
    required AuthRepository authRepository,
    String? baseUrl,
  }) : _connectivity = connectivity,
       _authRepository = authRepository {
    _dio = Dio(
      BaseOptions(
        baseUrl: baseUrl ?? '',
        connectTimeout: BackendConfig.timeout,
        receiveTimeout: BackendConfig.timeout,
        sendTimeout: BackendConfig.timeout,
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
      ),
    );

    // Order matters: Auth (Refresh) should typically be first to catch 401s
    _dio.interceptors.addAll([
      AuthInterceptor(_authRepository),
      LogInterceptor(
        request: true,
        requestHeader: true,
        requestBody: true,
        responseHeader: false,
        responseBody: true,
        error: true,
      ),
    ]);
  }

  /// Perform a GET request.
  Future<ApiResponse<T>> get<T>(
    String path, {
    Map<String, dynamic>? queryParameters,
    Options? options,
  }) async {
    return _request<T>(
      () => _dio.get(path, queryParameters: queryParameters, options: options),
    );
  }

  /// Perform a POST request.
  Future<ApiResponse<T>> post<T>(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
  }) async {
    return _request<T>(
      () => _dio.post(path, data: data, queryParameters: queryParameters, options: options),
    );
  }

  /// Perform a PUT request.
  Future<ApiResponse<T>> put<T>(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
  }) async {
    return _request<T>(
      () => _dio.put(path, data: data, queryParameters: queryParameters, options: options),
    );
  }

  /// Perform a DELETE request.
  Future<ApiResponse<T>> delete<T>(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
  }) async {
    return _request<T>(
      () => _dio.delete(path, data: data, queryParameters: queryParameters, options: options),
    );
  }

  /// Internal request handler with network pre-checks and error mapping.
  Future<ApiResponse<T>> _request<T>(Future<Response> Function() call) async {
    // 1. Pre-flight check: Is the device online?
    if (!await _connectivity.isOnline) {
      throw const ConnectionException();
    }

    try {
      final response = await call();
      return ApiResponse<T>(
        data: response.data as T?,
        statusCode: response.statusCode,
      );
    } on DioException catch (e) {
      // 2. Map Dio errors to structured domain-level NetworkExceptions
      throw _handleDioError(e);
    } catch (e) {
      // 3. Unexpected logic error
      throw ServerException(message: 'Request Error: ${e.toString()}');
    }
  }

  /// Maps Dio exceptions to structured domain-level NetworkExceptions.
  NetworkException _handleDioError(DioException e) {
    if (e.type == DioExceptionType.connectionTimeout ||
        e.type == DioExceptionType.sendTimeout ||
        e.type == DioExceptionType.receiveTimeout) {
      return const TimeoutException();
    }

    if (e.type == DioExceptionType.badResponse) {
      final status = e.response?.statusCode;
      final data = e.response?.data;
      
      // Detailed error message from server if available
      final serverMsg = (data is Map) ? data['message']?.toString() : null;

      if (status == 401) {
        return UnauthorizedException(message: serverMsg ?? 'Unauthorized session.');
      }
      
      if (status != null && status >= 500) {
        return ServerException(
          statusCode: status,
          message: serverMsg ?? 'Backend server error.',
        );
      }
      
      return ClientException(
        message: serverMsg ?? 'API request failed with status $status.',
        statusCode: status,
      );
    }

    if (e.type == DioExceptionType.cancel) {
      return const ClientException(message: 'Request manually cancelled.');
    }

    if (e.type == DioExceptionType.connectionError) {
      return const ConnectionException('Failed to connect to the server.');
    }

    return ServerException(message: e.message ?? 'Unknown networking error.');
  }
}



