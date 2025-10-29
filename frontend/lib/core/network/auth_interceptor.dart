// core/network/auth_interceptor.dart (SIMPLIFIED VERSION)

import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class AuthInterceptor extends Interceptor {
  final FlutterSecureStorage secureStorage;

  AuthInterceptor({required this.secureStorage});

  @override
  Future<void> onRequest(
      RequestOptions options,
      RequestInterceptorHandler handler,
      ) async {
    // Get access token from secure storage
    final accessToken = await secureStorage.read(key: 'ACCESS_TOKEN');

    // Add token to headers if available
    if (accessToken != null && accessToken.isNotEmpty) {
      options.headers['Authorization'] = 'Bearer $accessToken';
    }

    handler.next(options);
  }

  @override
  Future<void> onError(
      DioException err,
      ErrorInterceptorHandler handler,
      ) async {
    // If 401 error (unauthorized), could implement token refresh here
    // For now, just pass the error
    handler.next(err);
  }
}
