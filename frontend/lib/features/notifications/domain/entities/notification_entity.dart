// features/notifications/domain/entities/notification_entity.dart

import 'package:equatable/equatable.dart';

enum NotificationType {
  like,
  comment,
  follow,
  mention,
  reply,
  achievement,
  groupInvite,
  message,
}

class NotificationEntity extends Equatable {
  final String id;
  final NotificationType type;
  final String title;
  final String message;
  final String? imageUrl;
  final String? actionUserId;
  final String? actionUserName;
  final String? actionUserAvatar;
  final String? postId;
  final String? commentId;
  final DateTime timestamp;
  final bool isRead;

  const NotificationEntity({
    required this.id,
    required this.type,
    required this.title,
    required this.message,
    this.imageUrl,
    this.actionUserId,
    this.actionUserName,
    this.actionUserAvatar,
    this.postId,
    this.commentId,
    required this.timestamp,
    required this.isRead,
  });

  String get timeAgo {
    final now = DateTime.now();
    final difference = now.difference(timestamp);

    if (difference.inSeconds < 60) {
      return 'Just now';
    } else if (difference.inMinutes < 60) {
      return '${difference.inMinutes}m ago';
    } else if (difference.inHours < 24) {
      return '${difference.inHours}h ago';
    } else if (difference.inDays < 7) {
      return '${difference.inDays}d ago';
    } else {
      return '${(difference.inDays / 7).floor()}w ago';
    }
  }

  @override
  List<Object?> get props => [
    id,
    type,
    title,
    message,
    imageUrl,
    actionUserId,
    actionUserName,
    actionUserAvatar,
    postId,
    commentId,
    timestamp,
    isRead,
  ];
}
