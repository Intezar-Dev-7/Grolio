// features/notifications/presentation/bloc/notification_bloc.dart

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import '../../data/datasources/notification_remote_datasource.dart';
import '../../domain/entities/notification_entity.dart';

part 'notification_event.dart';
part 'notification_state.dart';

class NotificationBloc extends Bloc<NotificationEvent, NotificationState> {
  final NotificationRemoteDataSource remoteDataSource;

  NotificationBloc({required this.remoteDataSource})
      : super(NotificationState.initial()) {
    on<NotificationLoadRequested>(_onLoadRequested);
    on<NotificationRefreshed>(_onRefreshed);
    on<NotificationMarkedAsRead>(_onMarkedAsRead);
    on<NotificationAllMarkedAsRead>(_onAllMarkedAsRead);
    on<NotificationDeleted>(_onDeleted);
    on<NotificationAllCleared>(_onAllCleared);
  }

  Future<void> _onLoadRequested(
      NotificationLoadRequested event,
      Emitter<NotificationState> emit,
      ) async {
    emit(state.copyWith(status: NotificationStatus.loading));

    try {
      final notifications = await remoteDataSource.getNotifications();
      final unreadCount = await remoteDataSource.getUnreadCount();

      emit(state.copyWith(
        status: NotificationStatus.loaded,
        notifications: notifications,
        unreadCount: unreadCount,
      ));
    } catch (e) {
      emit(state.copyWith(
        status: NotificationStatus.error,
        errorMessage: 'Failed to load notifications',
      ));
    }
  }

  Future<void> _onRefreshed(
      NotificationRefreshed event,
      Emitter<NotificationState> emit,
      ) async {
    try {
      final notifications = await remoteDataSource.getNotifications();
      final unreadCount = await remoteDataSource.getUnreadCount();

      emit(state.copyWith(
        status: NotificationStatus.loaded,
        notifications: notifications,
        unreadCount: unreadCount,
      ));
    } catch (e) {
      emit(state.copyWith(
        status: NotificationStatus.error,
        errorMessage: 'Failed to refresh notifications',
      ));
    }
  }

  Future<void> _onMarkedAsRead(
      NotificationMarkedAsRead event,
      Emitter<NotificationState> emit,
      ) async {
    try {
      await remoteDataSource.markAsRead(event.notificationId);

      final updatedNotifications = state.notifications.map((n) {
        if (n.id == event.notificationId) {
          return NotificationEntity(
            id: n.id,
            type: n.type,
            title: n.title,
            message: n.message,
            imageUrl: n.imageUrl,
            actionUserId: n.actionUserId,
            actionUserName: n.actionUserName,
            actionUserAvatar: n.actionUserAvatar,
            postId: n.postId,
            commentId: n.commentId,
            timestamp: n.timestamp,
            isRead: true,
          );
        }
        return n;
      }).toList();

      emit(state.copyWith(
        notifications: updatedNotifications,
        unreadCount: state.unreadCount - 1,
      ));
    } catch (e) {
      // Handle error silently
    }
  }

  Future<void> _onAllMarkedAsRead(
      NotificationAllMarkedAsRead event,
      Emitter<NotificationState> emit,
      ) async {
    try {
      await remoteDataSource.markAllAsRead();

      final updatedNotifications = state.notifications.map((n) {
        return NotificationEntity(
          id: n.id,
          type: n.type,
          title: n.title,
          message: n.message,
          imageUrl: n.imageUrl,
          actionUserId: n.actionUserId,
          actionUserName: n.actionUserName,
          actionUserAvatar: n.actionUserAvatar,
          postId: n.postId,
          commentId: n.commentId,
          timestamp: n.timestamp,
          isRead: true,
        );
      }).toList();

      emit(state.copyWith(
        notifications: updatedNotifications,
        unreadCount: 0,
      ));
    } catch (e) {
      // Handle error
    }
  }

  Future<void> _onDeleted(
      NotificationDeleted event,
      Emitter<NotificationState> emit,
      ) async {
    try {
      await remoteDataSource.deleteNotification(event.notificationId);

      final updatedNotifications = state.notifications
          .where((n) => n.id != event.notificationId)
          .toList();

      emit(state.copyWith(notifications: updatedNotifications));
    } catch (e) {
      // Handle error
    }
  }

  Future<void> _onAllCleared(
      NotificationAllCleared event,
      Emitter<NotificationState> emit,
      ) async {
    try {
      await remoteDataSource.clearAllNotifications();

      emit(state.copyWith(
        notifications: [],
        unreadCount: 0,
      ));
    } catch (e) {
      // Handle error
    }
  }
}
