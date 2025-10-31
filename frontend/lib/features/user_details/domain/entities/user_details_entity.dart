// features/user_details/domain/entities/user_details_entity.dart

import 'package:equatable/equatable.dart';

class UserDetailsEntity extends Equatable {
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
  final List<UserPostEntity> recentPosts;
  final UserStatsEntity stats;

  const UserDetailsEntity({
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

  String get memberSince {
    final now = DateTime.now();
    final difference = now.difference(joinedDate);

    if (difference.inDays >= 365) {
      final years = (difference.inDays / 365).floor();
      return '$years ${years == 1 ? 'year' : 'years'}';
    } else if (difference.inDays >= 30) {
      final months = (difference.inDays / 30).floor();
      return '$months ${months == 1 ? 'month' : 'months'}';
    } else {
      return '${difference.inDays} ${difference.inDays == 1 ? 'day' : 'days'}';
    }
  }

  @override
  List<Object?> get props => [
    id,
    name,
    username,
    avatar,
    coverImage,
    bio,
    location,
    website,
    joinedDate,
    followersCount,
    followingCount,
    postsCount,
    isFollowing,
    isOnline,
    lastSeen,
    socialLinks,
    techStack,
    recentPosts,
    stats,
  ];
}

class UserPostEntity extends Equatable {
  final String id;
  final String content;
  final String? imageUrl;
  final int likes;
  final int comments;
  final DateTime createdAt;

  const UserPostEntity({
    required this.id,
    required this.content,
    this.imageUrl,
    required this.likes,
    required this.comments,
    required this.createdAt,
  });

  @override
  List<Object?> get props => [id, content, imageUrl, likes, comments, createdAt];
}

class UserStatsEntity extends Equatable {
  final int contributionStreak;
  final int totalContributions;
  final String rank;

  const UserStatsEntity({
    required this.contributionStreak,
    required this.totalContributions,
    required this.rank,
  });

  @override
  List<Object?> get props => [contributionStreak, totalContributions, rank];
}
