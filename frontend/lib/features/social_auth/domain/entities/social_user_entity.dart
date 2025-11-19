/*Purpose

Defines clean representation of a User

Used in UI & usecases

No JSON or API logic*/

/// Pure domain entity . NO json here
library;

class SocialUserEntity {
  final String userId;
  final String? email;
  final String? name;
  final String? avatar;
  final String accessToken;
  final String sessionId;

  SocialUserEntity({
    required this.userId,
    required this.email,
    required this.name,
    required this.avatar,
    required this.accessToken,
    required this.sessionId,
  });
}
