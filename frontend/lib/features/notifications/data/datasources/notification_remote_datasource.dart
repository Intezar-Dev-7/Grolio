// features/notifications/data/datasources/notification_remote_datasource.dart

import 'package:dio/dio.dart';
import '../../../../core/error/exceptions.dart';
import '../../../../core/network/dio_client.dart';
import '../../domain/entities/notification_entity.dart';

abstract class NotificationRemoteDataSource {
  Future<List<NotificationEntity>> getNotifications({int page = 1, int limit = 20});
  Future<int> getUnreadCount();
  Future<void> markAsRead(String notificationId);
  Future<void> markAllAsRead();
  Future<void> deleteNotification(String notificationId);
  Future<void> clearAllNotifications();
}

class NotificationRemoteDataSourceImpl implements NotificationRemoteDataSource {
  final DioClient dioClient;

  NotificationRemoteDataSourceImpl({required this.dioClient});

  @override
  Future<List<NotificationEntity>> getNotifications({
    int page = 1,
    int limit = 20,
  }) async {
    try {
      // Simulate network delay
      await Future.delayed(const Duration(seconds: 1));

      // Return mock data for now
      return _getMockNotifications();
    } catch (e) {
      if (e is DioException) {
        throw ServerException(
          message: e.response?.data['message'] ?? 'Network error',
        );
      }
      throw ServerException(message: e.toString());
    }
  }

  @override
  Future<int> getUnreadCount() async {
    await Future.delayed(const Duration(milliseconds: 500));
    return 8; // Mock unread count
  }

  @override
  Future<void> markAsRead(String notificationId) async {
    await Future.delayed(const Duration(milliseconds: 300));
    print('Marked notification $notificationId as read');
  }

  @override
  Future<void> markAllAsRead() async {
    await Future.delayed(const Duration(milliseconds: 500));
    print('Marked all notifications as read');
  }

  @override
  Future<void> deleteNotification(String notificationId) async {
    await Future.delayed(const Duration(milliseconds: 300));
    print('Deleted notification $notificationId');
  }

  @override
  Future<void> clearAllNotifications() async {
    await Future.delayed(const Duration(milliseconds: 500));
    print('Cleared all notifications');
  }

  // Mock data
  List<NotificationEntity> _getMockNotifications() {
    return [
      NotificationEntity(
        id: 'notif_001',
        type: NotificationType.like,
        title: 'New Like',
        message: 'Anmol Kumar liked your post',
        actionUserId: 'user_001',
        actionUserName: 'Anmol Kumar',
        actionUserAvatar: 'https://via.placeholder.com/150/FF6B6B/ffffff?text=AK',
        imageUrl: 'https://via.placeholder.com/300',
        postId: 'post_123',
        timestamp: DateTime.now().subtract(const Duration(minutes: 5)),
        isRead: false,
      ),
      NotificationEntity(
        id: 'notif_002',
        type: NotificationType.comment,
        title: 'New Comment',
        message: 'Priya Sharma commented: "Amazing work! 🚀"',
        actionUserId: 'user_003',
        actionUserName: 'Priya Sharma',
        actionUserAvatar: 'https://via.placeholder.com/150/95E1D3/ffffff?text=PS',
        imageUrl: 'https://via.placeholder.com/300',
        postId: 'post_124',
        commentId: 'comment_456',
        timestamp: DateTime.now().subtract(const Duration(minutes: 15)),
        isRead: false,
      ),
      NotificationEntity(
        id: 'notif_003',
        type: NotificationType.follow,
        title: 'New Follower',
        message: 'Rahul Patel started following you',
        actionUserId: 'user_004',
        actionUserName: 'Rahul Patel',
        actionUserAvatar: 'https://via.placeholder.com/150/F38181/ffffff?text=RP',
        timestamp: DateTime.now().subtract(const Duration(hours: 1)),
        isRead: false,
      ),
      NotificationEntity(
        id: 'notif_004',
        type: NotificationType.mention,
        title: 'Mentioned You',
        message: 'Neha Gupta mentioned you in a comment',
        actionUserId: 'user_005',
        actionUserName: 'Neha Gupta',
        actionUserAvatar: 'https://via.placeholder.com/150/AA96DA/ffffff?text=NG',
        postId: 'post_125',
        timestamp: DateTime.now().subtract(const Duration(hours: 2)),
        isRead: true,
      ),
      NotificationEntity(
        id: 'notif_005',
        type: NotificationType.reply,
        title: 'Reply to Comment',
        message: 'Vikram Singh replied to your comment',
        actionUserId: 'user_008',
        actionUserName: 'Vikram Singh',
        actionUserAvatar: 'https://via.placeholder.com/150/FF9999/ffffff?text=VS',
        postId: 'post_126',
        commentId: 'comment_789',
        timestamp: DateTime.now().subtract(const Duration(hours: 3)),
        isRead: true,
      ),
      NotificationEntity(
        id: 'notif_006',
        type: NotificationType.achievement,
        title: 'Achievement Unlocked! 🎉',
        message: 'You earned the "Code Warrior" badge for 100 contributions',
        imageUrl: 'https://via.placeholder.com/150/FFD700/ffffff?text=🏆',
        timestamp: DateTime.now().subtract(const Duration(hours: 5)),
        isRead: false,
      ),
      NotificationEntity(
        id: 'notif_007',
        type: NotificationType.groupInvite,
        title: 'Group Invitation',
        message: 'Hemant Singh invited you to join "Flutter Developers"',
        actionUserId: 'user_002',
        actionUserName: 'Hemant Singh',
        actionUserAvatar: 'https://via.placeholder.com/150/4ECDC4/ffffff?text=HS',
        timestamp: DateTime.now().subtract(const Duration(days: 1)),
        isRead: true,
      ),
      NotificationEntity(
        id: 'notif_008',
        type: NotificationType.like,
        title: 'Multiple Likes',
        message: 'Divya Malhotra and 5 others liked your post',
        actionUserId: 'user_007',
        actionUserName: 'Divya Malhotra',
        actionUserAvatar: 'https://via.placeholder.com/150/A8D8EA/ffffff?text=DM',
        imageUrl: 'https://via.placeholder.com/300',
        postId: 'post_127',
        timestamp: DateTime.now().subtract(const Duration(days: 1)),
        isRead: true,
      ),
    ];
  }
}
