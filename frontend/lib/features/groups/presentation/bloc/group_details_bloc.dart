// features/groups/presentation/bloc/group_details_bloc.dart

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import '../../data/datasources/group_remote_datasource.dart';
import '../../domain/entities/group_entity.dart';

part 'group_details_event.dart';
part 'group_details_state.dart';

class GroupDetailsBloc extends Bloc<GroupDetailsEvent, GroupDetailsState> {
  final GroupRemoteDataSource remoteDataSource;

  GroupDetailsBloc({required this.remoteDataSource})
      : super(GroupDetailsState.initial()) {
    on<GroupDetailsLoadRequested>(_onLoadRequested);
    on<GroupDetailsExitRequested>(_onExitRequested);
    on<GroupDetailsMemberAdded>(_onMemberAdded);
    on<GroupDetailsMemberRemoved>(_onMemberRemoved);
    on<GroupDetailsAdminPromoted>(_onAdminPromoted);
    on<GroupDetailsAdminDemoted>(_onAdminDemoted);
    on<GroupDetailsReportRequested>(_onReportRequested);
  }

  Future<void> _onLoadRequested(
      GroupDetailsLoadRequested event,
      Emitter<GroupDetailsState> emit,
      ) async {
    emit(state.copyWith(status: GroupDetailsStatus.loading));

    try {
      final group = await remoteDataSource.getGroupDetails(event.groupId);

      emit(state.copyWith(
        status: GroupDetailsStatus.loaded,
        group: group,
      ));
    } catch (e) {
      emit(state.copyWith(
        status: GroupDetailsStatus.error,
        errorMessage: 'Failed to load group details',
      ));
    }
  }

  Future<void> _onExitRequested(
      GroupDetailsExitRequested event,
      Emitter<GroupDetailsState> emit,
      ) async {
    if (state.group == null) return;

    try {
      await remoteDataSource.exitGroup(state.group!.id);
    } catch (e) {
      emit(state.copyWith(
        status: GroupDetailsStatus.error,
        errorMessage: 'Failed to exit group',
      ));
    }
  }

  Future<void> _onMemberAdded(
      GroupDetailsMemberAdded event,
      Emitter<GroupDetailsState> emit,
      ) async {
    if (state.group == null) return;

    try {
      await remoteDataSource.addMember(state.group!.id, event.userId);

      // Reload group details
      final group = await remoteDataSource.getGroupDetails(state.group!.id);
      emit(state.copyWith(
        status: GroupDetailsStatus.loaded,
        group: group,
      ));
    } catch (e) {
      emit(state.copyWith(
        status: GroupDetailsStatus.error,
        errorMessage: 'Failed to add member',
      ));
    }
  }

  Future<void> _onMemberRemoved(
      GroupDetailsMemberRemoved event,
      Emitter<GroupDetailsState> emit,
      ) async {
    if (state.group == null) return;

    try {
      await remoteDataSource.removeMember(state.group!.id, event.memberId);

      // Reload group details
      final group = await remoteDataSource.getGroupDetails(state.group!.id);
      emit(state.copyWith(
        status: GroupDetailsStatus.loaded,
        group: group,
      ));
    } catch (e) {
      emit(state.copyWith(
        status: GroupDetailsStatus.error,
        errorMessage: 'Failed to remove member',
      ));
    }
  }

  Future<void> _onAdminPromoted(
      GroupDetailsAdminPromoted event,
      Emitter<GroupDetailsState> emit,
      ) async {
    if (state.group == null) return;

    try {
      await remoteDataSource.promoteToAdmin(state.group!.id, event.memberId);

      // Reload group details
      final group = await remoteDataSource.getGroupDetails(state.group!.id);
      emit(state.copyWith(
        status: GroupDetailsStatus.loaded,
        group: group,
      ));
    } catch (e) {
      emit(state.copyWith(
        status: GroupDetailsStatus.error,
        errorMessage: 'Failed to promote member',
      ));
    }
  }

  Future<void> _onAdminDemoted(
      GroupDetailsAdminDemoted event,
      Emitter<GroupDetailsState> emit,
      ) async {
    if (state.group == null) return;

    try {
      await remoteDataSource.demoteAdmin(state.group!.id, event.adminId);

      // Reload group details
      final group = await remoteDataSource.getGroupDetails(state.group!.id);
      emit(state.copyWith(
        status: GroupDetailsStatus.loaded,
        group: group,
      ));
    } catch (e) {
      emit(state.copyWith(
        status: GroupDetailsStatus.error,
        errorMessage: 'Failed to demote admin',
      ));
    }
  }

  Future<void> _onReportRequested(
      GroupDetailsReportRequested event,
      Emitter<GroupDetailsState> emit,
      ) async {
    if (state.group == null) return;

    try {
      await remoteDataSource.reportGroup(state.group!.id);
    } catch (e) {
      emit(state.copyWith(
        status: GroupDetailsStatus.error,
        errorMessage: 'Failed to report group',
      ));
    }
  }
}
