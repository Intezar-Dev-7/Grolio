// features/chat/data/datasources/chat_remote_datasource.dart

import 'package:frontend/features/chat/data/models/meeting_info_model.dart';

import '../../../../core/error/exceptions.dart';
import '../../../../core/network/dio_client.dart';
import '../models/conversation_model.dart';
import '../models/message_model.dart';

abstract class ChatRemoteDataSource {
  Future<List<ConversationModel>> getConversations();
  Future<List<MessageModel>> getMessages(String conversationId);
  Future<MessageModel> sendMessage({
    required String conversationId,
    required String content,
    required String type,
    String? codeLanguage,
    String? fileName,
    String? fileSize,
    String? fileUrl,
  });
}

class ChatRemoteDataSourceImpl implements ChatRemoteDataSource {
  final DioClient dioClient;

  ChatRemoteDataSourceImpl({required this.dioClient});

  @override
  Future<List<ConversationModel>> getConversations() async {
    // TODO: Remove mock data when backend is ready
    await Future.delayed(const Duration(seconds: 1));

    return [
      ConversationModel(
        id: 'conv_1',
        userId: 'user_1',
        userName: 'Jordan Lee',
        userAvatar: 'https://i.pravatar.cc/150?u=jordan',
        lastMessage: 'Awesome! Also sharing the updated component file:',
        lastMessageTime: DateTime.now().subtract(const Duration(minutes: 2)),
        unreadCount: 0,
        isOnline: true,
        isGroup: false,
        messageType: 'code',
      ),
      ConversationModel(
        id: 'conv_2',
        userId: 'group_1',
        userName: 'Frontend Team',
        userAvatar: null,
        lastMessage: 'Alex: Here\'s the latest architecture design',
        lastMessageTime: DateTime.now().subtract(const Duration(hours: 2)),
        unreadCount: 3,
        isOnline: false,
        isGroup: true,
        messageType: 'text',
      ),
      ConversationModel(
        id: 'conv_3',
        userId: 'user_2',
        userName: 'Sarah Chen',
        userAvatar: 'https://i.pravatar.cc/150?u=sarah',
        lastMessage: 'Thanks for the review! I\'ll push the fixes soon',
        lastMessageTime: DateTime.now().subtract(const Duration(days: 1)),
        unreadCount: 0,
        isOnline: true,
        isGroup: false,
        messageType: 'text',
      ),
      ConversationModel(
        id: 'conv_4',
        userId: 'group_2',
        userName: 'Backend Guild',
        userAvatar: null,
        lastMessage: 'Priya: const handleAuth = async () =>',
        lastMessageTime: DateTime.now().subtract(const Duration(days: 1)),
        unreadCount: 12,
        isOnline: false,
        isGroup: true,
        messageType: 'code',
      ),
      ConversationModel(
        id: 'conv_5',
        userId: 'user_3',
        userName: 'Maya Rodriguez',
        userAvatar: 'https://i.pravatar.cc/150?u=maya',
        lastMessage: 'Perfect! Let\'s sync tomorrow morning.',
        lastMessageTime: DateTime.now().subtract(const Duration(days: 2)),
        unreadCount: 0,
        isOnline: false,
        isGroup: false,
        messageType: 'text',
      ),
      ConversationModel(
        id: 'conv_6',
        userId: 'group_3',
        userName: 'DevOps Squad',
        userAvatar: null,
        lastMessage: 'Alex: Pipeline is green! 🎉',
        lastMessageTime: DateTime.now().subtract(const Duration(days: 3)),
        unreadCount: 0,
        isOnline: false,
        isGroup: true,
        messageType: 'text',
      ),
    ];
  }

