import '../../domain/repositories/social_auth_repository.dart';

class LoginWithGoogle {
  final SocialAuthRepository repository;

  LoginWithGoogle(this.repository);

  /// Returns the URL to open for OAuth in external browser
  Uri execute() {
    return repository.oauthStartUrl('google');
  }
}
