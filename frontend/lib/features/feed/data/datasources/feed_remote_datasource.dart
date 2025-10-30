// features/feed/data/datasources/feed_remote_datasource.dart

import 'package:dio/dio.dart';
import 'package:frontend/config/api_endpoints.dart';
import '../../../../core/error/exceptions.dart';
import '../../../../core/network/dio_client.dart';
import '../models/post_model.dart';

abstract class FeedRemoteDataSource {
  Future<List<PostModel>> getFeedPosts({int page = 1, int limit = 20});
  Future<PostModel> getPostById(String postId);
  Future<void> likePost(String postId);
  Future<void> unlikePost(String postId);
  Future<void> bookmarkPost(String postId);
  Future<void> unbookmarkPost(String postId);
  Future<void> sharePost(String postId);
  Future<PostModel> createPost({
    required String content,
    List<String>? tags,
    String? imageUrl,
    String? githubUrl,
    String? demoUrl,
  });
  Future<void> deletePost(String postId);
}

class FeedRemoteDataSourceImpl implements FeedRemoteDataSource {
  final DioClient dioClient;

  FeedRemoteDataSourceImpl({required this.dioClient});

/*  @override
  Future<List<PostModel>> getFeedPosts({int page = 1, int limit = 20}) async {
    try {
      final response = await dioClient.get(
        ApiEndpoints.posts,
        queryParameters: {
          'page': page,
          'limit': limit,
        },
      );

      if (response.statusCode == 200) {
        final List<dynamic> postsJson = response.data['data'] as List;
        return postsJson.map((json) => PostModel.fromJson(json)).toList();
      } else {
        throw ServerException(
          message: response.data['message'] ?? 'Failed to load posts',
        );
      }
    } on DioException catch (e) {
      throw _handleDioError(e);
    } catch (e) {
      throw ServerException(message: e.toString());
    }
  }*/
  @override
  Future<List<PostModel>> getFeedPosts({int page = 1, int limit = 20}) async {
    // TODO: Remove this mock data when backend is ready
    await Future.delayed(const Duration(seconds: 1));

    return List.generate(limit, (index) {
      final postIndex = (page - 1) * limit + index;

      return PostModel(
        id: 'post_$postIndex',
        author: UserInfoModel(
          id: 'user_${postIndex % 5}',
          name: _getRandomName(postIndex),
          username: '@${_getRandomUsername(postIndex)}',
          avatar: 'https://i.pravatar.cc/150?u=user$postIndex',
        ),
        content: _getRandomContent(postIndex),
        imageUrl: postIndex % 3 == 0
            ? 'https://picsum.photos/seed/post$postIndex/800/600'
            : null,
        tags: _getRandomTags(postIndex),
        githubUrl: postIndex % 2 == 0
            ? 'https://github.com/example/project$postIndex'
            : null,
        demoUrl: postIndex % 4 == 0
            ? 'https://demo.example.com/project$postIndex'
            : null,
        stats: PostStatsModel(
          likes: (postIndex + 1) * 15 + (postIndex % 10) * 8,
          comments: (postIndex + 1) * 3 + (postIndex % 7),
          shares: (postIndex + 1) * 2 + (postIndex % 5),
          isLiked: postIndex % 5 == 0,
          isBookmarked: postIndex % 7 == 0,
        ),
        createdAt: DateTime.now().subtract(Duration(hours: postIndex + 1)),
      );
    });
  }

// Helper methods for generating diverse mock data
  String _getRandomName(int index) {
    final names = [
      'Alex Kumar',
      'Sarah Chen',
      'Marcus Johnson',
      'Elena Rodriguez',
      'David Kim',
      'Maya Patel',
      'Jordan Lee',
      'Emma Williams',
      'Ryan Taylor',
      'Sophie Anderson',
    ];
    return names[index % names.length];
  }

  String _getRandomUsername(int index) {
    final usernames = [
      'alexkodes',
      'sarahdev',
      'marcusj',
      'elenacodes',
      'davidkim',
      'mayapatel',
      'jordanlee',
      'emmawilliams',
      'ryantaylor',
      'sophieanderson',
    ];
    return usernames[index % usernames.length];
  }

  String _getRandomContent(int index) {
    final contents = [
      'Built a Flutter app for habit tracking with local notifications. Super smooth animations and offline-first approach. Check it out!',
      'Just shipped a new React component library with dark mode support! 🚀 The API is clean and the bundle size is tiny.',
      'Finally solved that performance issue in my Node.js backend. Reduced API response time by 70%! Here\'s what I learned...',
      'Created a Python script to automate my daily dev workflow. Saves me 2 hours every day. Automation is the best! 🤖',
      'My weekend project: A real-time chat app using WebSockets and Redis. The tech stack is amazing and it scales beautifully.',
      'Deployed my first Kubernetes cluster today! The learning curve was steep but totally worth it. DevOps journey continues! 🎯',
      'Built a Chrome extension that helps developers track their productivity. Over 1000 downloads in the first week! 📈',
      'Just finished a complete redesign of my portfolio website. New animations, better performance, and fully accessible.',
      'Experimenting with Rust for the first time. The compiler is strict but the performance gains are incredible! ⚡',
      'Created a CLI tool to generate boilerplate code for new projects. Open source and already has 500+ stars on GitHub! ⭐',
    ];
    return contents[index % contents.length];
  }

