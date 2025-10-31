// features/chat/presentation/bloc/chat_event.dart

part of 'chat_bloc.dart';

abstract class ChatEvent extends Equatable {
  const ChatEvent();

  @override
  List<Object?> get props => [];
}

class ChatConversationsLoadRequested extends ChatEvent {
  const ChatConversationsLoadRequested();
}

class ChatMessagesLoadRequested extends ChatEvent {
  final String conversationId;

  const ChatMessagesLoadRequested(this.conversationId);

  @override
  List<Object?> get props => [conversationId];
}

class ChatMessageSent extends ChatEvent {
  final String conversationId;
  final String content;
  final String type;
  final String? codeLanguage;
  final String? fileName;
  final String? fileSize;
  final String? fileUrl;

  const ChatMessageSent({
    required this.conversationId,
    required this.content,
    required this.type,
    this.codeLanguage,
    this.fileName,
    this.fileSize,
    this.fileUrl,
  });

  @override
  List<Object?> get props => [
    conversationId,
    content,
    type,
    codeLanguage,
    fileName,
    fileSize,
    fileUrl,
  ];
}
