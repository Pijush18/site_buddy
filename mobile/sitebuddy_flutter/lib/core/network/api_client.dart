// FILE HEADER
// ----------------------------------------------
// File: api_client.dart
// Feature: core (network)
// Layer: infrastructure/network
//
// PURPOSE:
// Centralized Dio-based HTTP client for all backend communication.
// ----------------------------------------------

import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:site_buddy/core/network/network_exceptions.dart';
import 'package:site_buddy/core/network/connectivity_service.dart';
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
        connectTimeout: const Duration(seconds: 15),
        receiveTimeout: const Duration(seconds: 15),
        sendTimeout: const Duration(seconds: 15),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
      ),
    );

    // 1. Auth Interceptor to attach Firebase ID Token
    _dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) async {
          final token = await _authRepository.getIdToken();
          if (token != null) {
            options.headers['Authorization'] = 'Bearer $token';
          }
          return handler.next(options);
        },
      ),
    );

    // 2. Logging Interceptor
    _dio.interceptors.add(
      LogInterceptor(
        requestBody: true,
        responseBody: true,
      ),
    );
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

  /// Internal request handler with error wrapping.
  Future<ApiResponse<T>> _request<T>(Future<Response> Function() call) async {
    // 1. Check connectivity first
    if (!await _connectivity.isOnline) {
      throw const NetworkUnavailableException();
    }

    try {
      final response = await call();
      return ApiResponse<T>(
        data: response.data as T?,
        statusCode: response.statusCode,
      );
    } on DioException catch (e) {
      throw _handleDioError(e);
    } catch (e) {
      throw InvalidResponseException(e.toString());
    }
  }

  /// Maps Dio errors to custom SiteBuddy NetworkExceptions.
  NetworkException _handleDioError(DioException e) {
    switch (e.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
        return const ApiTimeoutException();
      case DioExceptionType.badResponse:
        final status = e.response?.statusCode;
        if (status != null && status >= 500) {
          return ApiServerException(statusCode: status);
        }
        return ApiClientException(
          message: e.response?.data?['message'] ?? 'Client error occurred.',
          statusCode: status,
        );
      case DioExceptionType.cancel:
        return const ApiClientException(message: 'Request cancelled.');
      case DioExceptionType.connectionError:
        return const NetworkUnavailableException();
      default:
        return InvalidResponseException(e.message ?? 'Unknown network error.');
    }
  }
}