  List<String> _getRandomTags(int index) {
    final tagSets = [
      ['#Flutter', '#Dart', '#MobileApp'],
      ['#React', '#TypeScript', '#TailwindCSS'],
      ['#NodeJS', '#Performance', '#Backend'],
      ['#Python', '#Automation', '#Productivity'],
      ['#WebSockets', '#Redis', '#RealTime'],
      ['#Kubernetes', '#Docker', '#DevOps'],
      ['#ChromeExtension', '#JavaScript', '#Tools'],
      ['#WebDesign', '#Animation', '#UX'],
      ['#Rust', '#Performance', '#SystemProgramming'],
      ['#CLI', '#OpenSource', '#Tools'],
    ];
    return tagSets[index % tagSets.length];
  }

  @override
  Future<PostModel> getPostById(String postId) async {
    try {
      final response = await dioClient.get(
        ApiEndpoints.postById(postId),
      );

      if (response.statusCode == 200) {
        return PostModel.fromJson(response.data['data']);
      } else {
        throw ServerException(
          message: response.data['message'] ?? 'Failed to load post',
        );
      }
    } on DioException catch (e) {
      throw _handleDioError(e);
    } catch (e) {
      throw ServerException(message: e.toString());
    }
  }

  @override
  Future<void> likePost(String postId) async {
    try {
      final response = await dioClient.post(
        ApiEndpoints.likePost(postId),
      );

      if (response.statusCode != 200 && response.statusCode != 201) {
        throw ServerException(
          message: response.data['message'] ?? 'Failed to like post',
        );
      }
    } on DioException catch (e) {
      throw _handleDioError(e);
    } catch (e) {
      throw ServerException(message: e.toString());
    }
  }

  @override
  Future<void> unlikePost(String postId) async {
    try {
      final response = await dioClient.post(
        ApiEndpoints.unlikePost(postId),
      );

      if (response.statusCode != 200 && response.statusCode != 204) {
        throw ServerException(
          message: response.data['message'] ?? 'Failed to unlike post',
        );
      }
    } on DioException catch (e) {
      throw _handleDioError(e);
    } catch (e) {
      throw ServerException(message: e.toString());
    }
  }

  @override
  Future<void> bookmarkPost(String postId) async {
    try {
      final response = await dioClient.post(
        ApiEndpoints.bookmarkPost(postId),
      );

      if (response.statusCode != 200 && response.statusCode != 201) {
        throw ServerException(
          message: response.data['message'] ?? 'Failed to bookmark post',
        );
      }
    } on DioException catch (e) {
      throw _handleDioError(e);
    } catch (e) {
      throw ServerException(message: e.toString());
    }
  }

  @override
  Future<void> unbookmarkPost(String postId) async {
    try {
      final response = await dioClient.delete(
        ApiEndpoints.bookmarkPost(postId),
      );

      if (response.statusCode != 200 && response.statusCode != 204) {
        throw ServerException(
          message: response.data['message'] ?? 'Failed to unbookmark post',
        );
      }
    } on DioException catch (e) {
      throw _handleDioError(e);
    } catch (e) {
      throw ServerException(message: e.toString());
    }
  }

  @override
  Future<void> sharePost(String postId) async {
    try {
      final response = await dioClient.post(
        ApiEndpoints.sharePost(postId),
      );

      if (response.statusCode != 200 && response.statusCode != 201) {
        throw ServerException(
          message: response.data['message'] ?? 'Failed to share post',
        );
      }
    } on DioException catch (e) {
      throw _handleDioError(e);
    } catch (e) {
      throw ServerException(message: e.toString());
    }
  }

  @override
  Future<PostModel> createPost({
    required String content,
    List<String>? tags,
    String? imageUrl,
    String? githubUrl,
    String? demoUrl,
  }) async {
    try {
      final response = await dioClient.post(
        ApiEndpoints.posts,
        data: {
          'content': content,
          'tags': tags,
          'image_url': imageUrl,
          'github_url': githubUrl,
          'demo_url': demoUrl,
        },
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        return PostModel.fromJson(response.data['data']);
      } else {
        throw ServerException(
          message: response.data['message'] ?? 'Failed to create post',
        );
      }
    } on DioException catch (e) {
      throw _handleDioError(e);
    } catch (e) {
      throw ServerException(message: e.toString());
    }
  }

  @override
  Future<void> deletePost(String postId) async {
    try {
      final response = await dioClient.delete(
        ApiEndpoints.postById(postId),
      );

      if (response.statusCode != 200 && response.statusCode != 204) {
        throw ServerException(
          message: response.data['message'] ?? 'Failed to delete post',
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
          return AuthenticationException(
            message: message ?? 'Unauthorized',
          );
        } else if (statusCode == 404) {
          return ServerException(
            message: message ?? 'Resource not found',
          );
        } else if (statusCode! >= 500) {
          return ServerException(
            message: message ?? 'Server error',
          );
        }
        return ServerException(message: message ?? 'An error occurred');

      case DioExceptionType.connectionError:
        return NetworkException(message: 'No internet connection');

      default:
        return ServerException(message: 'An unexpected error occurred');
    }
  }
}
