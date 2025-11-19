// Purpose

// Each file calls only ONE method from repo

// Used by BLoC

// Isolated business logic
// social_auth/domain/usecases/login_with_google.dart
// social_auth/domain/usecases/login_with_github.dart
import '../../domain/repositories/social_auth_repository.dart';

class LoginWithGithub {
  final SocialAuthRepository repository;

  LoginWithGithub(this.repository);

  Uri execute() {
    return repository.oauthStartUrl('github');
  }
}
