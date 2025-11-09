// features/onboarding/presentation/bloc/profile_setup_event.dart

part of 'profile_setup_bloc.dart';

abstract class ProfileSetupEvent extends Equatable {
  const ProfileSetupEvent();

  @override
  List<Object?> get props => [];
}

class ProfileSetupImagePicked extends ProfileSetupEvent {
  final XFile image;

  const ProfileSetupImagePicked(this.image);

  @override
  List<Object?> get props => [image];
}

class ProfileSetupUsernameChanged extends ProfileSetupEvent {
  final String username;

  const ProfileSetupUsernameChanged(this.username);

  @override
  List<Object?> get props => [username];
}

class ProfileSetupTechAdded extends ProfileSetupEvent {
  final String tech;

  const ProfileSetupTechAdded(this.tech);

  @override
  List<Object?> get props => [tech];
}

class ProfileSetupTechRemoved extends ProfileSetupEvent {
  final String tech;

  const ProfileSetupTechRemoved(this.tech);

  @override
  List<Object?> get props => [tech];
}

class ProfileSetupSubmitted extends ProfileSetupEvent {
  final String fullName;
  final String username;
  final String email;
  final String phone;
  final String bio;
  final Map<String, String> socialLinks;

  const ProfileSetupSubmitted({
    required this.fullName,
    required this.username,
    required this.email,
    required this.phone,
    required this.bio,
    required this.socialLinks,
  });

  @override
  List<Object?> get props => [fullName, username, bio, email, phone, socialLinks];
}
