// features/profile/presentation/bloc/profile_event.dart

part of 'profile_bloc.dart';

abstract class ProfileEvent extends Equatable {
  const ProfileEvent();

  @override
  List<Object?> get props => [];
}

class ProfileLoadRequested extends ProfileEvent {
  final String? userId;

  const ProfileLoadRequested({this.userId});

  @override
  List<Object?> get props => [userId];
}

class ProfileFollowToggled extends ProfileEvent {
  final String userId;

  const ProfileFollowToggled(this.userId);

  @override
  List<Object?> get props => [userId];
}
