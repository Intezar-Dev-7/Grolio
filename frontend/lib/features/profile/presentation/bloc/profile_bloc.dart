// features/profile/presentation/bloc/profile_bloc.dart

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import '../../domain/entities/user_profile_entity.dart';
import '../../data/datasources/profile_remote_datasource.dart';

part 'profile_event.dart';
part 'profile_state.dart';

class ProfileBloc extends Bloc<ProfileEvent, ProfileState> {
  final ProfileRemoteDataSource remoteDataSource;

  ProfileBloc({required this.remoteDataSource})
      : super(ProfileState.initial()) {
    on<ProfileLoadRequested>(_onLoadRequested);
    on<ProfileFollowToggled>(_onFollowToggled);
  }

  Future<void> _onLoadRequested(
      ProfileLoadRequested event,
      Emitter<ProfileState> emit,
      ) async {
    emit(state.copyWith(status: ProfileStatus.loading));

    try {
      final profile = event.userId == null
          ? await remoteDataSource.getMyProfile()
          : await remoteDataSource.getUserProfile(event.userId!);

      emit(state.copyWith(
        status: ProfileStatus.success,
        profile: profile.toEntity(),
      ));
    } catch (e) {
      emit(state.copyWith(
        status: ProfileStatus.error,
        errorMessage: e.toString(),
      ));
    }
  }

  Future<void> _onFollowToggled(
      ProfileFollowToggled event,
      Emitter<ProfileState> emit,
      ) async {
    if (state.profile == null) return;

    // Optimistic update
    final updatedProfile = UserProfileEntity(
      id: state.profile!.id,
      name: state.profile!.name,
      username: state.profile!.username,
      avatar: state.profile!.avatar,
      bio: state.profile!.bio,
      followersCount: state.profile!.isFollowing
          ? state.profile!.followersCount - 1
          : state.profile!.followersCount + 1,
      followingCount: state.profile!.followingCount,
      postsCount: state.profile!.postsCount,
      isFollowing: !state.profile!.isFollowing,
      socialLinks: state.profile!.socialLinks,
      stats: state.profile!.stats,
      achievements: state.profile!.achievements,
      pinnedProjects: state.profile!.pinnedProjects,
      techStack: state.profile!.techStack,
    );

    emit(state.copyWith(profile: updatedProfile));

    try {
      if (updatedProfile.isFollowing) {
        await remoteDataSource.followUser(event.userId);
      } else {
        await remoteDataSource.unfollowUser(event.userId);
      }
    } catch (e) {
      // Revert on error
      emit(state.copyWith(profile: state.profile));
    }
  }
}
