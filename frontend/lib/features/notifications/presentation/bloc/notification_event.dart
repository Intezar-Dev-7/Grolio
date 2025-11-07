// features/notifications/presentation/bloc/notification_event.dart

part of 'notification_bloc.dart';

abstract class NotificationEvent extends Equatable {
  const NotificationEvent();

  @override
  List<Object?> get props => [];
}

class NotificationLoadRequested extends NotificationEvent {
  const NotificationLoadRequested();
}

class NotificationRefreshed extends NotificationEvent {
  const NotificationRefreshed();
}

class NotificationMarkedAsRead extends NotificationEvent {
  final String notificationId;

  const NotificationMarkedAsRead(this.notificationId);

  @override
  List<Object?> get props => [notificationId];
}

class NotificationAllMarkedAsRead extends NotificationEvent {
  const NotificationAllMarkedAsRead();
}

class NotificationDeleted extends NotificationEvent {
  final String notificationId;

  const NotificationDeleted(this.notificationId);

  @override
  List<Object?> get props => [notificationId];
}

class NotificationAllCleared extends NotificationEvent {
  const NotificationAllCleared();
}
