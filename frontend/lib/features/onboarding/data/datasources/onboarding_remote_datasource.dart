// features/onboarding/data/datasources/onboarding_remote_datasource.dart
import 'package:dio/dio.dart';
import 'package:frontend/config/api_endpoints.dart';
import 'package:image_picker/image_picker.dart';
import '../../../../core/error/exceptions.dart';
import '../../../../core/network/dio_client.dart';

abstract class OnboardingRemoteDataSource {
  Future<String> uploadProfileImage(XFile image);
  Future<bool> checkUsernameAvailability(String username);
  Future<void> completeProfileSetup({
    required String fullName,
    required String username,
    required String email,
    required String phone,
    required String bio,
    required List<String> techStack,
    required Map<String, String> socialLinks,
    String? profileImageUrl,
  });
}

class OnboardingRemoteDataSourceImpl implements OnboardingRemoteDataSource {
  final DioClient dioClient;

  OnboardingRemoteDataSourceImpl({required this.dioClient});

  @override
  Future<String> uploadProfileImage(XFile image) async {
    try {
      FormData formData = FormData.fromMap({
        'image': await MultipartFile.fromFile(
          image.path,
          filename: image.name,
        ),
      });

      final response = await dioClient.post(
        ApiEndpoints.uploadProfileImage,
        data: formData,
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        return response.data['data']['url'] as String;
      } else {
        throw ServerException(message: 'Failed to upload image');
      }
    } catch (e) {
      throw ServerException(message: e.toString());
    }
  }

  @override
  Future<bool> checkUsernameAvailability(String username) async {
    try {
      final response = await dioClient.get(
        '${ApiEndpoints.checkUsername}?username=$username',
      );

      if (response.statusCode == 200) {
        return response.data['data']['available'] as bool;
      }
      return false;
    } catch (e) {
      throw ServerException(message: e.toString());
    }
  }

  @override
  Future<void> completeProfileSetup({
    required String fullName,
    required String username,
    required String email,
    required String phone,
    required String bio,
    required List<String> techStack,
    required Map<String, String> socialLinks,
    String? profileImageUrl,
  }) async {
    try {
      final response = await dioClient.post(
        ApiEndpoints.completeProfile,
        data: {
          'full_name': fullName,
          'username': username,
          'email': email,
          'phone': phone,
          'bio': bio,
          'tech_stack': techStack,
          'social_links': socialLinks,
          'profile_image_url': profileImageUrl,
        },
      );

      if (response.statusCode != 200 && response.statusCode != 201) {
        throw ServerException(message: 'Failed to complete profile setup');
      }
    } catch (e) {
      throw ServerException(message: e.toString());
    }
  }
}
