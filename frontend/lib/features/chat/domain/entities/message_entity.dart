// features/chat/domain/entities/message_entity.dart

import 'package:equatable/equatable.dart';
import 'package:frontend/features/chat/domain/entities/meeting_info_entity.dart';

enum MessageType { text, code, file, image, meeting }

class MessageEntity extends Equatable {
  final String id;
  final String conversationId;
  final String senderId;
  final String? senderName;
  final String? senderAvatar;
  final String content;
  final MessageType type;
  final DateTime timestamp;
  final bool isSentByMe;
  final bool isRead;
  final String? codeLanguage;
  final String? fileName;
  final String? fileSize;
  final String? fileUrl;
  final MeetingInfo? meetingInfo;

  const MessageEntity({
    required this.id,
    required this.conversationId,
    required this.senderId,
    this.senderName,
    this.senderAvatar,
    required this.content,
    required this.type,
    required this.timestamp,
    required this.isSentByMe,
    required this.isRead,
    this.codeLanguage,
    this.fileName,
    this.fileSize,
    this.fileUrl,
    this.meetingInfo,

  });

  String get formattedTime {
    final hour = timestamp.hour;
    final minute = timestamp.minute.toString().padLeft(2, '0');
    final period = hour >= 12 ? 'PM' : 'AM';
    final displayHour = hour > 12 ? hour - 12 : (hour == 0 ? 12 : hour);
    return '$displayHour:$minute $period';
  }

  @override
  List<Object?> get props => [
    id,
    conversationId,
    senderId,
    senderName,
    senderAvatar,
    content,
    type,
    timestamp,
    isSentByMe,
    isRead,
    codeLanguage,
    fileName,
    fileSize,
    fileUrl,
    meetingInfo,

  ];
}
