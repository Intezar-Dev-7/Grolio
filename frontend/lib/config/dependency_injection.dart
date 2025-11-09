// config/dependency_injection.dart

import 'package:frontend/features/chat/data/datasources/chat_remote_datasource.dart';
import 'package:frontend/features/chat/presentation/bloc/chat_bloc.dart';
import 'package:frontend/features/create_post/data/datasource/create_post_remote_datasource.dart';
import 'package:frontend/features/create_post/presentation/bloc/create_post_bloc.dart';
import 'package:frontend/features/discover/data/datasources/discover_remote_datasource.dart';
import 'package:frontend/features/discover/presentation/bloc/discover_bloc.dart';
import 'package:frontend/features/groups/data/datasources/group_remote_datasource.dart';
import 'package:frontend/features/notifications/data/datasources/notification_remote_datasource.dart';
import 'package:frontend/features/notifications/presentation/bloc/notification_bloc.dart';
import 'package:frontend/features/onboarding/data/datasources/onboarding_remote_datasource.dart';
import 'package:frontend/features/onboarding/presentation/bloc/profile_setup_bloc.dart';
import 'package:frontend/features/phone_auth/data/datasources/phone_auth_remote_datasource.dart';
import 'package:frontend/features/phone_auth/presentation/bloc/phone_auth_bloc.dart';
import 'package:frontend/features/profile/data/datasources/profile_remote_datasource.dart';
import 'package:frontend/features/profile/presentation/bloc/profile_bloc.dart';
import 'package:frontend/features/user_details/data/datasources/user_details_remote_datasource.dart';
import 'package:get_it/get_it.dart';
import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:connectivity_plus/connectivity_plus.dart';

// Core
import 'package:frontend/config/api_config.dart';
import '../core/network/dio_client.dart';
import '../core/network/network_info.dart';

// Feed
import '../features/feed/data/datasources/feed_remote_datasource.dart';
import '../features/feed/data/repositories/feed_repository_impl.dart';
import '../features/feed/domain/repositories/feed_repository.dart';
import '../features/feed/domain/usecases/get_feed_posts_usecase.dart';
import '../features/feed/domain/usecases/like_post_usecase.dart';
import '../features/feed/domain/usecases/bookmark_post_usecase.dart';
import '../features/feed/presentation/bloc/feed_bloc.dart';

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
  // Features - Onboarding
  // ============================================================================

  // Data Sources
  sl.registerLazySingleton<OnboardingRemoteDataSource>(
        () => OnboardingRemoteDataSourceImpl(
      dioClient: sl<DioClient>(),
    ),
  );

  // BLoC
  sl.registerFactory<ProfileSetupBloc>(
        () => ProfileSetupBloc(
      remoteDataSource: sl<OnboardingRemoteDataSource>(),
    ),
  );

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
  // Features - Discover
  // ============================================================================


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

  // ============================================================================
  // Features - Chat, Conversation
  // ============================================================================


  print('📦 Registering Chat dependencies...');

  // Data Sources
  sl.registerLazySingleton<ChatRemoteDataSource>(
        () => ChatRemoteDataSourceImpl(
      dioClient: sl<DioClient>(),
    ),
  );

  // BLoC
  sl.registerFactory<ChatBloc>(
        () => ChatBloc(
      remoteDataSource: sl<ChatRemoteDataSource>(),
    ),
  );

  // ============================================================================
  // Features - Profile
  // ============================================================================


  print('📦 Registering Profile dependencies...');

  // Data Sources
  sl.registerLazySingleton<ProfileRemoteDataSource>(
        () => ProfileRemoteDataSourceImpl(
      dioClient: sl<DioClient>(),
    ),
  );

  // BLoC
  sl.registerFactory<ProfileBloc>(
        () => ProfileBloc(
      remoteDataSource: sl<ProfileRemoteDataSource>(),
    ),
  );

  // ============================================================================
  // Features - User Details
  // ============================================================================

  print('📦 Registering User Details dependencies...');

  sl.registerLazySingleton<UserDetailsRemoteDataSource>(
        () => UserDetailsRemoteDataSourceImpl(
      dioClient: sl<DioClient>(),
    ),
  );

  // ============================================================================
  // Features - Groups
  // ============================================================================

  print('📦 Registering Groups dependencies...');

  sl.registerLazySingleton<GroupRemoteDataSource>(
        () => GroupRemoteDataSourceImpl(
      dioClient: sl<DioClient>(),
    ),
  );

  // ============================================================================
  // Features - Create Post
  // ============================================================================

  print('📦 Registering Create Post dependencies...');

  // Data Sources
  sl.registerLazySingleton<CreatePostRemoteDataSource>(
        () => CreatePostRemoteDataSourceImpl(
      dioClient: sl<DioClient>(),
    ),
  );

  // BLoC
  sl.registerFactory<CreatePostBloc>(
        () => CreatePostBloc(
      remoteDataSource: sl<CreatePostRemoteDataSource>(),
    ),
  );

  // ============================================================================
  // Features - Phone Auth
  // ============================================================================

  print('📦 Registering Phone Auth dependencies...');

  // Data Sources
  sl.registerLazySingleton<PhoneAuthRemoteDataSource>(
        () => PhoneAuthRemoteDataSourceImpl(
      dioClient: sl<DioClient>(),
    ),
  );

  // BLoC
  sl.registerFactory<PhoneAuthBloc>(
        () => PhoneAuthBloc(
      remoteDataSource: sl<PhoneAuthRemoteDataSource>(),
    ),
  );

  // ============================================================================
  // Features - Notifications
  // ============================================================================

  print('📦 Registering Notifications dependencies...');

  // Data Sources
  sl.registerLazySingleton<NotificationRemoteDataSource>(
        () => NotificationRemoteDataSourceImpl(
      dioClient: sl<DioClient>(),
    ),
  );

  // BLoC - Register as Factory (per-screen)
  sl.registerFactory<NotificationBloc>(
        () => NotificationBloc(
      remoteDataSource: sl<NotificationRemoteDataSource>(),
    ),
  );

  print('✅ Dependency injection completed successfully!');
}