  @override
  Future<List<MessageModel>> getMessages(String conversationId) async {
    // TODO: Remove mock data when backend is ready
    await Future.delayed(const Duration(seconds: 1));

    return [
      MessageModel(
        id: 'msg_1',
        conversationId: conversationId,
        senderId: 'user_1',
        senderName: 'Jordan Lee',
        senderAvatar: 'https://i.pravatar.cc/150?u=jordan',
        content: 'Hey! Did you get a chance to review the PR I submitted yesterday?',
        type: 'text',
        timestamp: DateTime.now().subtract(const Duration(minutes: 30)),
        isSentByMe: false,
        isRead: false,
      ),
      MessageModel(
        id: 'msg_2',
        conversationId: conversationId,
        senderId: 'me',
        content: 'Yes! Just finished reviewing it. Left a few comments on the authentication logic.',
        type: 'text',
        timestamp: DateTime.now().subtract(const Duration(minutes: 28)),
        isSentByMe: true,
        isRead: false,
      ),
      MessageModel(
        id: 'msg_3',
        conversationId: conversationId,
        senderId: 'user_1',
        senderName: 'Jordan Lee',
        senderAvatar: 'https://i.pravatar.cc/150?u=jordan',
        content: 'Thanks! I see what you mean. Here\'s the updated approach:',
        type: 'text',
        timestamp: DateTime.now().subtract(const Duration(minutes: 27)),
        isSentByMe: false,
        isRead: false,
      ),
      MessageModel(
        id: 'msg_4',
        conversationId: conversationId,
        senderId: 'user_1',
        senderName: 'Jordan Lee',
        senderAvatar: 'https://i.pravatar.cc/150?u=jordan',
        content: '''typescript
"text-primary">async "text-primary">"text-primary" {
  "text-primary">try {
    "text-primary">const decoded = "text-primary">;
  } "text-primary">.catch (error) {
    "text-primary">return { success: false };
  }
}''',
        type: 'code',
        codeLanguage: 'typescript',
        timestamp: DateTime.now().subtract(const Duration(minutes: 26)),
        isSentByMe: false,
        isRead: false,
      ),
      MessageModel(
        id: 'msg_meeting_1',
        senderId: 'user_456',
        senderName: 'Intezaar',
        content: 'Meeting scheduled',
        type: 'meeting',
        timestamp: DateTime.now().subtract(const Duration(hours: 5)),
        isRead: true,
        isSentByMe: true,
        conversationId: conversationId,
        meetingInfomodel: MeetingInfoModel(
          title: 'Grolio',
          platform: 'Zoom',
          startTime: DateTime(2025, 10, 7, 10, 30),
          endTime: DateTime(2025, 10, 7, 12, 0),
          meetingLink: 'https://zoom.us/j/123456789',
          isAttending: true,
        ),
      ),
      MessageModel(
        id: 'msg_5',
        conversationId: conversationId,
        senderId: 'me',
        content: 'Perfect! That\'s much cleaner. The error handling looks good now 👍',
        type: 'text',
        timestamp: DateTime.now().subtract(const Duration(minutes: 25)),
        isSentByMe: true,
        isRead: false,
      ),
      MessageModel(
        id: 'msg_6',
        conversationId: conversationId,
        senderId: 'user_1',
        senderName: 'Jordan Lee',
        senderAvatar: 'https://i.pravatar.cc/150?u=jordan',
        content: 'Awesome! Also sharing the updated component file:',
        type: 'text',
        timestamp: DateTime.now().subtract(const Duration(minutes: 20)),
        isSentByMe: false,
        isRead: false,
      ),
      MessageModel(
        id: 'msg_7',
        conversationId: conversationId,
        senderId: 'user_1',
        senderName: 'Jordan Lee',
        senderAvatar: 'https://i.pravatar.cc/150?u=jordan',
        content: '',
        type: 'file',
        fileName: 'AuthProvider.tsx',
        fileSize: '3.2 KB',
        timestamp: DateTime.now().subtract(const Duration(minutes: 20)),
        isSentByMe: false,
        isRead: false,
      ),
    ];
  }

  @override
  Future<MessageModel> sendMessage({
    required String conversationId,
    required String content,
    required String type,
    String? codeLanguage,
    String? fileName,
    String? fileSize,
    String? fileUrl,
  }) async {
    try {
      final response = await dioClient.post(
        '/chat/messages',
        data: {
          'conversation_id': conversationId,
          'content': content,
          'type': type,
          'code_language': codeLanguage,
          'file_name': fileName,
          'file_size': fileSize,
          'file_url': fileUrl,
        },
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        return MessageModel.fromJson(response.data['data']);
      } else {
        throw ServerException(message: 'Failed to send message');
      }
    } catch (e) {
      throw ServerException(message: e.toString());
    }
  }
}
