// features/authentication/data/datasources/auth_local_datasource.dart

import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../../../../core/error/exceptions.dart';
import '../models/user_model.dart';
import 'dart:convert';

abstract class AuthLocalDataSource {
  /// Get cached user
  Future<UserModel?> getCachedUser();

  /// Cache user
  Future<void> cacheUser(UserModel user);

  /// Clear cached user
  Future<void> clearCachedUser();

  /// Save access token (securely)
  Future<void> saveAccessToken(String token);

  /// Get access token
  Future<String?> getAccessToken();

  /// Save refresh token (securely)
  Future<void> saveRefreshToken(String token);

  /// Get refresh token
  Future<String?> getRefreshToken();

  /// Clear all tokens
  Future<void> clearTokens();

  /// Check if user is authenticated
  Future<bool> isAuthenticated();

  /// Save token expiry time
  Future<void> saveTokenExpiryTime(DateTime expiryTime);

  /// Get token expiry time
  Future<DateTime?> getTokenExpiryTime();
}

class AuthLocalDataSourceImpl implements AuthLocalDataSource {
  final SharedPreferences sharedPreferences;
  final FlutterSecureStorage secureStorage;

  // Keys
  static const String _cachedUserKey = 'CACHED_USER';
  static const String _accessTokenKey = 'ACCESS_TOKEN';
  static const String _refreshTokenKey = 'REFRESH_TOKEN';
  static const String _tokenExpiryKey = 'TOKEN_EXPIRY';
  static const String _isAuthenticatedKey = 'IS_AUTHENTICATED';

  AuthLocalDataSourceImpl({
    required this.sharedPreferences,
    required this.secureStorage,
  });

  @override
  Future<UserModel?> getCachedUser() async {
    try {
      final userJson = sharedPreferences.getString(_cachedUserKey);
      if (userJson != null) {
        final userMap = json.decode(userJson) as Map<String, dynamic>;
        return UserModel.fromJson(userMap);
      }
      return null;
    } catch (e) {
      throw CacheException(message: 'Failed to get cached user');
    }
  }

  @override
  Future<void> cacheUser(UserModel user) async {
    try {
      final userJson = json.encode(user.toJson());
      await sharedPreferences.setString(_cachedUserKey, userJson);
      await sharedPreferences.setBool(_isAuthenticatedKey, true);
    } catch (e) {
      throw CacheException(message: 'Failed to cache user');
    }
  }

  @override
  Future<void> clearCachedUser() async {
    try {
      await sharedPreferences.remove(_cachedUserKey);
      await sharedPreferences.setBool(_isAuthenticatedKey, false);
    } catch (e) {
      throw CacheException(message: 'Failed to clear cached user');
    }
  }

  @override
  Future<void> saveAccessToken(String token) async {
    try {
      await secureStorage.write(key: _accessTokenKey, value: token);
    } catch (e) {
      throw CacheException(message: 'Failed to save access token');
    }
  }

  @override
  Future<String?> getAccessToken() async {
    try {
      return await secureStorage.read(key: _accessTokenKey);
    } catch (e) {
      throw CacheException(message: 'Failed to get access token');
    }
  }

  @override
  Future<void> saveRefreshToken(String token) async {
    try {
      await secureStorage.write(key: _refreshTokenKey, value: token);
    } catch (e) {
      throw CacheException(message: 'Failed to save refresh token');
    }
  }

  @override
  Future<String?> getRefreshToken() async {
    try {
      return await secureStorage.read(key: _refreshTokenKey);
    } catch (e) {
      throw CacheException(message: 'Failed to get refresh token');
    }
  }

  @override
  Future<void> clearTokens() async {
    try {
      await secureStorage.delete(key: _accessTokenKey);
      await secureStorage.delete(key: _refreshTokenKey);
      await sharedPreferences.remove(_tokenExpiryKey);
    } catch (e) {
      throw CacheException(message: 'Failed to clear tokens');
    }
  }

  @override
  Future<bool> isAuthenticated() async {
    try {
      return sharedPreferences.getBool(_isAuthenticatedKey) ?? false;
    } catch (e) {
      return false;
    }
  }

  @override
  Future<void> saveTokenExpiryTime(DateTime expiryTime) async {
    try {
      await sharedPreferences.setString(
        _tokenExpiryKey,
        expiryTime.toIso8601String(),
      );
    } catch (e) {
      throw CacheException(message: 'Failed to save token expiry time');
    }
  }

  @override
  Future<DateTime?> getTokenExpiryTime() async {
    try {
      final expiryString = sharedPreferences.getString(_tokenExpiryKey);
      if (expiryString != null) {
        return DateTime.parse(expiryString);
      }
      return null;
    } catch (e) {
      return null;
    }
  }
}
