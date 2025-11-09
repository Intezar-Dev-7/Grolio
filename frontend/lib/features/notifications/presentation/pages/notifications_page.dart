// features/notifications/presentation/pages/notifications_page.dart

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:frontend/core/constants/app_assets.dart';
import 'package:frontend/features/notifications/domain/entities/notification_entity.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_typography.dart';
import '../bloc/notification_bloc.dart';
import '../widgets/notification_tile.dart';
import '../widgets/empty_notifications.dart';

class NotificationsPage extends StatefulWidget {
  const NotificationsPage({super.key});

  @override
  State<NotificationsPage> createState() => _NotificationsPageState();
}

class _NotificationsPageState extends State<NotificationsPage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    context.read<NotificationBloc>().add(const NotificationLoadRequested());
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundDark,
      body: SafeArea(
        child: Column(
          children: [
            // Custom App Bar
            _buildAppBar(context),

            // Tab Bar
            Container(
              decoration: const BoxDecoration(
                color: AppColors.surfaceDark,
                border: Border(
                  bottom: BorderSide(
                    color: AppColors.borderColor,
                    width: 1,
                  ),
                ),
              ),
              child: TabBar(
                controller: _tabController,
                indicatorColor: AppColors.primaryGreen,
                indicatorWeight: 3,
                labelColor: AppColors.primaryGreen,
                unselectedLabelColor: AppColors.textSecondary,
                labelStyle: AppTypography.bodyMedium.copyWith(
                  fontWeight: FontWeight.w600,
                ),
                tabs: const [
                  Tab(text: 'All'),
                  Tab(text: 'Unread'),
                ],
              ),
            ),

            // Tab Bar View
            Expanded(
              child: BlocBuilder<NotificationBloc, NotificationState>(
                builder: (context, state) {
                  if (state.status == NotificationStatus.loading) {
                    return const Center(
                      child: CircularProgressIndicator(
                        valueColor: AlwaysStoppedAnimation<Color>(
                          AppColors.primaryGreen,
                        ),
                      ),
                    );
                  }

                  if (state.status == NotificationStatus.error) {
                    return Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.error_outline,
                            size: 64,
                            color: AppColors.error.withOpacity(0.5),
                          ),
                          const SizedBox(height: 16),
                          Text(
                            state.errorMessage ?? 'Failed to load notifications',
                            style: AppTypography.bodyMedium.copyWith(
                              color: AppColors.textSecondary,
                            ),
                          ),
                          const SizedBox(height: 16),
                          ElevatedButton(
                            onPressed: () {
                              context.read<NotificationBloc>().add(
                                const NotificationLoadRequested(),
                              );
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors.primaryGreen,
                            ),
                            child: const Text('Retry'),
                          ),
                        ],
                      ),
                    );
                  }

                  if (state.notifications.isEmpty) {
                    return const EmptyNotifications();
                  }

                  return TabBarView(
                    controller: _tabController,
                    children: [
                      // All Notifications Tab
                      _buildNotificationsList(state.notifications),

                      // Unread Notifications Tab
                      state.unreadNotifications.isEmpty
                          ? const EmptyNotifications(
                        message: 'No unread notifications',
                      )
                          : _buildNotificationsList(state.unreadNotifications),
                    ],
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAppBar(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: const BoxDecoration(
        color: AppColors.surfaceDark,
        border: Border(
          bottom: BorderSide(
            color: AppColors.borderColor,
            width: 1,
          ),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              InkWell(
                onTap: (){
                  Navigator.pop(context);
                },
                child: const Icon(Icons.arrow_back_ios_rounded),
              ),
              const SizedBox(width: 12),
              Text(
                'Notifications',
                style: AppTypography.headlineSmall.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          Row(
            children: [
              // Mark all as read
              BlocBuilder<NotificationBloc, NotificationState>(
                builder: (context, state) {
                  if (state.unreadCount > 0) {
                    return IconButton(
                      icon: const Icon(
                        Icons.done_all,
                        color: AppColors.iconColor,
                      ),
                      onPressed: () {
                        context.read<NotificationBloc>().add(
                          const NotificationAllMarkedAsRead(),
                        );
                      },
                      tooltip: 'Mark all as read',
                    );
                  }
                  return const SizedBox.shrink();
                },
              ),
              // More options
              PopupMenuButton<String>(
                icon: const Icon(
                  Icons.more_vert,
                  color: AppColors.iconColor,
                ),
                color: AppColors.surfaceDark,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                itemBuilder: (context) => [
                  const PopupMenuItem(
                    value: 'settings',
                    child: Row(
                      children: [
                        Icon(Icons.settings, color: AppColors.iconColor),
                        SizedBox(width: 12),
                        Text('Notification settings'),
                      ],
                    ),
                  ),
                  const PopupMenuItem(
                    value: 'clear',
                    child: Row(
                      children: [
                        Icon(Icons.clear_all, color: AppColors.error),
                        SizedBox(width: 12),
                        Text(
                          'Clear all',
                          style: TextStyle(color: AppColors.error),
                        ),
                      ],
                    ),
                  ),
                ],
                onSelected: (value) {
                  if (value == 'clear') {
                    _showClearAllDialog(context);
                  } else if (value == 'settings') {
                    // TODO: Navigate to notification settings
                  }
                },
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildNotificationsList(List notifications) {
    return RefreshIndicator(
      onRefresh: () async {
        context.read<NotificationBloc>().add(const NotificationRefreshed());
      },
      color: AppColors.primaryGreen,
      backgroundColor: AppColors.surfaceDark,
      child: ListView.separated(
        padding: const EdgeInsets.symmetric(vertical: 8),
        itemCount: notifications.length,
        separatorBuilder: (context, index) => Divider(
          height: 1,
          color: AppColors.borderColor.withOpacity(0.5),
        ),
        itemBuilder: (context, index) {
          final notification = notifications[index];
          return NotificationTile(
            notification: notification,
            onTap: () => _handleNotificationTap(context, notification),
            onDismiss: () {
              context.read<NotificationBloc>().add(
                NotificationDeleted(notification.id),
              );
            },
          );
        },
      ),
    );
  }

  void _handleNotificationTap(BuildContext context, notification) {
    // Mark as read
    if (!notification.isRead) {
      context.read<NotificationBloc>().add(
        NotificationMarkedAsRead(notification.id),
      );
    }

    // Handle navigation based on type
    switch (notification.type) {
      case NotificationType.like:
      case NotificationType.comment:
      case NotificationType.mention:
      case NotificationType.reply:
      // Navigate to post details
      // Navigator.push(...);
        break;
      case NotificationType.follow:
      // Navigate to user profile
      // Navigator.push(...);
        break;
      case NotificationType.groupInvite:
      // Navigate to group details
      // Navigator.push(...);
        break;
      case NotificationType.achievement:
      // Show achievement details
        break;
      default:
        break;
    }
  }

  void _showClearAllDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
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
            const Text('Clear All Notifications'),
          ],
        ),
        content: Text(
          'Are you sure you want to clear all notifications? This action cannot be undone.',
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
              context.read<NotificationBloc>().add(
                const NotificationAllCleared(),
              );
            },
            child: const Text(
              'Clear All',
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
