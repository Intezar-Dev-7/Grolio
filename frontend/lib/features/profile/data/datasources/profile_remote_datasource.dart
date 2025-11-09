// features/profile/data/datasources/profile_remote_datasource.dart

import 'package:frontend/config/api_endpoints.dart';
import 'package:frontend/features/profile/data/model/user_profile_model.dart';
import '../../../../core/error/exceptions.dart';
import '../../../../core/network/dio_client.dart';

abstract class ProfileRemoteDataSource {
  Future<UserProfileModel> getUserProfile(String userId);
  Future<UserProfileModel> getMyProfile();
  Future<void> followUser(String userId);
  Future<void> unfollowUser(String userId);
}

class ProfileRemoteDataSourceImpl implements ProfileRemoteDataSource {
  final DioClient dioClient;

  ProfileRemoteDataSourceImpl({required this.dioClient});

  @override
  Future<UserProfileModel> getUserProfile(String userId) async {
    try {
      // final response = await dioClient.get(ApiEndpoints.userProfile(userId));

      if (true) { // response.statusCode == 200
        // return UserProfileModel.fromJson(response.data['data']);
        return UserProfileModel(
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
      } else {
        throw ServerException(message: 'Failed to load profile');
      }
    } catch (e) {
      throw ServerException(message: e.toString());
    }
  }

  @override
  Future<UserProfileModel> getMyProfile() async {
    // TODO: Remove mock data when backend is ready
    await Future.delayed(const Duration(seconds: 1));

    return UserProfileModel(
      id: 'user_me',
      name: 'Alex Morgan',
      username: '@alexmorgan',
      phone: '+91 9123 46 7890',
      avatar: 'https://i.pravatar.cc/150?u=alexmorgan',
      bio: 'Full-stack developer building modern web apps. Open source enthusiast. Always learning something new.',
      followersCount: 1247,
      followingCount: 342,
      postsCount: 89,
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
          isUnlocked: true,
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
          isUnlocked: true,
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
}
