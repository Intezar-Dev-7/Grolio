// config/dependency_injection.dart

import 'package:frontend/features/discover/data/datasources/discover_remote_datasource.dart';
import 'package:frontend/features/discover/presentation/bloc/discover_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:connectivity_plus/connectivity_plus.dart';

// Core
import 'package:frontend/config/api_config.dart';
import '../core/network/dio_client.dart';
import '../core/network/network_info.dart';

// Authentication
import '../features/authentication/data/datasources/auth_remote_datasource.dart';
import '../features/authentication/data/datasources/auth_local_datasource.dart';
import '../features/authentication/data/repositories/auth_repository_impl.dart';
import '../features/authentication/domain/repositories/auth_repository.dart';
import '../features/authentication/domain/usecases/forgot_password_usecase.dart';
import '../features/authentication/domain/usecases/sign_in_with_email_usecase.dart';
import '../features/authentication/domain/usecases/sign_in_with_github_usecase.dart';
import '../features/authentication/domain/usecases/sign_in_with_google_usecase.dart';
import '../features/authentication/domain/usecases/sign_up_with_email_usecase.dart';
import '../features/authentication/presentation/bloc/auth_bloc.dart';

// Onboarding
import '../features/onboarding/presentation/bloc/tech_stack_bloc.dart';
import '../features/onboarding/presentation/bloc/goals_bloc.dart';

// Feed
import '../features/feed/data/datasources/feed_remote_datasource.dart';
import '../features/feed/data/repositories/feed_repository_impl.dart';
import '../features/feed/domain/repositories/feed_repository.dart';
import '../features/feed/domain/usecases/get_feed_posts_usecase.dart';
import '../features/feed/domain/usecases/like_post_usecase.dart';
import '../features/feed/domain/usecases/bookmark_post_usecase.dart';
import '../features/feed/presentation/bloc/feed_bloc.dart';

// DevSnaps
import '../features/devsnaps/data/datasources/devsnap_remote_datasource.dart';
import '../features/devsnaps/data/repositories/devsnap_repository_impl.dart';
import '../features/devsnaps/domain/repositories/devsnap_repository.dart';
import '../features/devsnaps/domain/usecases/get_stories_usecase.dart';
import '../features/devsnaps/domain/usecases/get_recent_devsnaps_usecase.dart';
import '../features/devsnaps/domain/usecases/create_devsnap_usecase.dart';
import '../features/devsnaps/presentation/bloc/devsnap_bloc.dart';

final sl = GetIt.instance;

