// features/authentication/domain/repositories/auth_repository.dart

import 'package:dartz/dartz.dart';
import 'package:frontend/core/error/failures.dart';
import '../entities/auth_result_entity.dart';
import '../entities/user_entity.dart';

abstract class AuthRepository {
  /// Sign in with email and password
  Future<Either<Failure, AuthResultEntity>> signInWithEmail({
    required String email,
    required String password,
  });

  /// Sign in with GitHub
  Future<Either<Failure, AuthResultEntity>> signInWithGitHub();

  /// Sign in with Google
  Future<Either<Failure, AuthResultEntity>> signInWithGoogle();

  /// Sign up with email and password
  Future<Either<Failure, AuthResultEntity>> signUpWithEmail({
    required String email,
    required String password,
    required String displayName,
  });

  /// Sign out
  Future<Either<Failure, void>> signOut();

  /// Get current user
  Future<Either<Failure, UserEntity?>> getCurrentUser();

  /// Check if user is authenticated
  Future<Either<Failure, bool>> isAuthenticated();

  /// Reset password
  Future<Either<Failure, void>> resetPassword({
    required String email,
  });

  /// Refresh access token
  Future<Either<Failure, String>> refreshAccessToken({
    required String refreshToken,
  });
}
