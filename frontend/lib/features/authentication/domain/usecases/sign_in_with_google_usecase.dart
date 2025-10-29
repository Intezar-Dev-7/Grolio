import 'package:dartz/dartz.dart';
import 'package:frontend/core/error/failures.dart';
import 'package:frontend/core/usecases/usecase.dart';
import '../entities/auth_result_entity.dart';
import '../repositories/auth_repository.dart';

class SignInWithGoogleUseCase
    implements UseCase<AuthResultEntity, NoParams> {
  final AuthRepository repository;

  SignInWithGoogleUseCase(this.repository);

  @override
  Future<Either<Failure, AuthResultEntity>> call(NoParams params) async {
    return await repository.signInWithGoogle();
  }
}
