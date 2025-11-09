// features/phone_auth/data/datasources/phone_auth_remote_datasource.dart

import 'package:frontend/config/api_endpoints.dart';
import '../../../../core/error/exceptions.dart';
import '../../../../core/network/dio_client.dart';
import '../models/phone_auth_model.dart';

abstract class PhoneAuthRemoteDataSource {
  Future<PhoneAuthModel> sendOtp({
    required String phoneNumber,
    required String countryCode,
  });
  Future<Map<String, dynamic>> verifyOtp({
    required String verificationId,
    required String otp,
  });
  Future<Map<String, dynamic>> loginWithGoogle();
  Future<Map<String, dynamic>> loginWithApple();
  Future<Map<String, dynamic>> loginWithGithub();
}

class PhoneAuthRemoteDataSourceImpl implements PhoneAuthRemoteDataSource {
  final DioClient dioClient;

  PhoneAuthRemoteDataSourceImpl({required this.dioClient});

  @override
  Future<PhoneAuthModel> sendOtp({
    required String phoneNumber,
    required String countryCode,
  }) async {
    try {
      final response = await dioClient.post(
        ApiEndpoints.sendOtp,
        data: {
          'phone_number': phoneNumber,
          'country_code': countryCode,
        },
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        return PhoneAuthModel.fromJson(response.data['data']);
      } else {
        throw ServerException(message: 'Failed to send OTP');
      }
    } catch (e) {
      throw ServerException(message: e.toString());
    }
  }

  @override
  Future<Map<String, dynamic>> verifyOtp({
    required String verificationId,
    required String otp,
  }) async {
    try {
      final response = await dioClient.post(
        ApiEndpoints.verifyOtp,
        data: {
          'verification_id': verificationId,
          'otp': otp,
        },
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        return response.data['data'] as Map<String, dynamic>;
      } else {
        throw ServerException(message: 'Invalid OTP');
      }
    } catch (e) {
      throw ServerException(message: e.toString());
    }
  }

  @override
  Future<Map<String, dynamic>> loginWithGoogle() async {
    try {
      // TODO: Implement Google Sign In
      await Future.delayed(const Duration(seconds: 2));
      return {
        'token': 'mock_google_token',
        'user': {
          'id': 'google_user_123',
          'name': 'Google User',
          'email': 'user@gmail.com',
        },
      };
    } catch (e) {
      throw ServerException(message: e.toString());
    }
  }

  @override
  Future<Map<String, dynamic>> loginWithApple() async {
    try {
      // TODO: Implement Apple Sign In
      await Future.delayed(const Duration(seconds: 2));
      return {
        'token': 'mock_apple_token',
        'user': {
          'id': 'apple_user_123',
          'name': 'Apple User',
          'email': 'user@icloud.com',
        },
      };
    } catch (e) {
      throw ServerException(message: e.toString());
    }
  }

  @override
  Future<Map<String, dynamic>> loginWithGithub() async {
    try {
      // TODO: Implement GitHub Sign In
      await Future.delayed(const Duration(seconds: 2));
      return {
        'token': 'mock_github_token',
        'user': {
          'id': 'github_user_123',
          'name': 'GitHub User',
          'email': 'user@github.com',
        },
      };
    } catch (e) {
      throw ServerException(message: e.toString());
    }
  }
}
