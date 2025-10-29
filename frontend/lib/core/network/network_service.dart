// core/network/network_service.dart

import 'package:dio/dio.dart';
import 'auth_interceptor.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class NetworkService {
  static void initializeInterceptors(
      Dio dio,
      FlutterSecureStorage secureStorage,
      ) {
    // Clear existing interceptors except logging
    dio.interceptors.clear();

    // Add auth interceptor
    dio.interceptors.add(AuthInterceptor(secureStorage: secureStorage));

    // Add logging interceptor
    dio.interceptors.add(
      LogInterceptor(
        requestBody: true,
        responseBody: true,
        error: true,
        requestHeader: true,
        responseHeader: false,
      ),
    );
  }
}
