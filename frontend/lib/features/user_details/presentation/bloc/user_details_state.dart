// features/user_details/presentation/bloc/user_details_state.dart

part of 'user_details_bloc.dart';

enum UserDetailsStatus {
  initial,
  loading,
  success,
  error,
}

class UserDetailsState extends Equatable {
  final UserDetailsStatus status;
  final UserDetailsEntity? userDetails;
  final String? errorMessage;

  const UserDetailsState({
    required this.status,
    this.userDetails,
    this.errorMessage,
  });

  factory UserDetailsState.initial() {
    return const UserDetailsState(
      status: UserDetailsStatus.initial,
    );
  }

  UserDetailsState copyWith({
    UserDetailsStatus? status,
    UserDetailsEntity? userDetails,
    String? errorMessage,
  }) {
    return UserDetailsState(
      status: status ?? this.status,
      userDetails: userDetails ?? this.userDetails,
      errorMessage: errorMessage,
    );
  }

  @override
  List<Object?> get props => [status, userDetails, errorMessage];
}
