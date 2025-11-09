// features/user_details/data/datasources/user_details_remote_datasource.dart

import 'package:frontend/config/api_endpoints.dart';
import '../../../../core/error/exceptions.dart';
import '../../../../core/network/dio_client.dart';
import '../models/user_details_model.dart';

abstract class UserDetailsRemoteDataSource {
  Future<UserDetailsModel> getUserDetails(String userId);
  Future<void> followUser(String userId);
  Future<void> unfollowUser(String userId);
  Future<void> blockUser(String userId);
  Future<void> reportUser(String userId);
}

class UserDetailsRemoteDataSourceImpl implements UserDetailsRemoteDataSource {
  final DioClient dioClient;

  UserDetailsRemoteDataSourceImpl({required this.dioClient});

  @override
  Future<UserDetailsModel> getUserDetails(String userId) async {
    // TODO: Remove mock data when backend is ready
    await Future.delayed(const Duration(seconds: 1));

    return UserDetailsModel(
      id: userId,
      name: 'Jordan Lee',
      username: '@jordanlee',
      avatar: 'https://i.pravatar.cc/150?u=jordan',
      coverImage: 'https://picsum.photos/seed/cover$userId/1200/400',
      bio:
          'Full-stack developer passionate about building scalable web applications. Open source contributor. Always learning new technologies.',
      location: 'San Francisco, CA',
      website: 'https://jordanlee.dev',
      joinedDate: DateTime.now().subtract(const Duration(days: 547)),
      followersCount: 2453,
      followingCount: 589,
      postsCount: 142,
      isFollowing: false,
      isOnline: true,
      lastSeen: null,
      socialLinks: [
        'https://github.com/jordanlee',
        'https://twitter.com/jordanlee',
        'https://linkedin.com/in/jordanlee',
      ],
      techStack: [
        '#React',
        '#TypeScript',
        '#NodeJS',
        '#Python',
        '#Docker',
        '#AWS',
        '#PostgreSQL',
        '#GraphQL',
      ],
      recentPosts: [
        UserPostModel(
          id: 'post_1',
          content:
              'Just deployed a new microservices architecture using Docker and Kubernetes. The scalability improvements are impressive! 🚀',
          imageUrl: 'https://picsum.photos/seed/post1/800/400',
          likes: 234,
          comments: 45,
          createdAt: DateTime.now().subtract(const Duration(hours: 5)),
        ),
        UserPostModel(
          id: 'post_2',
          content:
              'Working on a new open source project for developer productivity tools. Check it out on GitHub!',
          imageUrl: null,
          likes: 189,
          comments: 32,
          createdAt: DateTime.now().subtract(const Duration(days: 2)),
        ),
        UserPostModel(
          id: 'post_3',
          content:
              'Built a real-time chat application with WebSockets. The performance is amazing! Here\'s what I learned...',
          imageUrl: 'https://picsum.photos/seed/post3/800/400',
          likes: 312,
          comments: 67,
          createdAt: DateTime.now().subtract(const Duration(days: 5)),
        ),
      ],
      stats: UserStatsModel(
        contributionStreak: 87,
        totalContributions: 1456,
        rank: 'Expert',
      ),
    );
  }

  @override
  Future<void> followUser(String userId) async {
    try {
      final response = await dioClient.post(ApiEndpoints.followUser(userId));
      if (response.statusCode != 200 && response.statusCode != 201) {
        throw ServerException(message: 'Failed to follow user');
      }
    } catch (e) {
      throw ServerException(message: e.toString());
    }
  }

  @override
  Future<void> unfollowUser(String userId) async {
    try {
      final response = await dioClient.post(ApiEndpoints.unfollowUser(userId));
      if (response.statusCode != 200 && response.statusCode != 204) {
        throw ServerException(message: 'Failed to unfollow user');
      }
    } catch (e) {
      throw ServerException(message: e.toString());
    }
  }

  @override
  Future<void> blockUser(String userId) async {
    try {
      final response = await dioClient.post(ApiEndpoints.blockUser(userId));
      if (response.statusCode != 200 && response.statusCode != 201) {
        throw ServerException(message: 'Failed to block user');
      }
    } catch (e) {
      throw ServerException(message: e.toString());
    }
  }

  @override
  Future<void> reportUser(String userId) async {
    try {
      final response = await dioClient.post(ApiEndpoints.reportUser(userId));
      if (response.statusCode != 200 && response.statusCode != 201) {
        throw ServerException(message: 'Failed to report user');
      }
    } catch (e) {
      throw ServerException(message: e.toString());
    }
  }
}
