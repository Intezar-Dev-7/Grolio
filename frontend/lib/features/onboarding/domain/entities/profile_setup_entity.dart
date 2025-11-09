// features/onboarding/domain/entities/profile_setup_entity.dart

import 'package:equatable/equatable.dart';

class ProfileSetupEntity extends Equatable {
  final String fullName;
  final String username;
  final String bio;
  final List<String> techStack;
  final Map<String, String> socialLinks;
  final String? profileImagePath;

  const ProfileSetupEntity({
    required this.fullName,
    required this.username,
    required this.bio,
    required this.techStack,
    required this.socialLinks,
    this.profileImagePath,
  });

  @override
  List<Object?> get props => [
    fullName,
    username,
    bio,
    techStack,
    socialLinks,
    profileImagePath,
  ];
}
