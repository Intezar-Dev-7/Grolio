/*Purpose

Represent the data returned from backend

Convert JSON → Dart object

Extend entity*/

import 'package:frontend/features/social_auth/domain/entities/social_user_entity.dart';

/// Model that represents the paylaod you might get from backend
/// In our flow the real user data is minimal because accessToken/sessionId are the main values

class SocialUserModel extends SocialUserEntity {
  SocialUserModel({
    required super.userId,
    required super.email,
    required super.name,
    required super.avatar,
    required super.accessToken,
    required super.sessionId,
  });

  /// Build from backend JSON response if needed
  factory SocialUserModel.fromJson(Map<String, dynamic> json) {
    return SocialUserModel(
      userId: json['userId']?.toString() ?? '',
      email: json['email'] as String?,
      name: json['name'] as String?,
      avatar: json['avatar'] as String?,
      accessToken: json['accessToken'] as String? ?? '',
      sessionId: json['sessionId'] as String? ?? '',
    );
  }

  Map<String, dynamic> tojson() {
    return {
      'userId': userId,
      'email': email,
      'name': name,
      'avatar': avatar,
      'accessToken': accessToken,
      'sessionId': sessionId,
    };
  }
}
