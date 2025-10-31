// features/chat/data/models/message_model.dart

import '../../domain/entities/message_entity.dart';

class MessageModel {
  final String id;
  final String conversationId;
  final String senderId;
  final String? senderName;
  final String? senderAvatar;
  final String content;
  final String type;
  final DateTime timestamp;
  final bool isSentByMe;
  final String? codeLanguage;
  final String? fileName;
  final String? fileSize;
  final String? fileUrl;

  MessageModel({
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

  factory MessageModel.fromJson(Map<String, dynamic> json) {
    return MessageModel(
      id: json['id'] as String,
      conversationId: json['conversation_id'] as String,
      senderId: json['sender_id'] as String,
      senderName: json['sender_name'] as String?,
      senderAvatar: json['sender_avatar'] as String?,
      content: json['content'] as String,
      type: json['type'] as String,
      timestamp: DateTime.parse(json['timestamp'] as String),
      isSentByMe: json['is_sent_by_me'] as bool,
      codeLanguage: json['code_language'] as String?,
      fileName: json['file_name'] as String?,
      fileSize: json['file_size'] as String?,
      fileUrl: json['file_url'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'conversation_id': conversationId,
      'sender_id': senderId,
      'sender_name': senderName,
      'sender_avatar': senderAvatar,
      'content': content,
      'type': type,
      'timestamp': timestamp.toIso8601String(),
      'is_sent_by_me': isSentByMe,
      'code_language': codeLanguage,
      'file_name': fileName,
      'file_size': fileSize,
      'file_url': fileUrl,
    };
  }

  MessageEntity toEntity() {
    MessageType messageType;
    switch (type) {
      case 'code':
        messageType = MessageType.code;
        break;
      case 'file':
        messageType = MessageType.file;
        break;
      case 'image':
        messageType = MessageType.image;
        break;
      default:
        messageType = MessageType.text;
    }

    return MessageEntity(
      id: id,
      conversationId: conversationId,
      senderId: senderId,
      senderName: senderName,
      senderAvatar: senderAvatar,
      content: content,
      type: messageType,
      timestamp: timestamp,
      isSentByMe: isSentByMe,
      codeLanguage: codeLanguage,
      fileName: fileName,
      fileSize: fileSize,
      fileUrl: fileUrl,
    );
  }
}
