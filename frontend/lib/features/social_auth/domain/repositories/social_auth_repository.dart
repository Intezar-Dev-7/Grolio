/*Purpose

Defines:

Future<SocialUserEntity> loginWithGoogle();
Future<SocialUserEntity> loginWithGithub();
Future<void> logout();
Future<SocialUserEntity> refreshToken();*/
// social_auth/domain/repositories/social_auth_repository.dart
import 'dart:async';

abstract class SocialAuthRepository {
  /// Return the URL to open in the external browser to start OAuth
  Uri oauthStartUrl(String provider);

  /// Save tokens returned from backend (accessToken & sessionId)
  Future<void> saveTokens({
    required String accessToken,
    required String sessionId,
  });

  /// Clear tokens (logout local)
  Future<void> clearTokens();

  /// Read current access token (nullable)
  Future<String?> getAccessToken();

  /// Read session id used for refresh
  Future<String?> getSessionId();

  /// Use sessionId to refresh tokens.
  /// Returns map {accessToken, sessionId} or null on failure.
  Future<Map<String, dynamic>?> refreshWithSession(String sessionId);

  /// Logout (call backend + clear tokens)
  Future<bool> logout(String? sessionId);
}
