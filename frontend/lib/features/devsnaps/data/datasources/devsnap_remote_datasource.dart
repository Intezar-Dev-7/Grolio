// features/devsnaps/data/datasources/devsnap_remote_datasource.dart

import 'package:dio/dio.dart';
import 'package:frontend/config/api_endpoints.dart';
import '../../../../core/error/exceptions.dart';
import '../../../../core/network/dio_client.dart';
import '../models/devsnap_model.dart';
import '../models/story_model.dart';

abstract class DevSnapRemoteDataSource {
  Future<List<StoryModel>> getStories();
  Future<List<DevSnapModel>> getUserDevSnaps(String userId);
  Future<List<DevSnapModel>> getRecentDevSnaps({int page = 1, int limit = 20});
  Future<DevSnapModel> createDevSnap({
    required String imageUrl,
    String? caption,
    List<String>? tags,
    String? codeSnippet,
    String? language,
  });
  Future<void> markAsViewed(String devSnapId);
  Future<void> likeDevSnap(String devSnapId);
  Future<void> deleteDevSnap(String devSnapId);
}

class DevSnapRemoteDataSourceImpl implements DevSnapRemoteDataSource {
  final DioClient dioClient;

  DevSnapRemoteDataSourceImpl({required this.dioClient});

/*  @override
  Future<List<StoryModel>> getStories() async {
    try {
      final response = await dioClient.get(ApiEndpoints.devSnapStories);

      if (response.statusCode == 200) {
        final List<dynamic> storiesJson = response.data['data'] as List;
        return storiesJson.map((json) => StoryModel.fromJson(json)).toList();
      } else {
        throw ServerException(
          message: response.data['message'] ?? 'Failed to load stories',
        );
      }
    } on DioException catch (e) {
      throw _handleDioError(e);
    } catch (e) {
      throw ServerException(message: e.toString());
    }
  }*/

  @override
  Future<List<StoryModel>> getStories() async {
    // TODO: Remove this mock data when backend is ready
    await Future.delayed(const Duration(seconds: 1));

    return [
      StoryModel(
        userId: 'user_1',
        username: 'sarahdev',
        userAvatar: 'https://i.pravatar.cc/150?u=sarah',
        hasNewContent: true,
        snaps: [
          DevSnapModel(
            id: 'snap_s1',
            userId: 'user_1',
            username: 'sarahdev',
            userAvatar: 'https://i.pravatar.cc/150?u=sarah',
            imageUrl: 'https://picsum.photos/seed/sarah1/400/600',
            caption: 'Working on a new React component 🚀',
            tags: ['#react', '#typescript', '#frontend'],
            codeSnippet: null,
            language: null,
            views: 234,
            likes: 45,
            isViewed: false,
            createdAt: DateTime.now().subtract(const Duration(hours: 2)),
            expiresAt: DateTime.now().add(const Duration(hours: 22)),
          ),
          DevSnapModel(
            id: 'snap_s2',
            userId: 'user_1',
            username: 'sarahdev',
            userAvatar: 'https://i.pravatar.cc/150?u=sarah',
            imageUrl: 'https://picsum.photos/seed/sarah2/400/600',
            caption: 'My cozy coding setup 💻',
            tags: ['#workspace', '#coding'],
            codeSnippet: null,
            language: null,
            views: 189,
            likes: 32,
            isViewed: false,
            createdAt: DateTime.now().subtract(const Duration(hours: 5)),
            expiresAt: DateTime.now().add(const Duration(hours: 19)),
          ),
        ],
      ),
      StoryModel(
        userId: 'user_2',
        username: 'marcusj',
        userAvatar: 'https://i.pravatar.cc/150?u=marcus',
        hasNewContent: true,
        snaps: [
          DevSnapModel(
            id: 'snap_m1',
            userId: 'user_2',
            username: 'marcusj',
            userAvatar: 'https://i.pravatar.cc/150?u=marcus',
            imageUrl: 'https://picsum.photos/seed/marcus1/400/600',
            caption: 'Finally fixed that bug! 🎉',
            tags: ['#debugging', '#python', '#victory'],
            codeSnippet: null,
            language: null,
            views: 312,
            likes: 67,
            isViewed: false,
            createdAt: DateTime.now().subtract(const Duration(hours: 3)),
            expiresAt: DateTime.now().add(const Duration(hours: 21)),
          ),
        ],
      ),
      StoryModel(
        userId: 'user_3',
        username: 'elenacodes',
        userAvatar: 'https://i.pravatar.cc/150?u=elena',
        hasNewContent: false,
        snaps: [
          DevSnapModel(
            id: 'snap_e1',
            userId: 'user_3',
            username: 'elenacodes',
            userAvatar: 'https://i.pravatar.cc/150?u=elena',
            imageUrl: 'https://picsum.photos/seed/elena1/400/600',
            caption: 'Learning Flutter today 📱',
            tags: ['#flutter', '#dart', '#learning'],
            codeSnippet: null,
            language: null,
            views: 156,
            likes: 28,
            isViewed: true,
            createdAt: DateTime.now().subtract(const Duration(hours: 8)),
            expiresAt: DateTime.now().add(const Duration(hours: 16)),
          ),
        ],
      ),
      StoryModel(
        userId: 'user_4',
        username: 'alexkumar',
        userAvatar: 'https://i.pravatar.cc/150?u=alex',
        hasNewContent: true,
        snaps: [
          DevSnapModel(
            id: 'snap_a1',
            userId: 'user_4',
            username: 'alexkumar',
            userAvatar: 'https://i.pravatar.cc/150?u=alex',
            imageUrl: 'https://picsum.photos/seed/alex1/400/600',
            caption: 'Deployed to production! 🎯',
            tags: ['#deployment', '#devops', '#success'],
            codeSnippet: null,
            language: null,
            views: 445,
            likes: 89,
            isViewed: false,
            createdAt: DateTime.now().subtract(const Duration(hours: 1)),
            expiresAt: DateTime.now().add(const Duration(hours: 23)),
          ),
        ],
      ),
    ];
  }

