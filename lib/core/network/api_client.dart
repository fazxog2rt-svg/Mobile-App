import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../constants/app_constants.dart';

final dioProvider = Provider<Dio>((ref) {
  final dio = Dio(BaseOptions(
    baseUrl: AppConstants.botApiBaseUrl,
    connectTimeout: const Duration(milliseconds: AppConstants.connectTimeout),
    receiveTimeout: const Duration(milliseconds: AppConstants.receiveTimeout),
    sendTimeout: const Duration(milliseconds: AppConstants.sendTimeout),
    headers: {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
    },
  ));

  dio.interceptors.addAll([
    _AuthInterceptor(),
    _LoggingInterceptor(),
    _ErrorInterceptor(),
  ]);

  return dio;
});

class _AuthInterceptor extends Interceptor {
  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    // Token will be injected from secure storage in real implementation
    final token = 'Bearer YOUR_TOKEN';
    options.headers['Authorization'] = token;
    handler.next(options);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) async {
    if (err.response?.statusCode == 401) {
      // Handle token refresh
      handler.next(err);
      return;
    }
    handler.next(err);
  }
}

class _LoggingInterceptor extends Interceptor {
  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    // ignore: avoid_print
    print('[API] ${options.method} ${options.uri}');
    handler.next(options);
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    // ignore: avoid_print
    print('[API] ${response.statusCode} ${response.realUri}');
    handler.next(response);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    // ignore: avoid_print
    print('[API ERROR] ${err.message}');
    handler.next(err);
  }
}

class _ErrorInterceptor extends Interceptor {
  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    switch (err.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.receiveTimeout:
      case DioExceptionType.sendTimeout:
        handler.next(DioException(
          requestOptions: err.requestOptions,
          error: 'Connection timed out. Please check your internet connection.',
          type: err.type,
        ));
        break;
      case DioExceptionType.badResponse:
        final statusCode = err.response?.statusCode;
        String message = 'An error occurred';
        if (statusCode == 400) message = 'Bad request';
        if (statusCode == 401) message = 'Unauthorized. Please log in again.';
        if (statusCode == 403) message = 'You don\'t have permission to do that.';
        if (statusCode == 404) message = 'Resource not found.';
        if (statusCode == 429) message = 'Too many requests. Please slow down.';
        if (statusCode != null && statusCode >= 500) message = 'Server error. Please try again later.';
        handler.next(DioException(
          requestOptions: err.requestOptions,
          response: err.response,
          error: message,
          type: err.type,
        ));
        break;
      case DioExceptionType.connectionError:
        handler.next(DioException(
          requestOptions: err.requestOptions,
          error: 'No internet connection. Please check your network.',
          type: err.type,
        ));
        break;
      default:
        handler.next(err);
    }
  }
}

// Discord API client
final discordDioProvider = Provider<Dio>((ref) {
  final dio = Dio(BaseOptions(
    baseUrl: AppConstants.discordApiBaseUrl,
    connectTimeout: const Duration(milliseconds: AppConstants.connectTimeout),
    receiveTimeout: const Duration(milliseconds: AppConstants.receiveTimeout),
    headers: {
      'Content-Type': 'application/json',
    },
  ));
  return dio;
});
