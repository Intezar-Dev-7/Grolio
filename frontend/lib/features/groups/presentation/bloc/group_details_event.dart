// features/groups/presentation/bloc/group_details_event.dart

part of 'group_details_bloc.dart';

abstract class GroupDetailsEvent extends Equatable {
  const GroupDetailsEvent();

  @override
  List<Object?> get props => [];
}

class GroupDetailsLoadRequested extends GroupDetailsEvent {
  final String groupId;

  const GroupDetailsLoadRequested(this.groupId);

  @override
  List<Object?> get props => [groupId];
}

class GroupDetailsExitRequested extends GroupDetailsEvent {
  const GroupDetailsExitRequested();
}

class GroupDetailsMemberAdded extends GroupDetailsEvent {
  final String userId;

  const GroupDetailsMemberAdded(this.userId);

  @override
  List<Object?> get props => [userId];
}

class GroupDetailsMemberRemoved extends GroupDetailsEvent {
  final String memberId;

  const GroupDetailsMemberRemoved(this.memberId);

  @override
  List<Object?> get props => [memberId];
}

class GroupDetailsAdminPromoted extends GroupDetailsEvent {
  final String memberId;

  const GroupDetailsAdminPromoted(this.memberId);

  @override
  List<Object?> get props => [memberId];
}

class GroupDetailsAdminDemoted extends GroupDetailsEvent {
  final String adminId;

  const GroupDetailsAdminDemoted(this.adminId);

  @override
  List<Object?> get props => [adminId];
}

class GroupDetailsReportRequested extends GroupDetailsEvent {
  const GroupDetailsReportRequested();
}
