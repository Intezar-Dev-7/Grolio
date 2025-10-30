// features/devsnaps/data/models/devsnap_model.dart

import '../../domain/entities/devsnap_entity.dart';

class DevSnapModel {
  final String id;
  final String userId;
  final String username;
  final String? userAvatar;
  final String imageUrl;
  final String? caption;
  final List<String> tags;
  final String? codeSnippet;
  final String? language;
  final int views;
  final int likes;
  final bool isViewed;
  final DateTime createdAt;
  final DateTime expiresAt;

  DevSnapModel({
    required this.id,
    required this.userId,
    required this.username,
    this.userAvatar,
    required this.imageUrl,
    this.caption,
    required this.tags,
    this.codeSnippet,
    this.language,
    required this.views,
    required this.likes,
    required this.isViewed,
    required this.createdAt,
    required this.expiresAt,
  });

  factory DevSnapModel.fromJson(Map<String, dynamic> json) {
    return DevSnapModel(
      id: json['id'] as String,
      userId: json['user_id'] as String,
      username: json['username'] as String,
      userAvatar: json['user_avatar'] as String?,
      imageUrl: json['image_url'] as String,
      caption: json['caption'] as String?,
      tags: (json['tags'] as List<dynamic>?)?.map((e) => e as String).toList() ?? [],
      codeSnippet: json['code_snippet'] as String?,
      language: json['language'] as String?,
      views: json['views'] as int,
      likes: json['likes'] as int,
      isViewed: json['is_viewed'] as bool? ?? false,
      createdAt: DateTime.parse(json['created_at'] as String),
      expiresAt: DateTime.parse(json['expires_at'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user_id': userId,
      'username': username,
      'user_avatar': userAvatar,
      'image_url': imageUrl,
      'caption': caption,
      'tags': tags,
      'code_snippet': codeSnippet,
      'language': language,
      'views': views,
      'likes': likes,
      'is_viewed': isViewed,
      'created_at': createdAt.toIso8601String(),
      'expires_at': expiresAt.toIso8601String(),
    };
  }

  DevSnapEntity toEntity() {
    return DevSnapEntity(
      id: id,
      userId: userId,
      username: username,
      userAvatar: userAvatar,
      imageUrl: imageUrl,
      caption: caption,
      tags: tags,
      codeSnippet: codeSnippet,
      language: language,
      views: views,
      likes: likes,
      isViewed: isViewed,
      createdAt: createdAt,
      expiresAt: expiresAt,
    );
  }
}
