// features/onboarding/presentation/bloc/profile_setup_bloc.dart

import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:image_picker/image_picker.dart';
import '../../data/datasources/onboarding_remote_datasource.dart';

part 'profile_setup_event.dart';
part 'profile_setup_state.dart';

class ProfileSetupBloc extends Bloc<ProfileSetupEvent, ProfileSetupState> {
  final OnboardingRemoteDataSource remoteDataSource;
  Timer? _debounce;

  ProfileSetupBloc({required this.remoteDataSource})
      : super(ProfileSetupState.initial()) {
    on<ProfileSetupImagePicked>(_onImagePicked);
    on<ProfileSetupUsernameChanged>(_onUsernameChanged);
    on<ProfileSetupTechAdded>(_onTechAdded);
    on<ProfileSetupTechRemoved>(_onTechRemoved);
    on<ProfileSetupSubmitted>(_onSubmitted);
  }

  @override
  Future<void> close() {
    _debounce?.cancel();
    return super.close();
  }

  Future<void> _onImagePicked(
      ProfileSetupImagePicked event,
      Emitter<ProfileSetupState> emit,
      ) async {
    emit(state.copyWith(
      selectedImage: event.image,
      status: ProfileSetupStatus.uploadingImage,
    ));

    try {
      final imageUrl = await remoteDataSource.uploadProfileImage(event.image);
      emit(state.copyWith(
        status: ProfileSetupStatus.initial,
        uploadedImageUrl: imageUrl,
      ));
    } catch (e) {
      emit(state.copyWith(
        status: ProfileSetupStatus.error,
        errorMessage: 'Failed to upload image',
        clearImage: true,
      ));
    }
  }

  void _onUsernameChanged(
      ProfileSetupUsernameChanged event,
      Emitter<ProfileSetupState> emit,
      ) {
    if (_debounce?.isActive ?? false) _debounce!.cancel();

    _debounce = Timer(const Duration(milliseconds: 500), () async {
      if (event.username.length >= 3) {
        emit(state.copyWith(status: ProfileSetupStatus.checkingUsername));

        try {
          final isAvailable = await remoteDataSource.checkUsernameAvailability(
            event.username,
          );
          emit(state.copyWith(
            status: ProfileSetupStatus.initial,
            isUsernameAvailable: isAvailable,
          ));
        } catch (e) {
          emit(state.copyWith(
            status: ProfileSetupStatus.initial,
            isUsernameAvailable: false,
          ));
        }
      }
    });
  }

  void _onTechAdded(
      ProfileSetupTechAdded event,
      Emitter<ProfileSetupState> emit,
      ) {
    if (!state.techStack.contains(event.tech)) {
      final updatedTechStack = List<String>.from(state.techStack)
        ..add(event.tech);
      emit(state.copyWith(techStack: updatedTechStack));
    }
  }

  void _onTechRemoved(
      ProfileSetupTechRemoved event,
      Emitter<ProfileSetupState> emit,
      ) {
    final updatedTechStack = List<String>.from(state.techStack)
      ..remove(event.tech);
    emit(state.copyWith(techStack: updatedTechStack));
  }

  Future<void> _onSubmitted(
      ProfileSetupSubmitted event,
      Emitter<ProfileSetupState> emit,
      ) async {
    if (event.fullName.trim().isEmpty) {
      emit(state.copyWith(
        status: ProfileSetupStatus.error,
        errorMessage: 'Please enter your full name',
      ));
      return;
    }

    if (event.username.trim().isEmpty || !state.isUsernameAvailable) {
      emit(state.copyWith(
        status: ProfileSetupStatus.error,
        errorMessage: 'Please choose a valid username',
      ));
      return;
    }

    emit(state.copyWith(status: ProfileSetupStatus.submitting));

    try {
      /*await remoteDataSource.completeProfileSetup(
        fullName: event.fullName,
        username: event.username,
        bio: event.bio,
        techStack: state.techStack,
        socialLinks: event.socialLinks,
        profileImageUrl: state.uploadedImageUrl,
      );*/
      await Future.delayed(const Duration(seconds: 2));

      emit(state.copyWith(status: ProfileSetupStatus.success));
    } catch (e) {
      emit(state.copyWith(
        status: ProfileSetupStatus.error,
        errorMessage: 'Failed to complete profile setup',
      ));
    }
  }
}
