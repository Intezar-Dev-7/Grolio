// features/user_details/data/datasources/user_details_remote_datasource.dart

import 'package:frontend/config/api_endpoints.dart';
import 'package:frontend/features/profile/data/model/user_profile_model.dart';
import '../../../../core/error/exceptions.dart';
import '../../../../core/network/dio_client.dart';
import '../../../profile/domain/entities/user_profile_entity.dart';

abstract class UserDetailsRemoteDataSource {
  Future<UserProfileEntity> getUserProfile(String userId);
  Future<void> followUser(String userId);
  Future<void> unfollowUser(String userId);
  Future<void> blockUser(String userId);
  Future<void> reportUser(String userId);
  Future<List<Map<String, dynamic>>> getCommonGroups(String userId);
  Future<List<Map<String, dynamic>>> getMediaGallery(String userId);
  Future<void> addToFavourites(String userId);
  Future<void> removeFromFavourites(String userId);
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
  Future<UserProfileEntity> getUserProfile(String userId) async {
    try {
      /*final response = await dioClient.get(
        ApiEndpoints.userProfile(userId),
      );*/

      if ( true ) { // response.statusCode == 200
        /*// If your API returns the model directly
        final userProfileModel = UserProfileModel.fromJson(
          response.data['data'] ?? response.data,
        );*/
        final userProfileModel = UserProfileModel(
          id: 'jorden_lee_123',
          name: 'Jorden Lee',
          username: '@jordenlee',
          phone: '+91 9123 46 7890',
          avatar: 'https://i.pravatar.cc/150?u=alexmorgan',
          bio: 'Full-stack developer building modern web apps. Open source enthusiast. Always learning something new.',
          followersCount: 332,
          followingCount: 534,
          postsCount: 23,
          isFollowing: false,
          socialLinks: [
            'https://github.com/alexmorgan',
            'https://twitter.com/alexmorgan',
          ],
          stats: UserStatsModel(
            dayStreak: 47,
            level: 12,
            currentXP: 2450,
            maxXP: 3000,
          ),
          achievements: [
            AchievementModel(
              id: 'ach_1',
              title: 'Early Adopter',
              icon: '🚀',
              isUnlocked: false,
            ),
            AchievementModel(
              id: 'ach_2',
              title: '100 Day Streak',
              icon: '🔥',
              isUnlocked: true,
            ),
            AchievementModel(
              id: 'ach_3',
              title: 'Top Contributor',
              icon: '⭐',
              isUnlocked: false,
            ),
            AchievementModel(
              id: 'ach_4',
              title: 'Open Source',
              icon: '💎',
              isUnlocked: true,
            ),
          ],
          pinnedProjects: [
            ProjectModel(
              id: 'proj_1',
              title: 'MobileFirst UI Kit',
              description: 'Reusable component library for mobile-first applications',
              imageUrl: 'https://picsum.photos/seed/project1/800/400',
              tags: ['#Flutter', '#Dart'],
              stars: 189,
            ),
            ProjectModel(
              id: 'proj_2',
              title: 'API Gateway Service',
              description: 'Scalable microservices architecture with Docker and K8s',
              imageUrl: 'https://picsum.photos/seed/project2/800/400',
              tags: ['#NodeJS', '#Docker'],
              stars: 156,
            ),
            ProjectModel(
              id: 'proj_3',
              title: 'ReactFlow Dashboard',
              description: 'Interactive data visualization dashboard with real-time updates',
              imageUrl: 'https://picsum.photos/seed/project3/800/400',
              tags: ['#React', '#D3.js'],
              stars: 234,
            ),
          ],
          techStack: [
            '#React',
            '#TypeScript',
            '#NodeJS',
            '#Python',
            '#TailwindCSS',
            '#PostgreSQL',
            '#Docker',
            '#AWS',
          ],
        );
        return userProfileModel.toEntity();
      } else {
        throw ServerException(message: 'Failed to load user profile');
      }
    } catch (e) {
      if (e is DioException) {
        throw ServerException(
          message: e.response?.data['message'] ?? 'Network error',
        );
      }
      throw ServerException(message: e.toString());
    }
  }

