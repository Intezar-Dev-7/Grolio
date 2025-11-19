/*Purpose

Implements domain repository interface
Calls datasource
Converts data → domain entities
Implements:
loginWithGoogle()
loginWithGithub()
logout()
refreshToken()*/
// social_auth/data/repositories/social_auth_repository_impl.dart

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:frontend/features/social_auth/data/datasources/social_auth_remote_datasources.dart';

import '../../domain/entities/social_user_entity.dart';
import '../../domain/repositories/social_auth_repository.dart';
import '../models/social_user_model.dart';

/// Repository implementation:
/// - uses remote datasource for network calls
/// - stores tokens securely using flutter_secure_storage

class SocialAuthRepositoryImpl implements SocialAuthRepository {
  final SocialAuthRemoteDataSource remote;
  final FlutterSecureStorage _secureStorage = const FlutterSecureStorage();

  SocialAuthRepositoryImpl({required this.remote});

  // Keys used in secure storage
  static const _kAccessKey = 'social_access_token';
  static const _kSessionKey = 'social_session_id';

  @override
  Uri oauthStartUrl(String provider) => remote.oauthStartUrl(provider);

  @override
  Future<void> saveTokens({
    required String accessToken,
    required String sessionId,
  }) async {
    await _secureStorage.write(key: _kAccessKey, value: accessToken);
    await _secureStorage.write(key: _kAccessKey, value: sessionId);
  }

  @override
  Future<void> clearTokens() async {
    await _secureStorage.delete(key: _kAccessKey);
    await _secureStorage.delete(key: _kSessionKey);
  }

  @override
  Future<String?> getAccessToken() => _secureStorage.read(key: _kAccessKey);

  @override
  Future<String?> getSessionId() => _secureStorage.read(key: _kSessionKey);

  @override
  Future<Map<String, dynamic>?> refreshWithSession(String sessionId) async {
    return await remote.refresh(sessionId);
  }

  @override
  Future<bool> logout(String? sessionId) async {
    if (sessionId == null) {
      await clearTokens();
      return true;
    }
    final ok = await remote.logout(sessionId);
    await clearTokens();
    return ok;
  }

  /// Helper to build an entity from raw data when needed
  SocialUserEntity _toEntity(Map<String, dynamic> json) {
    final model = SocialUserModel.fromJson(json);
    return model;
  }
}
