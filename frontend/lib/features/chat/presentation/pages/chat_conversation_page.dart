// features/chat/presentation/pages/chat_conversation_page.dart

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:frontend/core/constants/app_assets.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_typography.dart';
import '../../domain/entities/conversation_entity.dart';
import '../bloc/chat_bloc.dart';
import '../widgets/message_bubble.dart';
import '../widgets/chat_input_bar.dart';

class ChatConversationPage extends StatefulWidget {
  final ConversationEntity conversation;

  const ChatConversationPage({
    super.key,
    required this.conversation,
  });

  @override
  State<ChatConversationPage> createState() => _ChatConversationPageState();
}

class _ChatConversationPageState extends State<ChatConversationPage> {
  final ScrollController _scrollController = ScrollController();
  final TextEditingController _messageController = TextEditingController();

  @override
  void initState() {
    super.initState();
    context.read<ChatBloc>().add(
      ChatMessagesLoadRequested(widget.conversation.id),
    );
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _messageController.dispose();
    super.dispose();
  }

  void _scrollToBottom() {
    if (_scrollController.hasClients) {
      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundDark,
      appBar: AppBar(
        backgroundColor: AppColors.backgroundDark,
        elevation: 0,
        automaticallyImplyLeading: false,
        title: Row(
          children: [
            InkWell(
              onTap: () {
                Navigator.pop(context);
              },
              child: const Icon(
                Icons.arrow_back_ios_new_rounded,
                color: AppColors.iconColor,
              ),
            ),
            const SizedBox(
              width: 8,
            ),
            Stack(
              children: [
                CircleAvatar(
                  radius: 20,
                  backgroundColor: widget.conversation.isGroup
                      ? AppColors.primaryBlue.withOpacity(0.2)
                      : AppColors.primaryGreen.withOpacity(0.2),
                  child: widget.conversation.isGroup
                      ? const Icon(
                    Icons.group,
                    color: AppColors.primaryBlue,
                    size: 20,
                  )
                      : Text(
                    widget.conversation.userName[0].toUpperCase(),
                    style: const TextStyle(
                      color: AppColors.primaryGreen,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                if (widget.conversation.isOnline && !widget.conversation.isGroup)
                  Positioned(
                    right: 0,
                    bottom: 0,
                    child: Container(
                      width: 12,
                      height: 12,
                      decoration: BoxDecoration(
                        color: AppColors.success,
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: AppColors.backgroundDark,
                          width: 2,
                        ),
                      ),
                    ),
                  ),
              ],
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.conversation.userName,
                    style: AppTypography.titleMedium.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  Text(
                    widget.conversation.isOnline ? 'Active now' : 'Offline',
                    style: AppTypography.bodySmall.copyWith(
                      color: widget.conversation.isOnline
                          ? AppColors.success
                          : AppColors.textSecondary,
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: Image.asset(
              AppAssets.callIcon,
              color: AppColors.iconColor,
              width: 20,
              height: 20,
            ),
            onPressed: () {},
          ),
          IconButton(
            icon: Image.asset(
              AppAssets.videoCallIcon,
              color: AppColors.iconColor,
              width: 20,
              height: 20,
            ),
            onPressed: () {},
          ),
          IconButton(
            icon: const Icon(
              Icons.more_vert,
              color: AppColors.iconColor,
            ),
            onPressed: () {},
          ),
        ],
      ),
      body: Column(
        children: [
          // Messages List
          Expanded(
            child: BlocBuilder<ChatBloc, ChatState>(
              builder: (context, state) {
                if (state.status == ChatStatus.loading &&
                    state.messages.isEmpty) {
                  return const Center(
                    child: CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation<Color>(
                        AppColors.primaryGreen,
                      ),
                    ),
                  );
                }

                if (state.messages.isEmpty) {
                  return const Center(
                    child: Text(
                      'No messages yet',
                      style: TextStyle(
                        color: AppColors.textSecondary,
                      ),
                    ),
                  );
                }

                // Scroll to bottom after build
                WidgetsBinding.instance.addPostFrameCallback((_) {
                  _scrollToBottom();
                });

                return ListView.builder(
                  controller: _scrollController,
                  padding: const EdgeInsets.all(16),
                  itemCount: state.messages.length,
                  itemBuilder: (context, index) {
                    final message = state.messages[index];
                    final showAvatar = index == state.messages.length - 1 ||
                        state.messages[index + 1].senderId != message.senderId;

                    return MessageBubble(
                      message: message,
                      showAvatar: showAvatar,
                    );
                  },
                );
              },
            ),
          ),

          // Input Bar
          ChatInputBar(
            controller: _messageController,
            onSend: (message) {
              if (message.trim().isEmpty) return;

              context.read<ChatBloc>().add(
                ChatMessageSent(
                  conversationId: widget.conversation.id,
                  content: message,
                  type: 'text',
                ),
              );

              _messageController.clear();
              _scrollToBottom();
            },
            onAttach: () {
              // TODO: Implement file attachment
            },
            onCodeSnippet: () {
              // TODO: Implement code snippet
            },
          ),
        ],
      ),
    );
  }
}
