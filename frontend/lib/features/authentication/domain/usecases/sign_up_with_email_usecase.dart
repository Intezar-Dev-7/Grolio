import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/auth_result_entity.dart';
import '../repositories/auth_repository.dart';

class SignUpWithEmailUseCase
    implements UseCase<AuthResultEntity, SignUpWithEmailParams> {
  final AuthRepository repository;

  SignUpWithEmailUseCase(this.repository);

  @override
  Future<Either<Failure, AuthResultEntity>> call(
      SignUpWithEmailParams params,
      ) async {
    return await repository.signUpWithEmail(
      email: params.email,
      password: params.password,
      displayName: params.displayName,
    );
  }
}

class SignUpWithEmailParams {
  final String email;
  final String password;
  final String displayName;

  SignUpWithEmailParams({
    required this.email,
    required this.password,
    required this.displayName,
  });
}
