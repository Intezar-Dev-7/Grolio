// features/feed/domain/entities/post_entity.dart

import 'package:equatable/equatable.dart';

class PostEntity extends Equatable {
  final String id;
  final UserInfoEntity author;
  final String content;
  final String? imageUrl;
  final List<String> tags;
  final String? githubUrl;
  final String? demoUrl;
  final PostStatsEntity stats;
  final DateTime createdAt;

  const PostEntity({
    required this.id,
    required this.author,
    required this.content,
    this.imageUrl,
    required this.tags,
    this.githubUrl,
    this.demoUrl,
    required this.stats,
    required this.createdAt,
  });

  @override
  List<Object?> get props => [
    id,
    author,
    content,
    imageUrl,
    tags,
    githubUrl,
    demoUrl,
    stats,
    createdAt,
  ];
}

class UserInfoEntity extends Equatable {
  final String id;
  final String name;
  final String username;
  final String? avatar;

  const UserInfoEntity({
    required this.id,
    required this.name,
    required this.username,
    this.avatar,
  });

  @override
  List<Object?> get props => [id, name, username, avatar];
}

class PostStatsEntity extends Equatable {
  final int likes;
  final int comments;
  final int shares;
  final bool isLiked;
  final bool isBookmarked;

  const PostStatsEntity({
    required this.likes,
    required this.comments,
    required this.shares,
    required this.isLiked,
    required this.isBookmarked,
  });

  PostStatsEntity copyWith({
    int? likes,
    int? comments,
    int? shares,
    bool? isLiked,
    bool? isBookmarked,
  }) {
    return PostStatsEntity(
      likes: likes ?? this.likes,
      comments: comments ?? this.comments,
      shares: shares ?? this.shares,
      isLiked: isLiked ?? this.isLiked,
      isBookmarked: isBookmarked ?? this.isBookmarked,
    );
  }

  @override
  List<Object?> get props => [likes, comments, shares, isLiked, isBookmarked];
}
