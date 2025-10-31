// features/chat/data/models/conversation_model.dart

import '../../domain/entities/conversation_entity.dart';

class ConversationModel {
  final String id;
  final String userId;
  final String userName;
  final String? userAvatar;
  final String lastMessage;
  final DateTime lastMessageTime;
  final int unreadCount;
  final bool isOnline;
  final bool isGroup;
  final String? messageType;

  ConversationModel({
    required this.id,
    required this.userId,
    required this.userName,
    this.userAvatar,
    required this.lastMessage,
    required this.lastMessageTime,
    required this.unreadCount,
    required this.isOnline,
    required this.isGroup,
    this.messageType,
  });

  factory ConversationModel.fromJson(Map<String, dynamic> json) {
    return ConversationModel(
      id: json['id'] as String,
      userId: json['user_id'] as String,
      userName: json['user_name'] as String,
      userAvatar: json['user_avatar'] as String?,
      lastMessage: json['last_message'] as String,
      lastMessageTime: DateTime.parse(json['last_message_time'] as String),
      unreadCount: json['unread_count'] as int? ?? 0,
      isOnline: json['is_online'] as bool? ?? false,
      isGroup: json['is_group'] as bool? ?? false,
      messageType: json['message_type'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user_id': userId,
      'user_name': userName,
      'user_avatar': userAvatar,
      'last_message': lastMessage,
      'last_message_time': lastMessageTime.toIso8601String(),
      'unread_count': unreadCount,
      'is_online': isOnline,
      'is_group': isGroup,
      'message_type': messageType,
    };
  }

  ConversationEntity toEntity() {
    return ConversationEntity(
      id: id,
      userId: userId,
      userName: userName,
      userAvatar: userAvatar,
      lastMessage: lastMessage,
      lastMessageTime: lastMessageTime,
      unreadCount: unreadCount,
      isOnline: isOnline,
      isGroup: isGroup,
      messageType: messageType,
    );
  }
}
