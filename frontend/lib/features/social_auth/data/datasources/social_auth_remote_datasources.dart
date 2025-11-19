// ignore_for_file: public_member_api_docs, sort_constructors_first
/*Purpose
Calls /auth/google backend endpoint
Calls /auth/github if you ad
Calls /auth/apple etc.
Uses Dio or http
Sends tokens to backend
Receives JWT + refresh token*/
// social_auth/data/datasources/social_auth_remote_datasource.dart
import 'dart:convert';
import 'package:http/http.dart' as http;

/// Remote datasource that talks to your backend endpoints
/// - /auth/google (GET) -> starts OAuth (open URL in browser)
/// - /auth/github (GET)
/// - /auth/refresh (POST) -> refresh access token using sessionId
/// - /auth/logout (POST)
///
/// Note: oauthStart just returns the URL to open in browser — it's simple.

class SocialAuthRemoteDataSource {
  final String backendBaseUrl;

  SocialAuthRemoteDataSource({required this.backendBaseUrl});

  // Return OAuth start URL for  provider (open this in external browser)

  Uri oauthStartUrl(String provider) =>
      Uri.parse('$backendBaseUrl/auth/$provider');

  /// Try refreshing tokens with sessionId.
  /// Returns parsed JSON map on success or throws/returns null on failure
  Future<Map<String, dynamic>?> refresh(String sessionId) async {
    final url = Uri.parse('$backendBaseUrl/auth/refresh');
    final res = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'sessionId': sessionId}),
    );

    if (res.statusCode == 200) {
      return jsonDecode(res.body) as Map<String, dynamic>;
    }
    return null;
  }

  // Logout endpoint : tells backend to delete or refresh session
  Future<bool> logout(String sessionId) async {
    final url = Uri.parse('$backendBaseUrl/auth/logout');

    final res = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'sessionId': sessionId}),
    );
    return res.statusCode == 200;
  }
}
