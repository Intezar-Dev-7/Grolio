// features/groups/presentation/bloc/group_details_state.dart

part of 'group_details_bloc.dart';

enum GroupDetailsStatus {
  initial,
  loading,
  loaded,
  error,
}

class GroupDetailsState extends Equatable {
  final GroupDetailsStatus status;
  final GroupEntity? group;
  final String? errorMessage;

  const GroupDetailsState({
    required this.status,
    this.group,
    this.errorMessage,
  });

  factory GroupDetailsState.initial() {
    return const GroupDetailsState(
      status: GroupDetailsStatus.initial,
    );
  }

  GroupDetailsState copyWith({
    GroupDetailsStatus? status,
    GroupEntity? group,
    String? errorMessage,
  }) {
    return GroupDetailsState(
      status: status ?? this.status,
      group: group ?? this.group,
      errorMessage: errorMessage,
    );
  }

  @override
  List<Object?> get props => [status, group, errorMessage];
}
