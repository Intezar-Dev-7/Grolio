// social_auth/domain/usecases/refresh_token.dart
import '../../domain/repositories/social_auth_repository.dart';

class RefreshToken {
  final SocialAuthRepository repository;

  RefreshToken(this.repository);

  /// Attempts to rotate the session and obtain a new access token.
  /// Returns a map {accessToken, sessionId} on success, null on failure.
  Future<Map<String, dynamic>?> execute(String sessionId) async {
    return await repository.refreshWithSession(sessionId);
  }
}