  @override
  Future<List<DevSnapModel>> getUserDevSnaps(String userId) async {
    try {
      final response = await dioClient.get(ApiEndpoints.userDevSnaps(userId));

      if (response.statusCode == 200) {
        final List<dynamic> snapsJson = response.data['data'] as List;
        return snapsJson.map((json) => DevSnapModel.fromJson(json)).toList();
      } else {
        throw ServerException(
          message: response.data['message'] ?? 'Failed to load DevSnaps',
        );
      }
    } on DioException catch (e) {
      throw _handleDioError(e);
    } catch (e) {
      throw ServerException(message: e.toString());
    }
  }

  @override
  Future<List<DevSnapModel>> getRecentDevSnaps({
    int page = 1,
    int limit = 20,
  }) async {
    // TODO: Remove this mock data when backend is ready
    await Future.delayed(const Duration(seconds: 1));

    return List.generate(8, (index) {
      return DevSnapModel(
        id: 'snap_$index',
        userId: 'user_$index',
        username: 'developer${index + 1}',
        userAvatar: null,
        imageUrl: 'https://picsum.photos/seed/$index/400/500',
        caption: 'Check out my latest project! #coding',
        tags: ['#flutter', '#dart', '#mobile'],
        codeSnippet: null,
        language: null,
        views: (index + 1) * 100,
        likes: (index + 1) * 25,
        isViewed: index % 2 == 0,
        createdAt: DateTime.now().subtract(Duration(hours: index + 1)),
        expiresAt: DateTime.now().add(Duration(hours: 24 - index)),
      );
    });
  }

/*  @override
  Future<List<DevSnapModel>> getRecentDevSnaps({
    int page = 1,
    int limit = 20,
  }) async {
    try {
      final response = await dioClient.get(
        ApiEndpoints.recentDevSnaps,
        queryParameters: {
          'page': page,
          'limit': limit,
        },
      );

      if (response.statusCode == 200) {
        final List<dynamic> snapsJson = response.data['data'] as List;
        return snapsJson.map((json) => DevSnapModel.fromJson(json)).toList();
      } else {
        throw ServerException(
          message: response.data['message'] ?? 'Failed to load DevSnaps',
        );
      }
    } on DioException catch (e) {
      throw _handleDioError(e);
    } catch (e) {
      throw ServerException(message: e.toString());
    }
  }*/

  @override
  Future<DevSnapModel> createDevSnap({
    required String imageUrl,
    String? caption,
    List<String>? tags,
    String? codeSnippet,
    String? language,
  }) async {
    try {
      final response = await dioClient.post(
        ApiEndpoints.devSnaps,
        data: {
          'image_url': imageUrl,
          'caption': caption,
          'tags': tags,
          'code_snippet': codeSnippet,
          'language': language,
        },
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        return DevSnapModel.fromJson(response.data['data']);
      } else {
        throw ServerException(
          message: response.data['message'] ?? 'Failed to create DevSnap',
        );
      }
    } on DioException catch (e) {
      throw _handleDioError(e);
    } catch (e) {
      throw ServerException(message: e.toString());
    }
  }

  @override
  Future<void> markAsViewed(String devSnapId) async {
    try {
      final response = await dioClient.post(
        ApiEndpoints.viewDevSnap(devSnapId),
      );

      if (response.statusCode != 200 && response.statusCode != 204) {
        throw ServerException(
          message: response.data['message'] ?? 'Failed to mark as viewed',
        );
      }
    } on DioException catch (e) {
      throw _handleDioError(e);
    } catch (e) {
      throw ServerException(message: e.toString());
    }
  }

  @override
  Future<void> likeDevSnap(String devSnapId) async {
    try {
      final response = await dioClient.post(
        ApiEndpoints.likeDevSnap(devSnapId),
      );

      if (response.statusCode != 200 && response.statusCode != 201) {
        throw ServerException(
          message: response.data['message'] ?? 'Failed to like DevSnap',
        );
      }
    } on DioException catch (e) {
      throw _handleDioError(e);
    } catch (e) {
      throw ServerException(message: e.toString());
    }
  }

  @override
  Future<void> deleteDevSnap(String devSnapId) async {
    try {
      final response = await dioClient.delete(
        ApiEndpoints.devSnapById(devSnapId),
      );

      if (response.statusCode != 200 && response.statusCode != 204) {
        throw ServerException(
          message: response.data['message'] ?? 'Failed to delete DevSnap',
        );
      }
    } on DioException catch (e) {
      throw _handleDioError(e);
    } catch (e) {
      throw ServerException(message: e.toString());
    }
  }

  Exception _handleDioError(DioException error) {
    switch (error.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
        return NetworkException(message: 'Connection timeout');

      case DioExceptionType.badResponse:
        final statusCode = error.response?.statusCode;
        final message = error.response?.data['message'] as String?;

        if (statusCode == 401) {
          return AuthenticationException(message: message ?? 'Unauthorized');
        } else if (statusCode == 404) {
          return ServerException(message: message ?? 'Resource not found');
        } else if (statusCode! >= 500) {
          return ServerException(message: message ?? 'Server error');
        }
        return ServerException(message: message ?? 'An error occurred');

      case DioExceptionType.connectionError:
        return NetworkException(message: 'No internet connection');

      default:
        return ServerException(message: 'An unexpected error occurred');
    }
  }
}
