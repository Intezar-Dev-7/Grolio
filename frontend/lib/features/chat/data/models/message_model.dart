// features/chat/data/models/message_model.dart

import 'package:frontend/features/chat/data/models/meeting_info_model.dart';
import 'package:frontend/features/chat/domain/entities/meeting_info_entity.dart';

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
  final bool isRead;
  final String? codeLanguage;
  final String? fileName;
  final String? fileSize;
  final String? fileUrl;
  final MeetingInfoModel? meetingInfomodel;

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
    required this.isRead,
    this.codeLanguage,
    this.fileName,
    this.fileSize,
    this.fileUrl,
    this.meetingInfomodel,
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
      isRead: json['is_read'] as bool,
      timestamp: DateTime.parse(json['timestamp'] as String),
      isSentByMe: json['is_sent_by_me'] as bool,
      codeLanguage: json['code_language'] as String?,
      fileName: json['file_name'] as String?,
      fileSize: json['file_size'] as String?,
      fileUrl: json['file_url'] as String?,
      meetingInfomodel: json['meeting_info'] != null
          ? MeetingInfoModel.fromJson(json['meeting_info'])
          : null,
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
      'is_read': isRead,
      'code_language': codeLanguage,
      'file_name': fileName,
      'file_size': fileSize,
      'file_url': fileUrl,
      'meeting_info': meetingInfomodel,
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
      case 'meeting':
        messageType = MessageType.meeting;
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
      isRead: isRead,
      codeLanguage: codeLanguage,
      fileName: fileName,
      fileSize: fileSize,
      fileUrl: fileUrl,
      meetingInfo: meetingInfomodel?.toEntity(),
    );
  }
}
