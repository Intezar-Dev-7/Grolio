// features/notifications/presentation/widgets/notification_tile.dart

import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_typography.dart';
import '../../domain/entities/notification_entity.dart';

class NotificationTile extends StatelessWidget {
  final NotificationEntity notification;
  final VoidCallback onTap;
  final VoidCallback onDismiss;

  const NotificationTile({
    super.key,
    required this.notification,
    required this.onTap,
    required this.onDismiss,
  });

  @override
  Widget build(BuildContext context) {
    return Dismissible(
      key: Key(notification.id),
      direction: DismissDirection.endToStart,
      background: Container(
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 20),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              AppColors.error.withOpacity(0.0),
              AppColors.error.withOpacity(0.8),
              AppColors.error,
            ],
          ),
        ),
        child: const Icon(
          Icons.delete_outline,
          color: Colors.white,
          size: 28,
        ),
      ),
      confirmDismiss: (direction) async {
        return await showDialog(
          context: context,
          builder: (context) => AlertDialog(
            backgroundColor: AppColors.surfaceDark,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            title: const Text('Delete Notification'),
            content: const Text('Are you sure you want to delete this notification?'),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context, false),
                child: Text(
                  'Cancel',
                  style: TextStyle(color: AppColors.textSecondary),
                ),
              ),
              TextButton(
                onPressed: () => Navigator.pop(context, true),
                child: Text(
                  'Delete',
                  style: TextStyle(
                    color: AppColors.error,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
        );
      },
      onDismissed: (direction) => onDismiss(),
      child: InkWell(
        onTap: onTap,
        child: Container(
          color: notification.isRead
              ? Colors.transparent
              : AppColors.primaryGreen.withOpacity(0.05),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Avatar or Icon
              _buildLeadingIcon(),
              const SizedBox(width: 12),

              // Content
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Message
                    Text(
                      notification.message,
                      style: AppTypography.bodyMedium.copyWith(
                        fontWeight: notification.isRead
                            ? FontWeight.normal
                            : FontWeight.w600,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),

                    // Time
                    Text(
                      notification.timeAgo,
                      style: AppTypography.bodySmall.copyWith(
                        color: AppColors.textSecondary,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(width: 12),

              // Post thumbnail (if exists)
              if (notification.imageUrl != null)
                ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: CachedNetworkImage(
                    imageUrl: notification.imageUrl!,
                    width: 56,
                    height: 56,
                    fit: BoxFit.cover,
                    placeholder: (context, url) => Container(
                      color: AppColors.borderColor,
                      child: const Center(
                        child: SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            valueColor: AlwaysStoppedAnimation<Color>(
                              AppColors.primaryGreen,
                            ),
                          ),
                        ),
                      ),
                    ),
                    errorWidget: (context, url, error) => Container(
                      color: AppColors.borderColor,
                      child: const Icon(
                        Icons.image,
                        color: AppColors.iconColor,
                      ),
                    ),
                  ),
                ),

              // Unread indicator
              if (!notification.isRead)
                Container(
                  margin: const EdgeInsets.only(left: 12),
                  width: 8,
                  height: 8,
                  decoration: const BoxDecoration(
                    color: AppColors.primaryGreen,
                    shape: BoxShape.circle,
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLeadingIcon() {
    if (notification.actionUserAvatar != null) {
      return CircleAvatar(
        radius: 24,
        backgroundColor: AppColors.primaryGreen.withOpacity(0.2),
        backgroundImage: CachedNetworkImageProvider(
          notification.actionUserAvatar!,
        ),
      );
    }

    IconData icon;
    Color backgroundColor;

    switch (notification.type) {
      case NotificationType.like:
        icon = Icons.favorite;
        backgroundColor = const Color(0xFFE91E63);
        break;
      case NotificationType.comment:
        icon = Icons.comment;
        backgroundColor = AppColors.primaryBlue;
        break;
      case NotificationType.follow:
        icon = Icons.person_add;
        backgroundColor = AppColors.primaryGreen;
        break;
      case NotificationType.mention:
        icon = Icons.alternate_email;
        backgroundColor = const Color(0xFF9C27B0);
        break;
      case NotificationType.reply:
        icon = Icons.reply;
        backgroundColor = const Color(0xFFFF9800);
        break;
      case NotificationType.achievement:
        icon = Icons.emoji_events;
        backgroundColor = const Color(0xFFFFD700);
        break;
      case NotificationType.groupInvite:
        icon = Icons.group_add;
        backgroundColor = AppColors.primaryGreen;
        break;
      case NotificationType.message:
        icon = Icons.message;
        backgroundColor = AppColors.primaryBlue;
        break;
    }

    return Container(
      width: 48,
      height: 48,
      decoration: BoxDecoration(
        color: backgroundColor.withOpacity(0.15),
        shape: BoxShape.circle,
      ),
      child: Icon(
        icon,
        color: backgroundColor,
        size: 24,
      ),
    );
  }
}
