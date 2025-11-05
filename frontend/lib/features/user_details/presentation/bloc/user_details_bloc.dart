// features/user_details/presentation/bloc/user_details_bloc.dart

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import '../../../profile/domain/entities/user_profile_entity.dart';
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
    on<UserDetailsRefreshed>(_onRefreshed);
  }

  Future<void> _onLoadRequested(
      UserDetailsLoadRequested event,
      Emitter<UserDetailsState> emit,
      ) async {
    emit(state.copyWith(status: UserDetailsStatus.loading));

    try {
      final userProfile = await remoteDataSource.getUserProfile(event.userId);

      emit(state.copyWith(
        status: UserDetailsStatus.loaded,
        userProfile: userProfile,
      ));
    } catch (e) {
      emit(state.copyWith(
        status: UserDetailsStatus.error,
        errorMessage: 'Failed to load user profile: ${e.toString()}',
      ));
    }
  }

  Future<void> _onFollowToggled(
      UserDetailsFollowToggled event,
      Emitter<UserDetailsState> emit,
      ) async {
    if (state.userProfile == null) return;

    final currentUser = state.userProfile!;
    final isFollowing = currentUser.isFollowing;

    // Optimistically update UI
    emit(state.copyWith(
      userProfile: UserProfileEntity(
        id: currentUser.id,
        name: currentUser.name,
        username: currentUser.username,
        avatar: currentUser.avatar,
        phone: currentUser.phone,
        bio: currentUser.bio,
        followersCount: isFollowing
            ? currentUser.followersCount - 1
            : currentUser.followersCount + 1,
        followingCount: currentUser.followingCount,
        postsCount: currentUser.postsCount,
        isFollowing: !isFollowing,
        socialLinks: currentUser.socialLinks,
        stats: currentUser.stats,
        achievements: currentUser.achievements,
        pinnedProjects: currentUser.pinnedProjects,
        techStack: currentUser.techStack,
      ),
    ));

    try {
      if (isFollowing) {
        await remoteDataSource.unfollowUser(event.userId);
      } else {
        await remoteDataSource.followUser(event.userId);
      }
    } catch (e) {
      // Revert on error
      emit(state.copyWith(userProfile: currentUser));
    }
  }

  Future<void> _onBlockRequested(
      UserDetailsBlockRequested event,
      Emitter<UserDetailsState> emit,
      ) async {
    if (state.userProfile == null) return;

    try {
      await remoteDataSource.blockUser(state.userProfile!.id);
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
    if (state.userProfile == null) return;

    try {
      await remoteDataSource.reportUser(state.userProfile!.id);
    } catch (e) {
      emit(state.copyWith(
        status: UserDetailsStatus.error,
        errorMessage: 'Failed to report user',
      ));
    }
  }

  Future<void> _onRefreshed(
      UserDetailsRefreshed event,
      Emitter<UserDetailsState> emit,
      ) async {
    if (state.userProfile == null) return;

    try {
      final userProfile = await remoteDataSource.getUserProfile(
        state.userProfile!.id,
      );

      emit(state.copyWith(
        status: UserDetailsStatus.loaded,
        userProfile: userProfile,
      ));
    } catch (e) {
      emit(state.copyWith(
        status: UserDetailsStatus.error,
        errorMessage: 'Failed to refresh user profile',
      ));
    }
  }
}
