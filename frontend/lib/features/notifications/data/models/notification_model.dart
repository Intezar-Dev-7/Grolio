// features/notifications/data/models/notification_model.dart

import '../../domain/entities/notification_entity.dart';

class NotificationModel {
  final String id;
  final String type;
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

  NotificationModel({
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

  factory NotificationModel.fromJson(Map<String, dynamic> json) {
    return NotificationModel(
      id: json['id'] as String,
      type: json['type'] as String,
      title: json['title'] as String,
      message: json['message'] as String,
      imageUrl: json['image_url'] as String?,
      actionUserId: json['action_user_id'] as String?,
      actionUserName: json['action_user_name'] as String?,
      actionUserAvatar: json['action_user_avatar'] as String?,
      postId: json['post_id'] as String?,
      commentId: json['comment_id'] as String?,
      timestamp: DateTime.parse(json['timestamp'] as String),
      isRead: json['is_read'] as bool,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'type': type,
      'title': title,
      'message': message,
      'image_url': imageUrl,
      'action_user_id': actionUserId,
      'action_user_name': actionUserName,
      'action_user_avatar': actionUserAvatar,
      'post_id': postId,
      'comment_id': commentId,
      'timestamp': timestamp.toIso8601String(),
      'is_read': isRead,
    };
  }

  NotificationEntity toEntity() {
    return NotificationEntity(
      id: id,
      type: _parseNotificationType(type),
      title: title,
      message: message,
      imageUrl: imageUrl,
      actionUserId: actionUserId,
      actionUserName: actionUserName,
      actionUserAvatar: actionUserAvatar,
      postId: postId,
      commentId: commentId,
      timestamp: timestamp,
      isRead: isRead,
    );
  }

  NotificationType _parseNotificationType(String type) {
    switch (type.toLowerCase()) {
      case 'like':
        return NotificationType.like;
      case 'comment':
        return NotificationType.comment;
      case 'follow':
        return NotificationType.follow;
      case 'mention':
        return NotificationType.mention;
      case 'reply':
        return NotificationType.reply;
      case 'achievement':
        return NotificationType.achievement;
      case 'group_invite':
        return NotificationType.groupInvite;
      case 'message':
        return NotificationType.message;
      default:
        return NotificationType.like;
    }
  }
}
