// features/chat/presentation/bloc/chat_bloc.dart

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import '../../domain/entities/conversation_entity.dart';
import '../../domain/entities/message_entity.dart';
import '../../data/datasources/chat_remote_datasource.dart';

part 'chat_event.dart';
part 'chat_state.dart';

class ChatBloc extends Bloc<ChatEvent, ChatState> {
  final ChatRemoteDataSource remoteDataSource;

  ChatBloc({required this.remoteDataSource}) : super(ChatState.initial()) {
    on<ChatConversationsLoadRequested>(_onConversationsLoadRequested);
    on<ChatMessagesLoadRequested>(_onMessagesLoadRequested);
    on<ChatMessageSent>(_onMessageSent);
  }

  Future<void> _onConversationsLoadRequested(
      ChatConversationsLoadRequested event,
      Emitter<ChatState> emit,
      ) async {
    emit(state.copyWith(status: ChatStatus.loading));

    try {
      final conversations = await remoteDataSource.getConversations();
      emit(state.copyWith(
        status: ChatStatus.success,
        conversations: conversations.map((m) => m.toEntity()).toList(),
      ));
    } catch (e) {
      emit(state.copyWith(
        status: ChatStatus.error,
        errorMessage: e.toString(),
      ));
    }
  }

  Future<void> _onMessagesLoadRequested(
      ChatMessagesLoadRequested event,
      Emitter<ChatState> emit,
      ) async {
    emit(state.copyWith(status: ChatStatus.loading));

    try {
      final messages = await remoteDataSource.getMessages(event.conversationId);
      emit(state.copyWith(
        status: ChatStatus.success,
        messages: messages.map((m) => m.toEntity()).toList(),
        currentConversationId: event.conversationId,
      ));
    } catch (e) {
      emit(state.copyWith(
        status: ChatStatus.error,
        errorMessage: e.toString(),
      ));
    }
  }

  Future<void> _onMessageSent(
      ChatMessageSent event,
      Emitter<ChatState> emit,
      ) async {
    try {
      final message = await remoteDataSource.sendMessage(
        conversationId: event.conversationId,
        content: event.content,
        type: event.type,
        codeLanguage: event.codeLanguage,
        fileName: event.fileName,
        fileSize: event.fileSize,
        fileUrl: event.fileUrl,
      );

      final updatedMessages = List<MessageEntity>.from(state.messages)
        ..add(message.toEntity());

      emit(state.copyWith(
        status: ChatStatus.success,
        messages: updatedMessages,
      ));
    } catch (e) {
      emit(state.copyWith(
        status: ChatStatus.error,
        errorMessage: e.toString(),
      ));
    }
  }
}
