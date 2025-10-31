// features/chat/domain/entities/message_entity.dart

import 'package:equatable/equatable.dart';

enum MessageType { text, code, file, image }

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
  final String? codeLanguage;
  final String? fileName;
  final String? fileSize;
  final String? fileUrl;

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
    this.codeLanguage,
    this.fileName,
    this.fileSize,
    this.fileUrl,
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
    codeLanguage,
    fileName,
    fileSize,
    fileUrl,
  ];
}
