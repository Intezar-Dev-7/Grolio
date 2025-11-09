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
  Future<UserProfileEntity> getUserProfile(String userId) async {
    try {
      // TODO: Replace mock data with API call when backend is ready
      await Future.delayed(const Duration(seconds: 1));

      final userProfileModel = UserProfileModel(
        id: 'jorden_lee_123',
        name: 'Jorden Lee',
        username: '@jordenlee',
        phone: '+91 9123 46 7890',
        avatar: 'https://i.pravatar.cc/150?u=alexmorgan',
        bio:
            'Full-stack developer building modern web apps. Open source enthusiast.',
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
        achievements: [],
        pinnedProjects: [],
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
    } catch (e) {
      throw ServerException(message: e.toString());
    }
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
      final response = await dioClient.delete(
        ApiEndpoints.unfollowUser(userId),
      );
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
      throw ServerException(message: e.toString());
    }
  }

  @override
  Future<List<Map<String, dynamic>>> getCommonGroups(String userId) async {
    try {
      final response = await dioClient.get(ApiEndpoints.commonGroups(userId));
      if (response.statusCode == 200) {
        final List<dynamic> data = response.data['data'] ?? [];
        return data.map((e) => e as Map<String, dynamic>).toList();
      }
      throw ServerException(message: 'Failed to load common groups');
    } catch (e) {
      return [];
    }
  }

  @override
  Future<List<Map<String, dynamic>>> getMediaGallery(String userId) async {
    try {
      final response = await dioClient.get(ApiEndpoints.userMedia(userId));
      if (response.statusCode == 200) {
        final List<dynamic> data = response.data['data'] ?? [];
        return data.map((e) => e as Map<String, dynamic>).toList();
      }
      throw ServerException(message: 'Failed to load media gallery');
    } catch (e) {
      return [];
    }
  }

  @override
  Future<void> addToFavourites(String userId) async {
    try {
      final response = await dioClient.post(ApiEndpoints.favourites(userId));
      if (response.statusCode != 200 && response.statusCode != 201) {
        throw ServerException(message: 'Failed to add to favourites');
      }
    } catch (e) {
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
      throw ServerException(message: e.toString());
    }
  }
}