  @override
  Future<void> followUser(String userId) async {
    try {
      final response = await dioClient.post(ApiEndpoints.followUser(userId));
      final response = await dioClient.post(
        ApiEndpoints.followUser(userId),
      );

      if (response.statusCode != 200 && response.statusCode != 201) {
        throw ServerException(message: 'Failed to follow user');
      }
    } catch (e) {
      if (e is DioException) {
        throw ServerException(
          message: e.response?.data['message'] ?? 'Failed to follow user',
        );
      }
      throw ServerException(message: e.toString());
    }
  }

  @override
  Future<void> unfollowUser(String userId) async {
    try {
      final response = await dioClient.post(ApiEndpoints.unfollowUser(userId));
      final response = await dioClient.delete(
        ApiEndpoints.unfollowUser(userId),
      );

      if (response.statusCode != 200 && response.statusCode != 204) {
        throw ServerException(message: 'Failed to unfollow user');
      }
    } catch (e) {
      if (e is DioException) {
        throw ServerException(
          message: e.response?.data['message'] ?? 'Failed to unfollow user',
        );
      }
      throw ServerException(message: e.toString());
    }
  }

  @override
  Future<void> blockUser(String userId) async {
    try {
      final response = await dioClient.post(ApiEndpoints.blockUser(userId));
      final response = await dioClient.post(
        ApiEndpoints.blockUser(userId),
      );

      if (response.statusCode != 200 && response.statusCode != 201) {
        throw ServerException(message: 'Failed to block user');
      }
    } catch (e) {
      if (e is DioException) {
        throw ServerException(
          message: e.response?.data['message'] ?? 'Failed to block user',
        );
      }
      throw ServerException(message: e.toString());
    }
  }

  @override
  Future<void> reportUser(String userId) async {
    try {
      final response = await dioClient.post(ApiEndpoints.reportUser(userId));
      final response = await dioClient.post(
        ApiEndpoints.reportUser(userId),
        data: {
          'reason': 'Inappropriate content',
          'reported_at': DateTime.now().toIso8601String(),
        },
      );

      if (response.statusCode != 200 && response.statusCode != 201) {
        throw ServerException(message: 'Failed to report user');
      }
    } catch (e) {
      if (e is DioException) {
        throw ServerException(
          message: e.response?.data['message'] ?? 'Failed to report user',
        );
      }
      throw ServerException(message: e.toString());
    }
  }

  @override
  Future<List<Map<String, dynamic>>> getCommonGroups(String userId) async {
    try {
      final response = await dioClient.get(
        ApiEndpoints.commonGroups(userId),
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = response.data['data'] ?? [];
        return data.map((e) => e as Map<String, dynamic>).toList();
      } else {
        throw ServerException(message: 'Failed to load common groups');
      }
    } catch (e) {
      if (e is DioException) {
        throw ServerException(
          message: e.response?.data['message'] ?? 'Failed to load groups',
        );
      }
      // Return empty list as fallback
      return [];
    }
  }

  @override
  Future<List<Map<String, dynamic>>> getMediaGallery(String userId) async {
    try {
      final response = await dioClient.get(
        ApiEndpoints.userMedia(userId),
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = response.data['data'] ?? [];
        return data.map((e) => e as Map<String, dynamic>).toList();
      } else {
        throw ServerException(message: 'Failed to load media gallery');
      }
    } catch (e) {
      if (e is DioException) {
        throw ServerException(
          message: e.response?.data['message'] ?? 'Failed to load media',
        );
      }
      // Return empty list as fallback
      return [];
    }
  }

  @override
  Future<void> addToFavourites(String userId) async {
    try {
      final response = await dioClient.post(
        ApiEndpoints.favourites(userId),
      );

      if (response.statusCode != 200 && response.statusCode != 201) {
        throw ServerException(message: 'Failed to add to favourites');
      }
    } catch (e) {
      if (e is DioException) {
        throw ServerException(
          message: e.response?.data['message'] ?? 'Failed to add to favourites',
        );
      }
      throw ServerException(message: e.toString());
    }
  }

  @override
  Future<void> removeFromFavourites(String userId) async {
    try {
      final response = await dioClient.delete(
        ApiEndpoints.removeFromFavourites(userId),
      );

      if (response.statusCode != 200 && response.statusCode != 204) {
        throw ServerException(message: 'Failed to remove from favourites');
      }
    } catch (e) {
      if (e is DioException) {
        throw ServerException(
          message: e.response?.data['message'] ?? 'Failed to remove',
        );
      }
      throw ServerException(message: e.toString());
    }
  }
}
