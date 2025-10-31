// features/chat/presentation/bloc/chat_state.dart

part of 'chat_bloc.dart';

enum ChatStatus {
  initial,
  loading,
  success,
  error,
}

class ChatState extends Equatable {
  final ChatStatus status;
  final List<ConversationEntity> conversations;
  final List<MessageEntity> messages;
  final String? currentConversationId;
  final String? errorMessage;

  const ChatState({
    required this.status,
    required this.conversations,
    required this.messages,
    this.currentConversationId,
    this.errorMessage,
  });

  factory ChatState.initial() {
    return const ChatState(
      status: ChatStatus.initial,
      conversations: [],
      messages: [],
    );
  }

  ChatState copyWith({
    ChatStatus? status,
    List<ConversationEntity>? conversations,
    List<MessageEntity>? messages,
    String? currentConversationId,
    String? errorMessage,
  }) {
    return ChatState(
      status: status ?? this.status,
      conversations: conversations ?? this.conversations,
      messages: messages ?? this.messages,
      currentConversationId:
      currentConversationId ?? this.currentConversationId,
      errorMessage: errorMessage,
    );
  }

  @override
  List<Object?> get props => [
    status,
    conversations,
    messages,
    currentConversationId,
    errorMessage,
  ];
}
