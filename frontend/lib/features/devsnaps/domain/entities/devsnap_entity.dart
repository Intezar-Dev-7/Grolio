// features/devsnaps/domain/entities/devsnap_entity.dart

import 'package:equatable/equatable.dart';

class DevSnapEntity extends Equatable {
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

  const DevSnapEntity({
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

  bool get isExpired => DateTime.now().isAfter(expiresAt);

  String get timeAgo {
    final difference = DateTime.now().difference(createdAt);
    if (difference.inHours < 1) {
      return '${difference.inMinutes}m ago';
    } else {
      return '${difference.inHours}h ago';
    }
  }

  @override
  List<Object?> get props => [
    id,
    userId,
    username,
    userAvatar,
    imageUrl,
    caption,
    tags,
    codeSnippet,
    language,
    views,
    likes,
    isViewed,
    createdAt,
    expiresAt,
  ];
}
