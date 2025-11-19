import 'package:frontend/features/social_auth/data/datasources/social_auth_remote_datasources.dart';
import 'package:get_it/get_it.dart';

import 'core/services/deep_link_service.dart';

import 'features/social_auth/data/repositories/social_auth_repository_impl.dart';
import 'features/social_auth/domain/repositories/social_auth_repository.dart';

final sl = GetIt.instance;

Future<void> initInjection({required String backendBaseUrl}) async {
  sl.registerLazySingleton(() => DeepLinkService());

  sl.registerLazySingleton<SocialAuthRemoteDataSource>(
    () => SocialAuthRemoteDataSource(backendBaseUrl: backendBaseUrl),
  );

  sl.registerLazySingleton<SocialAuthRepository>(
    () => SocialAuthRepositoryImpl(remote: sl<SocialAuthRemoteDataSource>()),
  );
}
