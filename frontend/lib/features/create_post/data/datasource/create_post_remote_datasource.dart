// features/create_post/data/datasources/create_post_remote_datasource.dart

import 'package:dio/dio.dart';
import 'package:frontend/config/api_endpoints.dart';
import 'package:image_picker/image_picker.dart';
import '../../../../core/error/exceptions.dart';
import '../../../../core/network/dio_client.dart';

abstract class CreatePostRemoteDataSource {
  Future<String> uploadImage(XFile image);
  Future<Map<String, dynamic>> createPost({
    required String content,
    required List<String> tags,
    String? imageUrl,
    String? githubUrl,
    String? demoUrl,
    required String type,
  });
}

class CreatePostRemoteDataSourceImpl implements CreatePostRemoteDataSource {
  final DioClient dioClient;

  CreatePostRemoteDataSourceImpl({required this.dioClient});

  @override
  Future<String> uploadImage(XFile image) async {
    try {
      FormData formData = FormData.fromMap({
        'image': await MultipartFile.fromFile(
          image.path,
          filename: image.name,
        ),
      });

      final response = await dioClient.post(
        ApiEndpoints.uploadImage,
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
  Future<Map<String, dynamic>> createPost({
    required String content,
    required List<String> tags,
    String? imageUrl,
    String? githubUrl,
    String? demoUrl,
    required String type,
  }) async {
    try {
      const endpoint = ApiEndpoints.posts;

      final response = await dioClient.post(
        endpoint,
        data: {
          'content': content,
          'tags': tags,
          'image_url': imageUrl,
          'github_url': githubUrl,
          'demo_url': demoUrl,
          'type': type,
        },
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        return response.data['data'] as Map<String, dynamic>;
      } else {
        throw ServerException(message: 'Failed to create post');
      }
    } catch (e) {
      throw ServerException(message: e.toString());
    }
  }
}
