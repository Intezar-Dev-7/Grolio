// features/authentication/data/repositories/auth_repository_impl.dart

import 'package:dartz/dartz.dart';
import '../../../../core/error/exceptions.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/network/network_info.dart';
import '../../domain/entities/auth_result_entity.dart';
import '../../domain/entities/user_entity.dart';
import '../../domain/repositories/auth_repository.dart';
import '../datasources/auth_local_datasource.dart';
import '../datasources/auth_remote_datasource.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource remoteDataSource;
  final AuthLocalDataSource localDataSource;
  final NetworkInfo networkInfo;

  AuthRepositoryImpl({
    required this.remoteDataSource,
    required this.localDataSource,
    required this.networkInfo,
  });

  @override
  Future<Either<Failure, AuthResultEntity>> signInWithEmail({
    required String email,
    required String password,
  }) async {
    // Check network connectivity
    if (!await networkInfo.isConnected) {
      return const Left(NetworkFailure('No internet connection'));
    }
    print('h3llo -----------');
    try {
      // Call remote data source
      final authResult = await remoteDataSource.signInWithEmail(
        email: email,
        password: password,
      );

      // Cache user data and tokens
      await _cacheAuthResult(authResult);

      // Convert model to entity and return
      return Right(authResult.toEntity());
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } on NetworkException catch (e) {
      return Left(NetworkFailure(e.message));
    } on AuthenticationException catch (e) {
      return Left(AuthenticationFailure(e.message));
    } on ValidationException catch (e) {
      return Left(ValidationFailure(e.message));
    } catch (e) {
      return const Left(ServerFailure('An unexpected error occurred'));
    }
  }

  @override
  Future<Either<Failure, AuthResultEntity>> signInWithGitHub() async {
    if (!await networkInfo.isConnected) {
      return const Left(NetworkFailure('No internet connection'));
    }

    try {
      // TODO: Implement GitHub OAuth flow to get auth code
      const authCode = 'GITHUB_AUTH_CODE'; // Replace with actual OAuth flow

      final authResult = await remoteDataSource.signInWithGitHub(
        authCode: authCode,
      );

      await _cacheAuthResult(authResult);

      return Right(authResult.toEntity());
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } on NetworkException catch (e) {
      return Left(NetworkFailure(e.message));
    } on AuthenticationException catch (e) {
      return Left(AuthenticationFailure(e.message));
    } catch (e) {
      return const Left(ServerFailure('An unexpected error occurred'));
    }
  }

  @override
  Future<Either<Failure, AuthResultEntity>> signInWithGoogle() async {
    if (!await networkInfo.isConnected) {
      return const Left(NetworkFailure('No internet connection'));
    }

    try {
      // TODO: Implement Google Sign-In to get ID token
      const idToken = 'GOOGLE_ID_TOKEN'; // Replace with actual Google Sign-In

      final authResult = await remoteDataSource.signInWithGoogle(
        idToken: idToken,
      );

      await _cacheAuthResult(authResult);

      return Right(authResult.toEntity());
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } on NetworkException catch (e) {
      return Left(NetworkFailure(e.message));
    } on AuthenticationException catch (e) {
      return Left(AuthenticationFailure(e.message));
    } catch (e) {
      return const Left(ServerFailure('An unexpected error occurred'));
    }
  }

  @override
  Future<Either<Failure, AuthResultEntity>> signUpWithEmail({
    required String email,
    required String password,
    required String displayName,
  }) async {
    if (!await networkInfo.isConnected) {
      return const Left(NetworkFailure('No internet connection'));
    }

    try {
      final authResult = await remoteDataSource.signUpWithEmail(
        email: email,
        password: password,
        displayName: displayName,
      );

      await _cacheAuthResult(authResult);

      return Right(authResult.toEntity());
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } on NetworkException catch (e) {
      return Left(NetworkFailure(e.message));
    } on AuthenticationException catch (e) {
      return Left(AuthenticationFailure(e.message));
    } on ValidationException catch (e) {
      return Left(ValidationFailure(e.message));
    } catch (e) {
      return const Left(ServerFailure('An unexpected error occurred'));
    }
  }

  @override
  Future<Either<Failure, void>> signOut() async {
    try {
      // Sign out from remote (if connected)
      if (await networkInfo.isConnected) {
        await remoteDataSource.signOut();
      }

      // Clear local cache and tokens
      await localDataSource.clearCachedUser();
      await localDataSource.clearTokens();

      return const Right(null);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } on CacheException catch (e) {
      return Left(CacheFailure(e.message));
    } catch (e) {
      return const Left(ServerFailure('An unexpected error occurred'));
    }
  }

  @override
  Future<Either<Failure, UserEntity?>> getCurrentUser() async {
    try {
      // First, try to get from cache
      final cachedUser = await localDataSource.getCachedUser();
      if (cachedUser != null) {
        return Right(cachedUser.toEntity());
      }

      // If not cached and connected, fetch from remote
      if (await networkInfo.isConnected) {
        final user = await remoteDataSource.getCurrentUser();
        await localDataSource.cacheUser(user);
        return Right(user.toEntity());
      }

      return const Right(null);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } on CacheException catch (e) {
      return Left(CacheFailure(e.message));
    } on AuthenticationException catch (e) {
      return Left(AuthenticationFailure(e.message));
    } catch (e) {
      return const Left(ServerFailure('An unexpected error occurred'));
    }
  }

  @override
  Future<Either<Failure, bool>> isAuthenticated() async {
    try {
      final isAuth = await localDataSource.isAuthenticated();

      // Check if token is still valid
      if (isAuth) {
        final expiryTime = await localDataSource.getTokenExpiryTime();
        if (expiryTime != null && expiryTime.isBefore(DateTime.now())) {
          // Token expired, try to refresh
          final refreshToken = await localDataSource.getRefreshToken();
          if (refreshToken != null) {
            final refreshResult = await refreshAccessToken(
              refreshToken: refreshToken,
            );
            return refreshResult.fold(
              (failure) => const Right(false),
              (newToken) => const Right(true),
            );
          }
          return const Right(false);
        }
      }

      return Right(isAuth);
    } catch (e) {
      return const Right(false);
    }
  }

  @override
  Future<Either<Failure, void>> resetPassword({required String email}) async {
    if (!await networkInfo.isConnected) {
      return const Left(NetworkFailure('No internet connection'));
    }

    try {
      await remoteDataSource.resetPassword(email: email);
      return const Right(null);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } on NetworkException catch (e) {
      return Left(NetworkFailure(e.message));
    } catch (e) {
      return const Left(ServerFailure('An unexpected error occurred'));
    }
  }

  @override
  Future<Either<Failure, String>> refreshAccessToken({
    required String refreshToken,
  }) async {
    if (!await networkInfo.isConnected) {
      return const Left(NetworkFailure('No internet connection'));
    }

    try {
      final newAccessToken = await remoteDataSource.refreshAccessToken(
        refreshToken: refreshToken,
      );

      await localDataSource.saveAccessToken(newAccessToken);

      return Right(newAccessToken);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } on NetworkException catch (e) {
      return Left(NetworkFailure(e.message));
    } on AuthenticationException catch (e) {
      // If refresh fails, clear tokens
      await localDataSource.clearTokens();
      await localDataSource.clearCachedUser();
      return Left(AuthenticationFailure(e.message));
    } catch (e) {
      return const Left(ServerFailure('An unexpected error occurred'));
    }
  }

  /// Helper method to cache authentication result
  Future<void> _cacheAuthResult(dynamic authResult) async {
    await localDataSource.cacheUser(authResult.user);
    await localDataSource.saveAccessToken(authResult.accessToken);
    await localDataSource.saveRefreshToken(authResult.refreshToken);
    await localDataSource.saveTokenExpiryTime(authResult.expiresAt);
  }
}
