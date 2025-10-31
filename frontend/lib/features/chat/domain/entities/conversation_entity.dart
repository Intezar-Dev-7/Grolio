// features/chat/domain/entities/conversation_entity.dart

import 'package:equatable/equatable.dart';

class ConversationEntity extends Equatable {
  final String id;
  final String userId;
  final String userName;
  final String? userAvatar;
  final String lastMessage;
  final DateTime lastMessageTime;
  final int unreadCount;
  final bool isOnline;
  final bool isGroup;
  final String? messageType; // 'text', 'code', 'file'

  const ConversationEntity({
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

  String get timeAgo {
    final now = DateTime.now();
    final difference = now.difference(lastMessageTime);

    if (difference.inDays > 7) {
      return '${(difference.inDays / 7).floor()}w ago';
    } else if (difference.inDays > 0) {
      return '${difference.inDays}d ago';
    } else if (difference.inHours > 0) {
      return '${difference.inHours}h ago';
    } else if (difference.inMinutes > 0) {
      return '${difference.inMinutes}m ago';
    } else {
      return 'Just now';
    }
  }

  String get formattedTime {
    final now = DateTime.now();
    final difference = now.difference(lastMessageTime);

    if (difference.inDays == 0) {
      final hour = lastMessageTime.hour;
      final minute = lastMessageTime.minute.toString().padLeft(2, '0');
      final period = hour >= 12 ? 'PM' : 'AM';
      final displayHour = hour > 12 ? hour - 12 : (hour == 0 ? 12 : hour);
      return '$displayHour:$minute $period';
    } else if (difference.inDays == 1) {
      return 'Yesterday';
    } else if (difference.inDays < 7) {
      return '${difference.inDays}d ago';
    } else {
      return timeAgo;
    }
  }

  @override
  List<Object?> get props => [
    id,
    userId,
    userName,
    userAvatar,
    lastMessage,
    lastMessageTime,
    unreadCount,
    isOnline,
    isGroup,
    messageType,
  ];
}
