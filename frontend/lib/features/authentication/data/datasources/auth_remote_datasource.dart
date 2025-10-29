// features/authentication/data/datasources/auth_remote_datasource.dart

import 'package:dio/dio.dart';
import '../../../../core/error/exceptions.dart';
import '../../../../core/network/dio_client.dart';
import '../models/auth_result_model.dart';
import '../models/login_request_model.dart';
import '../models/signup_request_model.dart';
import '../models/user_model.dart';

abstract class AuthRemoteDataSource {
  /// Sign in with email and password
  Future<AuthResultModel> signInWithEmail({
    required String email,
    required String password,
  });

  /// Sign in with GitHub OAuth
  Future<AuthResultModel> signInWithGitHub({
    required String authCode,
  });

  /// Sign in with Google OAuth
  Future<AuthResultModel> signInWithGoogle({
    required String idToken,
  });

  /// Sign up with email and password
  Future<AuthResultModel> signUpWithEmail({
    required String email,
    required String password,
    required String displayName,
  });

  /// Sign out
  Future<void> signOut();

  /// Get current user
  Future<UserModel> getCurrentUser();

  /// Refresh access token
  Future<String> refreshAccessToken({
    required String refreshToken,
  });

  /// Reset password
  Future<void> resetPassword({
    required String email,
  });

  /// Verify email
  Future<void> verifyEmail({
    required String token,
  });
}

class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  final DioClient dioClient;

  AuthRemoteDataSourceImpl({required this.dioClient});

  @override
  Future<AuthResultModel> signInWithEmail({
    required String email,
    required String password,
  }) async {
    try {
      final requestModel = LoginRequestModel(
        email: email,
        password: password,
      );

      final response = await dioClient.post(
        '/auth/login',
        data: requestModel.toJson(),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        return AuthResultModel.fromJson(response.data['data']);
      } else {
        throw ServerException(
          message: response.data['message'] ?? 'Login failed',
        );
      }
    } on DioException catch (e) {
      throw _handleDioError(e);
    } catch (e) {
      throw ServerException(message: e.toString());
    }
  }

  @override
  Future<AuthResultModel> signInWithGitHub({
    required String authCode,
  }) async {
    try {
      final response = await dioClient.post(
        '/auth/github',
        data: {'code': authCode},
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        return AuthResultModel.fromJson(response.data['data']);
      } else {
        throw ServerException(
          message: response.data['message'] ?? 'GitHub authentication failed',
        );
      }
    } on DioException catch (e) {
      throw _handleDioError(e);
    } catch (e) {
      throw ServerException(message: e.toString());
    }
  }

  @override
  Future<AuthResultModel> signInWithGoogle({
    required String idToken,
  }) async {
    try {
      final response = await dioClient.post(
        '/auth/google',
        data: {'id_token': idToken},
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        return AuthResultModel.fromJson(response.data['data']);
      } else {
        throw ServerException(
          message: response.data['message'] ?? 'Google authentication failed',
        );
      }
    } on DioException catch (e) {
      throw _handleDioError(e);
    } catch (e) {
      throw ServerException(message: e.toString());
    }
  }

  @override
  Future<AuthResultModel> signUpWithEmail({
    required String email,
    required String password,
    required String displayName,
  }) async {
    try {
      final requestModel = SignUpRequestModel(
        email: email,
        password: password,
        displayName: displayName,
      );

      final response = await dioClient.post(
        '/auth/register',
        data: requestModel.toJson(),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        return AuthResultModel.fromJson(response.data['data']);
      } else {
        throw ServerException(
          message: response.data['message'] ?? 'Registration failed',
        );
      }
    } on DioException catch (e) {
      throw _handleDioError(e);
    } catch (e) {
      throw ServerException(message: e.toString());
    }
  }

  @override
  Future<void> signOut() async {
    try {
      final response = await dioClient.post('/auth/logout');

      if (response.statusCode != 200 && response.statusCode != 204) {
        throw ServerException(
          message: response.data['message'] ?? 'Logout failed',
        );
      }
    } on DioException catch (e) {
      throw _handleDioError(e);
    } catch (e) {
      throw ServerException(message: e.toString());
    }
  }

  @override
  Future<UserModel> getCurrentUser() async {
    try {
      final response = await dioClient.get('/auth/me');

      if (response.statusCode == 200) {
        return UserModel.fromJson(response.data['data']);
      } else {
        throw ServerException(
          message: response.data['message'] ?? 'Failed to get user',
        );
      }
    } on DioException catch (e) {
      throw _handleDioError(e);
    } catch (e) {
      throw ServerException(message: e.toString());
    }
  }

  @override
  Future<String> refreshAccessToken({
    required String refreshToken,
  }) async {
    try {
      final response = await dioClient.post(
        '/auth/refresh',
        data: {'refresh_token': refreshToken},
      );

      if (response.statusCode == 200) {
        return response.data['data']['access_token'] as String;
      } else {
        throw ServerException(
          message: response.data['message'] ?? 'Token refresh failed',
        );
      }
    } on DioException catch (e) {
      throw _handleDioError(e);
    } catch (e) {
      throw ServerException(message: e.toString());
    }
  }

  @override
  Future<void> resetPassword({
    required String email,
  }) async {
    try {
      final response = await dioClient.post(
        '/auth/reset-password',
        data: {'email': email},
      );

      if (response.statusCode != 200 && response.statusCode != 204) {
        throw ServerException(
          message: response.data['message'] ?? 'Password reset failed',
        );
      }
    } on DioException catch (e) {
      throw _handleDioError(e);
    } catch (e) {
      throw ServerException(message: e.toString());
    }
  }

  @override
  Future<void> verifyEmail({
    required String token,
  }) async {
    try {
      final response = await dioClient.post(
        '/auth/verify-email',
        data: {'token': token},
      );

      if (response.statusCode != 200 && response.statusCode != 204) {
        throw ServerException(
          message: response.data['message'] ?? 'Email verification failed',
        );
      }
    } on DioException catch (e) {
      throw _handleDioError(e);
    } catch (e) {
      throw ServerException(message: e.toString());
    }
  }

  /// Handle Dio errors and convert to custom exceptions
  Exception _handleDioError(DioException error) {
    switch (error.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
        return NetworkException(
          message: 'Connection timeout. Please check your internet connection.',
        );

      case DioExceptionType.badResponse:
        final statusCode = error.response?.statusCode;
        final message = error.response?.data['message'] as String?;

        if (statusCode == 401) {
          return AuthenticationException(
            message: message ?? 'Invalid credentials',
          );
        } else if (statusCode == 403) {
          return AuthenticationException(
            message: message ?? 'Access denied',
          );
        } else if (statusCode == 404) {
          return ServerException(
            message: message ?? 'Resource not found',
          );
        } else if (statusCode == 422) {
          return ValidationException(
            message: message ?? 'Validation error',
          );
        } else if (statusCode! >= 500) {
          return ServerException(
            message: message ?? 'Server error. Please try again later.',
          );
        }
        return ServerException(
          message: message ?? 'An error occurred',
        );

      case DioExceptionType.cancel:
        return NetworkException(message: 'Request cancelled');

      case DioExceptionType.connectionError:
        return NetworkException(
          message: 'No internet connection. Please check your network.',
        );

      case DioExceptionType.unknown:
        return NetworkException(
          message: 'An unexpected error occurred',
        );

      default:
        return ServerException(message: 'An error occurred');
    }
  }
}
