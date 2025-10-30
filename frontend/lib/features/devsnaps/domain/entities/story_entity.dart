// features/devsnaps/domain/entities/story_entity.dart

import 'package:equatable/equatable.dart';
import 'package:frontend/features/devsnaps/domain/entities/devsnap_entity.dart';

class StoryEntity extends Equatable {
  final String userId;
  final String username;
  final String? userAvatar;
  final List<DevSnapEntity> snaps;
  final bool hasNewContent;

  const StoryEntity({
    required this.userId,
    required this.username,
    this.userAvatar,
    required this.snaps,
    required this.hasNewContent,
  });

  int get unviewedCount => snaps.where((snap) => !snap.isViewed).length;

  @override
  List<Object?> get props => [
    userId,
    username,
    userAvatar,
    snaps,
    hasNewContent,
  ];
}
