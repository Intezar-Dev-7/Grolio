// features/devsnaps/data/models/story_model.dart

import '../../domain/entities/story_entity.dart';
import 'devsnap_model.dart';

class StoryModel {
  final String userId;
  final String username;
  final String? userAvatar;
  final List<DevSnapModel> snaps;
  final bool hasNewContent;

  StoryModel({
    required this.userId,
    required this.username,
    this.userAvatar,
    required this.snaps,
    required this.hasNewContent,
  });

  factory StoryModel.fromJson(Map<String, dynamic> json) {
    return StoryModel(
      userId: json['user_id'] as String,
      username: json['username'] as String,
      userAvatar: json['user_avatar'] as String?,
      snaps: (json['snaps'] as List<dynamic>)
          .map((snap) => DevSnapModel.fromJson(snap as Map<String, dynamic>))
          .toList(),
      hasNewContent: json['has_new_content'] as bool,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'user_id': userId,
      'username': username,
      'user_avatar': userAvatar,
      'snaps': snaps.map((snap) => snap.toJson()).toList(),
      'has_new_content': hasNewContent,
    };
  }

  StoryEntity toEntity() {
    return StoryEntity(
      userId: userId,
      username: username,
      userAvatar: userAvatar,
      snaps: snaps.map((snap) => snap.toEntity()).toList(),
      hasNewContent: hasNewContent,
    );
  }
}
