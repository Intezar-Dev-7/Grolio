// features/profile/domain/entities/user_profile_entity.dart

import 'package:equatable/equatable.dart';

class UserProfileEntity extends Equatable {
  final String id;
  final String name;
  final String username;
  final String? avatar;
  final String bio;
  final int followersCount;
  final int followingCount;
  final int postsCount;
  final bool isFollowing;
  final List<String> socialLinks;
  final UserStatsEntity stats;
  final List<AchievementEntity> achievements;
  final List<ProjectEntity> pinnedProjects;
  final List<String> techStack;

  const UserProfileEntity({
    required this.id,
    required this.name,
    required this.username,
    this.avatar,
    required this.bio,
    required this.followersCount,
    required this.followingCount,
    required this.postsCount,
    required this.isFollowing,
    required this.socialLinks,
    required this.stats,
    required this.achievements,
    required this.pinnedProjects,
    required this.techStack,
  });

  @override
  List<Object?> get props => [
    id,
    name,
    username,
    avatar,
    bio,
    followersCount,
    followingCount,
    postsCount,
    isFollowing,
    socialLinks,
    stats,
    achievements,
    pinnedProjects,
    techStack,
  ];
}

class UserStatsEntity extends Equatable {
  final int dayStreak;
  final int level;
  final int currentXP;
  final int maxXP;

  const UserStatsEntity({
    required this.dayStreak,
    required this.level,
    required this.currentXP,
    required this.maxXP,
  });

  double get xpProgress => currentXP / maxXP;

  @override
  List<Object?> get props => [dayStreak, level, currentXP, maxXP];
}

class AchievementEntity extends Equatable {
  final String id;
  final String title;
  final String icon;
  final bool isUnlocked;

  const AchievementEntity({
    required this.id,
    required this.title,
    required this.icon,
    required this.isUnlocked,
  });

  @override
  List<Object?> get props => [id, title, icon, isUnlocked];
}

class ProjectEntity extends Equatable {
  final String id;
  final String title;
  final String description;
  final String? imageUrl;
  final List<String> tags;
  final int stars;

  const ProjectEntity({
    required this.id,
    required this.title,
    required this.description,
    this.imageUrl,
    required this.tags,
    required this.stars,
  });

  @override
  List<Object?> get props => [id, title, description, imageUrl, tags, stars];
}
