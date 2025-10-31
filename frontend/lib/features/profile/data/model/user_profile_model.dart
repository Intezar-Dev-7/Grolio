// features/profile/data/models/user_profile_model.dart

import '../../domain/entities/user_profile_entity.dart';

class UserProfileModel {
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
  final UserStatsModel stats;
  final List<AchievementModel> achievements;
  final List<ProjectModel> pinnedProjects;
  final List<String> techStack;

  UserProfileModel({
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

  factory UserProfileModel.fromJson(Map<String, dynamic> json) {
    return UserProfileModel(
      id: json['id'] as String,
      name: json['name'] as String,
      username: json['username'] as String,
      avatar: json['avatar'] as String?,
      bio: json['bio'] as String,
      followersCount: json['followers_count'] as int,
      followingCount: json['following_count'] as int,
      postsCount: json['posts_count'] as int,
      isFollowing: json['is_following'] as bool? ?? false,
      socialLinks: (json['social_links'] as List<dynamic>)
          .map((e) => e as String)
          .toList(),
      stats: UserStatsModel.fromJson(json['stats'] as Map<String, dynamic>),
      achievements: (json['achievements'] as List<dynamic>)
          .map((e) => AchievementModel.fromJson(e as Map<String, dynamic>))
          .toList(),
      pinnedProjects: (json['pinned_projects'] as List<dynamic>)
          .map((e) => ProjectModel.fromJson(e as Map<String, dynamic>))
          .toList(),
      techStack: (json['tech_stack'] as List<dynamic>)
          .map((e) => e as String)
          .toList(),
    );
  }

  UserProfileEntity toEntity() {
    return UserProfileEntity(
      id: id,
      name: name,
      username: username,
      avatar: avatar,
      bio: bio,
      followersCount: followersCount,
      followingCount: followingCount,
      postsCount: postsCount,
      isFollowing: isFollowing,
      socialLinks: socialLinks,
      stats: stats.toEntity(),
      achievements: achievements.map((m) => m.toEntity()).toList(),
      pinnedProjects: pinnedProjects.map((m) => m.toEntity()).toList(),
      techStack: techStack,
    );
  }
}

class UserStatsModel {
  final int dayStreak;
  final int level;
  final int currentXP;
  final int maxXP;

  UserStatsModel({
    required this.dayStreak,
    required this.level,
    required this.currentXP,
    required this.maxXP,
  });

  factory UserStatsModel.fromJson(Map<String, dynamic> json) {
    return UserStatsModel(
      dayStreak: json['day_streak'] as int,
      level: json['level'] as int,
      currentXP: json['current_xp'] as int,
      maxXP: json['max_xp'] as int,
    );
  }

  UserStatsEntity toEntity() {
    return UserStatsEntity(
      dayStreak: dayStreak,
      level: level,
      currentXP: currentXP,
      maxXP: maxXP,
    );
  }
}

class AchievementModel {
  final String id;
  final String title;
  final String icon;
  final bool isUnlocked;

  AchievementModel({
    required this.id,
    required this.title,
    required this.icon,
    required this.isUnlocked,
  });

  factory AchievementModel.fromJson(Map<String, dynamic> json) {
    return AchievementModel(
      id: json['id'] as String,
      title: json['title'] as String,
      icon: json['icon'] as String,
      isUnlocked: json['is_unlocked'] as bool,
    );
  }

  AchievementEntity toEntity() {
    return AchievementEntity(
      id: id,
      title: title,
      icon: icon,
      isUnlocked: isUnlocked,
    );
  }
}

class ProjectModel {
  final String id;
  final String title;
  final String description;
  final String? imageUrl;
  final List<String> tags;
  final int stars;

  ProjectModel({
    required this.id,
    required this.title,
    required this.description,
    this.imageUrl,
    required this.tags,
    required this.stars,
  });

  factory ProjectModel.fromJson(Map<String, dynamic> json) {
    return ProjectModel(
      id: json['id'] as String,
      title: json['title'] as String,
      description: json['description'] as String,
      imageUrl: json['image_url'] as String?,
      tags: (json['tags'] as List<dynamic>).map((e) => e as String).toList(),
      stars: json['stars'] as int,
    );
  }

  ProjectEntity toEntity() {
    return ProjectEntity(
      id: id,
      title: title,
      description: description,
      imageUrl: imageUrl,
      tags: tags,
      stars: stars,
    );
  }
}
