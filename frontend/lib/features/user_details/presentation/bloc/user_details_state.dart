// features/user_details/presentation/bloc/user_details_state.dart

part of 'user_details_bloc.dart';

enum UserDetailsStatus {
  initial,
  loading,
  loaded,
  error,
}

class UserDetailsState extends Equatable {
  final UserDetailsStatus status;
  final UserProfileEntity? userProfile;
  final String? errorMessage;

  const UserDetailsState({
    required this.status,
    this.userProfile,
    this.errorMessage,
  });

  factory UserDetailsState.initial() {
    return const UserDetailsState(
      status: UserDetailsStatus.initial,
    );
  }

  UserDetailsState copyWith({
    UserDetailsStatus? status,
    UserProfileEntity? userProfile,
    String? errorMessage,
  }) {
    return UserDetailsState(
      status: status ?? this.status,
      userProfile: userProfile ?? this.userProfile,
      errorMessage: errorMessage,
    );
  }

  @override
  List<Object?> get props => [status, userProfile, errorMessage];
}
