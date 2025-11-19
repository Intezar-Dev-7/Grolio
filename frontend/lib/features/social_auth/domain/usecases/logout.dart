// social_auth/domain/usecases/logout.dart
import '../../domain/repositories/social_auth_repository.dart';

class LogoutUseCase {
  final SocialAuthRepository repository;

  LogoutUseCase(this.repository);

  Future<bool> execute(String? sessionId) async {
    return await repository.logout(sessionId);
  }
}
