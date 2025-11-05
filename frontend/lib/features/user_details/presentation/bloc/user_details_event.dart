// features/user_details/presentation/bloc/user_details_event.dart

part of 'user_details_bloc.dart';

abstract class UserDetailsEvent extends Equatable {
  const UserDetailsEvent();

  @override
  List<Object?> get props => [];
}

class UserDetailsLoadRequested extends UserDetailsEvent {
  final String userId;

  const UserDetailsLoadRequested(this.userId);

  @override
  List<Object?> get props => [userId];
}

class UserDetailsFollowToggled extends UserDetailsEvent {
  final String userId;
  const UserDetailsFollowToggled(this.userId);
}

class UserDetailsBlockRequested extends UserDetailsEvent {
  const UserDetailsBlockRequested();
}

class UserDetailsReportRequested extends UserDetailsEvent {
  const UserDetailsReportRequested();
}

class UserDetailsRefreshed extends UserDetailsEvent {
  const UserDetailsRefreshed();
}
