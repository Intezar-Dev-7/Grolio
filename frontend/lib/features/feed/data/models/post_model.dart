// features/feed/data/models/post_model.dart

import '../../domain/entities/post_entity.dart';

class PostModel {
  final String id;
  final UserInfoModel author;
  final String content;
  final String? imageUrl;
  final List<String> tags;
  final String? githubUrl;
  final String? demoUrl;
  final PostStatsModel stats;
  final DateTime createdAt;

  PostModel({
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

  factory PostModel.fromJson(Map<String, dynamic> json) {
    return PostModel(
      id: json['id'] as String,
      author: UserInfoModel.fromJson(json['author'] as Map<String, dynamic>),
      content: json['content'] as String,
      imageUrl: json['image_url'] as String?,
      tags: (json['tags'] as List<dynamic>).map((e) => e as String).toList(),
      githubUrl: json['github_url'] as String?,
      demoUrl: json['demo_url'] as String?,
      stats: PostStatsModel.fromJson(json['stats'] as Map<String, dynamic>),
      createdAt: DateTime.parse(json['created_at'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'author': author.toJson(),
      'content': content,
      'image_url': imageUrl,
      'tags': tags,
      'github_url': githubUrl,
      'demo_url': demoUrl,
      'stats': stats.toJson(),
      'created_at': createdAt.toIso8601String(),
    };
  }

  PostEntity toEntity() {
    return PostEntity(
      id: id,
      author: author.toEntity(),
      content: content,
      imageUrl: imageUrl,
      tags: tags,
      githubUrl: githubUrl,
      demoUrl: demoUrl,
      stats: stats.toEntity(),
      createdAt: createdAt,
    );
  }
}

class UserInfoModel {
  final String id;
  final String name;
  final String username;
  final String? avatar;

  UserInfoModel({
    required this.id,
    required this.name,
    required this.username,
    this.avatar,
  });

  factory UserInfoModel.fromJson(Map<String, dynamic> json) {
    return UserInfoModel(
      id: json['id'] as String,
      name: json['name'] as String,
      username: json['username'] as String,
      avatar: json['avatar'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'username': username,
      'avatar': avatar,
    };
  }

  UserInfoEntity toEntity() {
    return UserInfoEntity(
      id: id,
      name: name,
      username: username,
      avatar: avatar,
    );
  }
}

class PostStatsModel {
  final int likes;
  final int comments;
  final int shares;
  final bool isLiked;
  final bool isBookmarked;

  PostStatsModel({
    required this.likes,
    required this.comments,
    required this.shares,
    required this.isLiked,
    required this.isBookmarked,
  });

  factory PostStatsModel.fromJson(Map<String, dynamic> json) {
    return PostStatsModel(
      likes: json['likes'] as int,
      comments: json['comments'] as int,
      shares: json['shares'] as int,
      isLiked: json['is_liked'] as bool,
      isBookmarked: json['is_bookmarked'] as bool,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'likes': likes,
      'comments': comments,
      'shares': shares,
      'is_liked': isLiked,
      'is_bookmarked': isBookmarked,
    };
  }

  PostStatsEntity toEntity() {
    return PostStatsEntity(
      likes: likes,
      comments: comments,
      shares: shares,
      isLiked: isLiked,
      isBookmarked: isBookmarked,
    );
  }
}
