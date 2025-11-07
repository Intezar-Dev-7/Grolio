// features/notifications/presentation/bloc/notification_state.dart

part of 'notification_bloc.dart';

enum NotificationStatus {
  initial,
  loading,
  loaded,
  error,
}

class NotificationState extends Equatable {
  final NotificationStatus status;
  final List<NotificationEntity> notifications;
  final int unreadCount;
  final String? errorMessage;

  const NotificationState({
    required this.status,
    required this.notifications,
    required this.unreadCount,
    this.errorMessage,
  });

  factory NotificationState.initial() {
    return const NotificationState(
      status: NotificationStatus.initial,
      notifications: [],
      unreadCount: 0,
    );
  }

  NotificationState copyWith({
    NotificationStatus? status,
    List<NotificationEntity>? notifications,
    int? unreadCount,
    String? errorMessage,
  }) {
    return NotificationState(
      status: status ?? this.status,
      notifications: notifications ?? this.notifications,
      unreadCount: unreadCount ?? this.unreadCount,
      errorMessage: errorMessage,
    );
  }

  List<NotificationEntity> get unreadNotifications =>
      notifications.where((n) => !n.isRead).toList();

  List<NotificationEntity> get readNotifications =>
      notifications.where((n) => n.isRead).toList();

  @override
  List<Object?> get props => [status, notifications, unreadCount, errorMessage];
}
