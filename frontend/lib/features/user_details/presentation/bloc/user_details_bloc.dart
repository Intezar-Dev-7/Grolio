// features/user_details/presentation/bloc/user_details_bloc.dart

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import '../../domain/entities/user_details_entity.dart';
import '../../data/datasources/user_details_remote_datasource.dart';

part 'user_details_event.dart';
part 'user_details_state.dart';

class UserDetailsBloc extends Bloc<UserDetailsEvent, UserDetailsState> {
  final UserDetailsRemoteDataSource remoteDataSource;

  UserDetailsBloc({required this.remoteDataSource})
      : super(UserDetailsState.initial()) {
    on<UserDetailsLoadRequested>(_onLoadRequested);
    on<UserDetailsFollowToggled>(_onFollowToggled);
    on<UserDetailsBlockRequested>(_onBlockRequested);
    on<UserDetailsReportRequested>(_onReportRequested);
  }

  Future<void> _onLoadRequested(
      UserDetailsLoadRequested event,
      Emitter<UserDetailsState> emit,
      ) async {
    emit(state.copyWith(status: UserDetailsStatus.loading));

    try {
      final userDetails = await remoteDataSource.getUserDetails(event.userId);
      emit(state.copyWith(
        status: UserDetailsStatus.success,
        userDetails: userDetails.toEntity(),
      ));
    } catch (e) {
      emit(state.copyWith(
        status: UserDetailsStatus.error,
        errorMessage: e.toString(),
      ));
    }
  }

  Future<void> _onFollowToggled(
      UserDetailsFollowToggled event,
      Emitter<UserDetailsState> emit,
      ) async {
    if (state.userDetails == null) return;

    final updatedUser = UserDetailsEntity(
      id: state.userDetails!.id,
      name: state.userDetails!.name,
      username: state.userDetails!.username,
      avatar: state.userDetails!.avatar,
      coverImage: state.userDetails!.coverImage,
      bio: state.userDetails!.bio,
      location: state.userDetails!.location,
      website: state.userDetails!.website,
      joinedDate: state.userDetails!.joinedDate,
      followersCount: state.userDetails!.isFollowing
          ? state.userDetails!.followersCount - 1
          : state.userDetails!.followersCount + 1,
      followingCount: state.userDetails!.followingCount,
      postsCount: state.userDetails!.postsCount,
      isFollowing: !state.userDetails!.isFollowing,
      isOnline: state.userDetails!.isOnline,
      lastSeen: state.userDetails!.lastSeen,
      socialLinks: state.userDetails!.socialLinks,
      techStack: state.userDetails!.techStack,
      recentPosts: state.userDetails!.recentPosts,
      stats: state.userDetails!.stats,
    );

    emit(state.copyWith(userDetails: updatedUser));

    try {
      if (updatedUser.isFollowing) {
        await remoteDataSource.followUser(state.userDetails!.id);
      } else {
        await remoteDataSource.unfollowUser(state.userDetails!.id);
      }
    } catch (e) {
      emit(state.copyWith(userDetails: state.userDetails));
    }
  }

  Future<void> _onBlockRequested(
      UserDetailsBlockRequested event,
      Emitter<UserDetailsState> emit,
      ) async {
    if (state.userDetails == null) return;

    try {
      await remoteDataSource.blockUser(state.userDetails!.id);
    } catch (e) {
      emit(state.copyWith(
        status: UserDetailsStatus.error,
        errorMessage: 'Failed to block user',
      ));
    }
  }

  Future<void> _onReportRequested(
      UserDetailsReportRequested event,
      Emitter<UserDetailsState> emit,
      ) async {
    if (state.userDetails == null) return;

    try {
      await remoteDataSource.reportUser(state.userDetails!.id);
    } catch (e) {
      emit(state.copyWith(
        status: UserDetailsStatus.error,
        errorMessage: 'Failed to report user',
      ));
    }
  }
}
