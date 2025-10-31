// features/user_details/data/models/user_details_model.dart

import '../../domain/entities/user_details_entity.dart';

class UserDetailsModel {
  final String id;
  final String name;
  final String username;
  final String? avatar;
  final String? coverImage;
  final String bio;
  final String? location;
  final String? website;
  final DateTime joinedDate;
  final int followersCount;
  final int followingCount;
  final int postsCount;
  final bool isFollowing;
  final bool isOnline;
  final String? lastSeen;
  final List<String> socialLinks;
  final List<String> techStack;
  final List<UserPostModel> recentPosts;
  final UserStatsModel stats;

  UserDetailsModel({
    required this.id,
    required this.name,
    required this.username,
    this.avatar,
    this.coverImage,
    required this.bio,
    this.location,
    this.website,
    required this.joinedDate,
    required this.followersCount,
    required this.followingCount,
    required this.postsCount,
    required this.isFollowing,
    required this.isOnline,
    this.lastSeen,
    required this.socialLinks,
    required this.techStack,
    required this.recentPosts,
    required this.stats,
  });

  factory UserDetailsModel.fromJson(Map<String, dynamic> json) {
    return UserDetailsModel(
      id: json['id'] as String,
      name: json['name'] as String,
      username: json['username'] as String,
      avatar: json['avatar'] as String?,
      coverImage: json['cover_image'] as String?,
      bio: json['bio'] as String,
      location: json['location'] as String?,
      website: json['website'] as String?,
      joinedDate: DateTime.parse(json['joined_date'] as String),
      followersCount: json['followers_count'] as int,
      followingCount: json['following_count'] as int,
      postsCount: json['posts_count'] as int,
      isFollowing: json['is_following'] as bool,
      isOnline: json['is_online'] as bool,
      lastSeen: json['last_seen'] as String?,
      socialLinks: (json['social_links'] as List<dynamic>)
          .map((e) => e as String)
          .toList(),
      techStack: (json['tech_stack'] as List<dynamic>)
          .map((e) => e as String)
          .toList(),
      recentPosts: (json['recent_posts'] as List<dynamic>)
          .map((e) => UserPostModel.fromJson(e as Map<String, dynamic>))
          .toList(),
      stats: UserStatsModel.fromJson(json['stats'] as Map<String, dynamic>),
    );
  }

  UserDetailsEntity toEntity() {
    return UserDetailsEntity(
      id: id,
      name: name,
      username: username,
      avatar: avatar,
      coverImage: coverImage,
      bio: bio,
      location: location,
      website: website,
      joinedDate: joinedDate,
      followersCount: followersCount,
      followingCount: followingCount,
      postsCount: postsCount,
      isFollowing: isFollowing,
      isOnline: isOnline,
      lastSeen: lastSeen,
      socialLinks: socialLinks,
      techStack: techStack,
      recentPosts: recentPosts.map((m) => m.toEntity()).toList(),
      stats: stats.toEntity(),
    );
  }
}

class UserPostModel {
  final String id;
  final String content;
  final String? imageUrl;
  final int likes;
  final int comments;
  final DateTime createdAt;

  UserPostModel({
    required this.id,
    required this.content,
    this.imageUrl,
    required this.likes,
    required this.comments,
    required this.createdAt,
  });

  factory UserPostModel.fromJson(Map<String, dynamic> json) {
    return UserPostModel(
      id: json['id'] as String,
      content: json['content'] as String,
      imageUrl: json['image_url'] as String?,
      likes: json['likes'] as int,
      comments: json['comments'] as int,
      createdAt: DateTime.parse(json['created_at'] as String),
    );
  }

  UserPostEntity toEntity() {
    return UserPostEntity(
      id: id,
      content: content,
      imageUrl: imageUrl,
      likes: likes,
      comments: comments,
      createdAt: createdAt,
    );
  }
}

class UserStatsModel {
  final int contributionStreak;
  final int totalContributions;
  final String rank;

  UserStatsModel({
    required this.contributionStreak,
    required this.totalContributions,
    required this.rank,
  });

  factory UserStatsModel.fromJson(Map<String, dynamic> json) {
    return UserStatsModel(
      contributionStreak: json['contribution_streak'] as int,
      totalContributions: json['total_contributions'] as int,
      rank: json['rank'] as String,
    );
  }

  UserStatsEntity toEntity() {
    return UserStatsEntity(
      contributionStreak: contributionStreak,
      totalContributions: totalContributions,
      rank: rank,
    );
  }
}
