// features/chat/presentation/pages/chat_conversation_page.dart

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:frontend/config/dependency_injection.dart' as di;
import 'package:frontend/core/constants/app_assets.dart';
import 'package:frontend/core/router/app_router.dart';
import 'package:frontend/features/groups/data/datasources/group_remote_datasource.dart';
import 'package:frontend/features/groups/presentation/bloc/group_details_bloc.dart';
import 'package:frontend/features/groups/presentation/page/group_details_page.dart';
import 'package:frontend/features/user_details/data/datasources/user_details_remote_datasource.dart';
import 'package:frontend/features/user_details/presentation/bloc/user_details_bloc.dart';
import 'package:frontend/features/user_details/presentation/page/user_profile.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_typography.dart';
import '../../domain/entities/conversation_entity.dart';
import '../bloc/chat_bloc.dart';
import '../widgets/message_bubble.dart';
import '../widgets/chat_input_bar.dart';

class ChatConversationPage extends StatefulWidget {
  final ConversationEntity conversation;

  const ChatConversationPage({super.key, required this.conversation});

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
        title: GestureDetector(
          onTap: () {
            // Navigator.pushNamed(context, AppRouter.profile,arguments: {'userId' : widget.conversation.userId});
            if (widget.conversation.isGroup) {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder:
                      (context) => BlocProvider(
                        create:
                            (context) => GroupDetailsBloc(
                              remoteDataSource: di.sl<GroupRemoteDataSource>(),
                            ),
                        child: const GroupDetailsPage(groupId: 'group_003'),
                      ),
                ),
              );
            } else {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder:
                      (context) => BlocProvider(
                        create:
                            (context) => UserDetailsBloc(
                              remoteDataSource:
                                  di.sl<UserDetailsRemoteDataSource>(),
                            ),
                        child: UserProfile(userId: widget.conversation.userId),
                      ),
                ),
              );
            }
          },
          child: Row(
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
              const SizedBox(width: 8),
              Stack(
                children: [
                  CircleAvatar(
                    radius: 20,
                    backgroundColor:
                        widget.conversation.isGroup
                            ? AppColors.primaryBlue.withOpacity(0.2)
                            : AppColors.primaryGreen.withOpacity(0.2),
                    child:
                        widget.conversation.isGroup
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
                  if (widget.conversation.isOnline &&
                      !widget.conversation.isGroup)
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
                        color:
                            widget.conversation.isOnline
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
              AppAssets.cameraIcon,
              color: AppColors.iconColor,
              width: 20,
              height: 20,
            ),
            onPressed: () {},
          ),
          PopupMenuButton<String>(
            icon: const Icon(Icons.more_vert, color: AppColors.iconColor),
            color: AppColors.surfaceDark,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
              side: const BorderSide(color: AppColors.borderColor, width: 1),
            ),
            offset: const Offset(0, 50),
            itemBuilder:
                (context) => [
                  _buildPopupMenuItem(
                    value: 'search',
                    icon: Icons.search,
                    label: 'Search',
                  ),
                  _buildPopupMenuItem(
                    value: 'pin',
                    icon: Icons.push_pin_outlined,
                    label: 'Pin',
                  ),
                  _buildPopupMenuItem(
                    value: 'meeting',
                    icon: Icons.video_call_outlined,
                    label: 'Schedule meeting',
                  ),
                  _buildPopupMenuItem(
                    value: 'mute',
                    icon: Icons.notifications_off_outlined,
                    label: 'Mute',
                  ),
                  _buildPopupMenuItem(
                    value: 'background',
                    icon: Icons.image_outlined,
                    label: 'Chat background',
                  ),
                  const PopupMenuDivider(height: 1),
                  PopupMenuItem<String>(
                    value: 'clear',
                    height: 48,
                    child: Row(
                      children: [
                        const Icon(
                          Icons.delete_outline,
                          color: AppColors.error,
                          size: 20,
                        ),
                        const SizedBox(width: 12),
                        Text(
                          'Clear chat',
                          style: AppTypography.bodyMedium.copyWith(
                            color: AppColors.error,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
            onSelected: (value) {
              _handleMenuAction(value);
            },
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
                      style: TextStyle(color: AppColors.textSecondary),
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
                    final showAvatar =
                        index == state.messages.length - 1 ||
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

  PopupMenuItem<String> _buildPopupMenuItem({
    required String value,
    required IconData icon,
    required String label,
  }) {
    return PopupMenuItem<String>(
      value: value,
      height: 48,
      child: Row(
        children: [
          Icon(icon, color: AppColors.iconColor, size: 20),
          const SizedBox(width: 12),
          Text(
            label,
            style: AppTypography.bodyMedium.copyWith(
              color: AppColors.textPrimary,
            ),
          ),
        ],
      ),
    );
  }

  // ✅ ADD THIS METHOD - Handle menu actions
  void _handleMenuAction(String action) {
    switch (action) {
      case 'search':
        _showSearchDialog();
        break;
      case 'pin':
        _togglePinConversation();
        break;
      case 'meeting':
        _scheduleMeeting();
        break;
      case 'mute':
        _toggleMuteConversation();
        break;
      case 'background':
        _showBackgroundSelector();
        break;
      case 'clear':
        _clearChat();
        break;
    }
  }

  void _showSearchDialog() {
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            backgroundColor: AppColors.surfaceDark,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            title: Text(
              'Search Messages',
              style: AppTypography.titleMedium.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            content: TextField(
              autofocus: true,
              style: AppTypography.bodyMedium,
              decoration: InputDecoration(
                hintText: 'Search in conversation...',
                hintStyle: AppTypography.bodyMedium.copyWith(
                  color: AppColors.textTertiary,
                ),
                prefixIcon: const Icon(
                  Icons.search,
                  color: AppColors.iconColor,
                ),
                filled: true,
                fillColor: AppColors.backgroundDark,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(
                    color: AppColors.borderColor,
                    width: 1,
                  ),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(
                    color: AppColors.borderColor,
                    width: 1,
                  ),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(
                    color: AppColors.primaryGreen,
                    width: 1,
                  ),
                ),
              ),
              onChanged: (query) {
                // TODO: Implement search logic
                print('Searching for: $query');
              },
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text(
                  'Cancel',
                  style: TextStyle(color: AppColors.textSecondary),
                ),
              ),
            ],
          ),
    );
  }

  void _togglePinConversation() {
    // TODO: Implement pin logic with backend
    final isPinned = !widget.conversation.isPinned;

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          isPinned ? 'Conversation pinned' : 'Conversation unpinned',
        ),
        backgroundColor: AppColors.success,
        duration: const Duration(seconds: 2),
      ),
    );

    // Update conversation state
    // context.read<ChatBloc>().add(ChatConversationPinToggled(widget.conversation.id));
  }

  void _toggleMuteConversation() {
    showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.surfaceDark,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const SizedBox(height: 12),
              Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: AppColors.borderColor,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              const SizedBox(height: 20),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Text(
                  'Mute notifications',
                  style: AppTypography.titleLarge.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(height: 20),
              ListTile(
                leading: const Icon(
                  Icons.access_time,
                  color: AppColors.iconColor,
                ),
                title: const Text('For 1 hour'),
                onTap: () {
                  Navigator.pop(context);
                  _muteFor(const Duration(hours: 1));
                },
              ),
              ListTile(
                leading: const Icon(
                  Icons.access_time,
                  color: AppColors.iconColor,
                ),
                title: const Text('For 8 hours'),
                onTap: () {
                  Navigator.pop(context);
                  _muteFor(const Duration(hours: 8));
                },
              ),
              ListTile(
                leading: const Icon(
                  Icons.access_time,
                  color: AppColors.iconColor,
                ),
                title: const Text('For 24 hours'),
                onTap: () {
                  Navigator.pop(context);
                  _muteFor(const Duration(hours: 24));
                },
              ),
              ListTile(
                leading: const Icon(
                  Icons.notifications_off,
                  color: AppColors.iconColor,
                ),
                title: const Text('Until I turn it back on'),
                onTap: () {
                  Navigator.pop(context);
                  _muteFor(null); // Mute indefinitely
                },
              ),
              const SizedBox(height: 20),
            ],
          ),
        );
      },
    );
  }

  void _muteFor(Duration? duration) {
    // TODO: Implement mute logic with backend
    final message =
        duration != null
            ? 'Muted for ${duration.inHours} hours'
            : 'Muted until you unmute';

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: AppColors.success,
        duration: const Duration(seconds: 2),
      ),
    );

    // Update conversation state
    // context.read<ChatBloc>().add(ChatConversationMuted(widget.conversation.id, duration));
  }

  void _showBackgroundSelector() {
    showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.surfaceDark,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const SizedBox(height: 12),
              Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: AppColors.borderColor,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              const SizedBox(height: 20),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Text(
                  'Chat Background',
                  style: AppTypography.titleLarge.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(height: 20),
              ListTile(
                leading: Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: AppColors.backgroundDark,
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                title: const Text('Default (Dark)'),
                onTap: () {
                  Navigator.pop(context);
                  _setBackground('default');
                },
              ),
              ListTile(
                leading: Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        AppColors.primaryGreen.withOpacity(0.3),
                        AppColors.primaryBlue.withOpacity(0.3),
                      ],
                    ),
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                title: const Text('Gradient'),
                onTap: () {
                  Navigator.pop(context);
                  _setBackground('gradient');
                },
              ),
              ListTile(
                leading: Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: AppColors.primaryGreen.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Icon(
                    Icons.wallpaper,
                    color: AppColors.primaryGreen,
                    size: 20,
                  ),
                ),
                title: const Text('Choose from gallery'),
                onTap: () {
                  Navigator.pop(context);
                  _pickBackgroundImage();
                },
              ),
              const SizedBox(height: 20),
            ],
          ),
        );
      },
    );
  }

  void _setBackground(String type) {
    // TODO: Implement background change
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Background set to $type'),
        backgroundColor: AppColors.success,
        duration: const Duration(seconds: 2),
      ),
    );
  }

  void _pickBackgroundImage() async {
    // TODO: Implement image picker
    // final ImagePicker picker = ImagePicker();
    // final XFile? image = await picker.pickImage(source: ImageSource.gallery);

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Background image picker coming soon!'),
        backgroundColor: AppColors.warning,
      ),
    );
  }

  void _scheduleMeeting() {
    showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.surfaceDark,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom,
          ),
          child: SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Handle bar
                  Center(
                    child: Container(
                      width: 40,
                      height: 4,
                      decoration: BoxDecoration(
                        color: AppColors.borderColor,
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),

                  // Title
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          gradient: AppColors.logoGradient,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: const Icon(
                          Icons.video_call,
                          color: Colors.white,
                          size: 20,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Text(
                        'Schedule Meeting',
                        style: AppTypography.titleLarge.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 24),

                  // Meeting Title
                  Text(
                    'Meeting Title',
                    style: AppTypography.bodyMedium.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 8),
                  TextField(
                    style: AppTypography.bodyMedium,
                    decoration: InputDecoration(
                      hintText: 'Enter meeting title',
                      hintStyle: AppTypography.bodyMedium.copyWith(
                        color: AppColors.textTertiary,
                      ),
                      filled: true,
                      fillColor: AppColors.backgroundDark,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: const BorderSide(
                          color: AppColors.borderColor,
                          width: 1,
                        ),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: const BorderSide(
                          color: AppColors.borderColor,
                          width: 1,
                        ),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: const BorderSide(
                          color: AppColors.primaryGreen,
                          width: 1,
                        ),
                      ),
                      contentPadding: const EdgeInsets.all(16),
                    ),
                  ),

                  const SizedBox(height: 20),

                  // Date & Time
                  Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Date',
                              style: AppTypography.bodyMedium.copyWith(
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            const SizedBox(height: 8),
                            GestureDetector(
                              onTap: () async {
                                final date = await showDatePicker(
                                  context: context,
                                  initialDate: DateTime.now(),
                                  firstDate: DateTime.now(),
                                  lastDate: DateTime.now().add(
                                    const Duration(days: 365),
                                  ),
                                  builder: (context, child) {
                                    return Theme(
                                      data: ThemeData.dark().copyWith(
                                        colorScheme: const ColorScheme.dark(
                                          primary: AppColors.primaryGreen,
                                          surface: AppColors.surfaceDark,
                                        ),
                                      ),
                                      child: child!,
                                    );
                                  },
                                );
                                // TODO: Store selected date
                              },
                              child: Container(
                                padding: const EdgeInsets.all(16),
                                decoration: BoxDecoration(
                                  color: AppColors.backgroundDark,
                                  borderRadius: BorderRadius.circular(12),
                                  border: Border.all(
                                    color: AppColors.borderColor,
                                    width: 1,
                                  ),
                                ),
                                child: Row(
                                  children: [
                                    const Icon(
                                      Icons.calendar_today,
                                      color: AppColors.iconColor,
                                      size: 18,
                                    ),
                                    const SizedBox(width: 8),
                                    Text(
                                      'Select date',
                                      style: AppTypography.bodyMedium.copyWith(
                                        color: AppColors.textSecondary,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Time',
                              style: AppTypography.bodyMedium.copyWith(
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            const SizedBox(height: 8),
                            GestureDetector(
                              onTap: () async {
                                final time = await showTimePicker(
                                  context: context,
                                  initialTime: TimeOfDay.now(),
                                  builder: (context, child) {
                                    return Theme(
                                      data: ThemeData.dark().copyWith(
                                        colorScheme: const ColorScheme.dark(
                                          primary: AppColors.primaryGreen,
                                          surface: AppColors.surfaceDark,
                                        ),
                                      ),
                                      child: child!,
                                    );
                                  },
                                );
                                // TODO: Store selected time
                              },
                              child: Container(
                                padding: const EdgeInsets.all(16),
                                decoration: BoxDecoration(
                                  color: AppColors.backgroundDark,
                                  borderRadius: BorderRadius.circular(12),
                                  border: Border.all(
                                    color: AppColors.borderColor,
                                    width: 1,
                                  ),
                                ),
                                child: Row(
                                  children: [
                                    const Icon(
                                      Icons.access_time,
                                      color: AppColors.iconColor,
                                      size: 18,
                                    ),
                                    const SizedBox(width: 8),
                                    Text(
                                      'Select time',
                                      style: AppTypography.bodyMedium.copyWith(
                                        color: AppColors.textSecondary,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 24),

                  // Schedule Button
                  SizedBox(
                    width: double.infinity,
                    height: 52,
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.pop(context);
                        // TODO: Send meeting invite message
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Meeting scheduled successfully!'),
                            backgroundColor: AppColors.success,
                          ),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primaryGreen,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        elevation: 0,
                      ),
                      child: Text(
                        'Schedule Meeting',
                        style: AppTypography.bodyLarge.copyWith(
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  void _clearChat() {
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            backgroundColor: AppColors.surfaceDark,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            title: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: AppColors.error.withOpacity(0.15),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Icon(
                    Icons.delete_outline,
                    color: AppColors.error,
                    size: 20,
                  ),
                ),
                const SizedBox(width: 12),
                Text(
                  'Clear Chat',
                  style: AppTypography.titleMedium.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            content: Text(
              'Are you sure you want to clear all messages in this conversation? This action cannot be undone.',
              style: AppTypography.bodyMedium.copyWith(
                color: AppColors.textSecondary,
              ),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text(
                  'Cancel',
                  style: TextStyle(color: AppColors.textSecondary),
                ),
              ),
              TextButton(
                onPressed: () {
                  Navigator.pop(context);

                  // TODO: Implement clear chat with backend
                  // context.read<ChatBloc>().add(ChatMessagesCleared(widget.conversation.id));

                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Chat cleared successfully'),
                      backgroundColor: AppColors.success,
                      duration: Duration(seconds: 2),
                    ),
                  );
                },
                child: const Text(
                  'Clear',
                  style: TextStyle(
                    color: AppColors.error,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
    );
  }
}
