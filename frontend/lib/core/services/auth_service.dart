// core/services/auth_service.dart

import 'package:shared_preferences/shared_preferences.dart';

class AuthService {
  static const String _currentUserIdKey = 'current_user_id';
  static const String _userTokenKey = 'user_token';

  // Get current logged-in user ID
  static Future<String?> getCurrentUserId() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_currentUserIdKey);
  }

  // Save user ID after login
  static Future<void> setCurrentUserId(String userId) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_currentUserIdKey, userId);
  }

  // Save token after login
  static Future<void> setUserToken(String token) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_userTokenKey, token);
  }

  // Get token
  static Future<String?> getUserToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_userTokenKey);
  }

  // Clear all data on logout
  static Future<void> clearUserData() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_currentUserIdKey);
    await prefs.remove(_userTokenKey);
  }

  // ✅ MOST IMPORTANT: Check if profile is current user
  static Future<bool> isCurrentUser(String userId) async {
    final currentUserId = await getCurrentUserId();
    return currentUserId == userId;
  }
}
