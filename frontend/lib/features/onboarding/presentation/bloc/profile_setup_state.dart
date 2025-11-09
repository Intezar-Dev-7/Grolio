// features/onboarding/presentation/bloc/profile_setup_state.dart

part of 'profile_setup_bloc.dart';

enum ProfileSetupStatus {
  initial,
  uploadingImage,
  checkingUsername,
  submitting,
  success,
  error,
}

class ProfileSetupState extends Equatable {
  final ProfileSetupStatus status;
  final XFile? selectedImage;
  final String? uploadedImageUrl;
  final bool isUsernameAvailable;
  final List<String> techStack;
  final String? errorMessage;

  const ProfileSetupState({
    required this.status,
    this.selectedImage,
    this.uploadedImageUrl,
    required this.isUsernameAvailable,
    required this.techStack,
    this.errorMessage,
  });

  factory ProfileSetupState.initial() {
    return const ProfileSetupState(
      status: ProfileSetupStatus.initial,
      isUsernameAvailable: true,
      techStack: [],
    );
  }

  // bool get canComplete => isNotEmpty;

  ProfileSetupState copyWith({
    ProfileSetupStatus? status,
    XFile? selectedImage,
    String? uploadedImageUrl,
    bool? isUsernameAvailable,
    List<String>? techStack,
    String? errorMessage,
    bool clearImage = false,
  }) {
    return ProfileSetupState(
      status: status ?? this.status,
      selectedImage: clearImage ? null : (selectedImage ?? this.selectedImage),
      uploadedImageUrl: clearImage
          ? null
          : (uploadedImageUrl ?? this.uploadedImageUrl),
      isUsernameAvailable: isUsernameAvailable ?? this.isUsernameAvailable,
      techStack: techStack ?? this.techStack,
      errorMessage: errorMessage,
    );
  }

  @override
  List<Object?> get props => [
    status,
    selectedImage,
    uploadedImageUrl,
    isUsernameAvailable,
    techStack,
    errorMessage,
  ];
}