Future<void> init() async {
  print('🚀 Starting dependency injection initialization...');

  // ============================================================================
  // External Dependencies (Register FIRST)
  // ============================================================================

  // Shared Preferences
  print('📦 Registering SharedPreferences...');
  final sharedPreferences = await SharedPreferences.getInstance();
  sl.registerLazySingleton<SharedPreferences>(() => sharedPreferences);

  // Secure Storage
  print('📦 Registering FlutterSecureStorage...');
  const secureStorage = FlutterSecureStorage(
    aOptions: AndroidOptions(
      encryptedSharedPreferences: true,
    ),
  );
  sl.registerLazySingleton<FlutterSecureStorage>(() => secureStorage);

  // Connectivity
  print('📦 Registering Connectivity...');
  sl.registerLazySingleton<Connectivity>(() => Connectivity());

  // Dio
  print('📦 Registering Dio with base URL: ${ApiConfig.baseUrl}');
  sl.registerLazySingleton<Dio>(() {
    final dio = Dio(
      BaseOptions(
        baseUrl: ApiConfig.baseUrl,
        connectTimeout: ApiConfig.connectTimeout,
        receiveTimeout: ApiConfig.receiveTimeout,
        sendTimeout: ApiConfig.sendTimeout,
        headers: ApiConfig.defaultHeaders,
      ),
    );

    if (ApiConfig.isDebugMode) {
      dio.interceptors.add(
        LogInterceptor(
          requestBody: true,
          responseBody: true,
          error: true,
          requestHeader: true,
          responseHeader: false,
        ),
      );
    }

    return dio;
  });

  // ============================================================================
  // Core Dependencies
  // ============================================================================

  // Network Info
  print('📦 Registering NetworkInfo...');
  sl.registerLazySingleton<NetworkInfo>(
        () => NetworkInfoImpl(sl<Connectivity>()),
  );

  // Dio Client
  print('📦 Registering DioClient...');
  sl.registerLazySingleton<DioClient>(
        () => DioClient(dio: sl<Dio>()),
  );

  // ============================================================================
  // Features - Authentication
  // ============================================================================

  print('📦 Registering Authentication dependencies...');

  // Data Sources
  sl.registerLazySingleton<AuthLocalDataSource>(
        () => AuthLocalDataSourceImpl(
      sharedPreferences: sl<SharedPreferences>(),
      secureStorage: sl<FlutterSecureStorage>(),
    ),
  );

  sl.registerLazySingleton<AuthRemoteDataSource>(
        () => AuthRemoteDataSourceImpl(
      dioClient: sl<DioClient>(),
    ),
  );

  // Repository
  sl.registerLazySingleton<AuthRepository>(
        () => AuthRepositoryImpl(
      remoteDataSource: sl<AuthRemoteDataSource>(),
      localDataSource: sl<AuthLocalDataSource>(),
      networkInfo: sl<NetworkInfo>(),
    ),
  );

  // Use Cases
  sl.registerLazySingleton<SignInWithEmailUseCase>(
        () => SignInWithEmailUseCase(sl<AuthRepository>()),
  );

  sl.registerLazySingleton<SignInWithGitHubUseCase>(
        () => SignInWithGitHubUseCase(sl<AuthRepository>()),
  );

  sl.registerLazySingleton<SignInWithGoogleUseCase>(
        () => SignInWithGoogleUseCase(sl<AuthRepository>()),
  );

  sl.registerLazySingleton<SignUpWithEmailUseCase>(
        () => SignUpWithEmailUseCase(sl<AuthRepository>()),
  );
  sl.registerLazySingleton<ForgotPasswordUseCase>(
        () => ForgotPasswordUseCase(sl<AuthRepository>()),
  );


  // BLoC
  sl.registerFactory<AuthBloc>(
        () => AuthBloc(
      signInWithEmailUseCase: sl<SignInWithEmailUseCase>(),
      signInWithGitHubUseCase: sl<SignInWithGitHubUseCase>(),
      signInWithGoogleUseCase: sl<SignInWithGoogleUseCase>(),
      signUpWithEmailUseCase: sl<SignUpWithEmailUseCase>(),
      forgotPasswordUseCase: sl<ForgotPasswordUseCase>(),
    ),
  );

  // ============================================================================
  // Features - Onboarding
  // ============================================================================

  print('📦 Registering Onboarding dependencies...');

  // BLoCs
  sl.registerFactory<TechStackBloc>(() => TechStackBloc());
  sl.registerFactory<GoalsBloc>(() => GoalsBloc());

  // ============================================================================
  // Features - Feed
  // ============================================================================

  print('📦 Registering Feed dependencies...');

  // Data Sources
  sl.registerLazySingleton<FeedRemoteDataSource>(
        () => FeedRemoteDataSourceImpl(
      dioClient: sl<DioClient>(),
    ),
  );

  // Repository
  sl.registerLazySingleton<FeedRepository>(
        () => FeedRepositoryImpl(
      remoteDataSource: sl<FeedRemoteDataSource>(),
      networkInfo: sl<NetworkInfo>(),
    ),
  );

  // Use Cases
  sl.registerLazySingleton<GetFeedPostsUseCase>(
        () => GetFeedPostsUseCase(sl<FeedRepository>()),
  );

  sl.registerLazySingleton<LikePostUseCase>(
        () => LikePostUseCase(sl<FeedRepository>()),
  );

  sl.registerLazySingleton<BookmarkPostUseCase>(
        () => BookmarkPostUseCase(sl<FeedRepository>()),
  );

  // BLoC
  sl.registerFactory<FeedBloc>(
        () => FeedBloc(
      getFeedPostsUseCase: sl<GetFeedPostsUseCase>(),
      likePostUseCase: sl<LikePostUseCase>(),
      bookmarkPostUseCase: sl<BookmarkPostUseCase>(),
    ),
  );

  // ============================================================================
  // Features - DevSnaps
  // ============================================================================

  print('📦 Registering DevSnaps dependencies...');

  // Data Sources
  sl.registerLazySingleton<DevSnapRemoteDataSource>(
        () => DevSnapRemoteDataSourceImpl(
      dioClient: sl<DioClient>(),
    ),
  );

  // Repository
  sl.registerLazySingleton<DevSnapRepository>(
        () => DevSnapRepositoryImpl(
      remoteDataSource: sl<DevSnapRemoteDataSource>(),
      networkInfo: sl<NetworkInfo>(),
    ),
  );

  // Use Cases
  sl.registerLazySingleton<GetStoriesUseCase>(
        () => GetStoriesUseCase(sl<DevSnapRepository>()),
  );

  sl.registerLazySingleton<GetRecentDevSnapsUseCase>(
        () => GetRecentDevSnapsUseCase(sl<DevSnapRepository>()),
  );

  sl.registerLazySingleton<CreateDevSnapUseCase>(
        () => CreateDevSnapUseCase(sl<DevSnapRepository>()),
  );

  // BLoC
  sl.registerFactory<DevSnapBloc>(
        () => DevSnapBloc(
      getStoriesUseCase: sl<GetStoriesUseCase>(),
      getRecentDevSnapsUseCase: sl<GetRecentDevSnapsUseCase>(),
      createDevSnapUseCase: sl<CreateDevSnapUseCase>(),
    ),
  );

  print('📦 Registering Discover dependencies...');

  // Data Sources
  sl.registerLazySingleton<DiscoverRemoteDataSource>(
        () => DiscoverRemoteDataSourceImpl(
      dioClient: sl<DioClient>(),
    ),
  );

  // BLoC
  sl.registerFactory<DiscoverBloc>(
        () => DiscoverBloc(
      remoteDataSource: sl<DiscoverRemoteDataSource>(),
    ),
  );

  print('✅ Dependency injection completed successfully!');
}
