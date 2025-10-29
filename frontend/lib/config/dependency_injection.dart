// config/dependency_injection.dart (CORRECTED VERSION)

import 'package:frontend/features/authentication/domain/usecases/forgot_password_usecase.dart';
import 'package:frontend/features/onboarding/presentation/bloc/goals_bloc.dart';
import 'package:frontend/features/onboarding/presentation/bloc/tech_stack_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:connectivity_plus/connectivity_plus.dart';

import '../core/network/dio_client.dart';
import '../core/network/network_info.dart';
import '../features/authentication/data/datasources/auth_remote_datasource.dart';
import '../features/authentication/data/datasources/auth_local_datasource.dart';
import '../features/authentication/data/repositories/auth_repository_impl.dart';
import '../features/authentication/domain/repositories/auth_repository.dart';
import '../features/authentication/domain/usecases/sign_in_with_email_usecase.dart';
import '../features/authentication/domain/usecases/sign_in_with_github_usecase.dart';
import '../features/authentication/domain/usecases/sign_in_with_google_usecase.dart';
import '../features/authentication/domain/usecases/sign_up_with_email_usecase.dart';
import '../features/authentication/presentation/bloc/auth_bloc.dart';

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

  // Dio (without interceptors first)
  print('📦 Registering Dio...');
  sl.registerLazySingleton<Dio>(() {
    final dio = Dio(
      BaseOptions(
        baseUrl: 'https://api.grolio.dev', // Replace with your API URL
        connectTimeout: const Duration(seconds: 30),
        receiveTimeout: const Duration(seconds: 30),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
      ),
    );

    // Add logging interceptor only
    dio.interceptors.add(
      LogInterceptor(
        requestBody: true,
        responseBody: true,
        error: true,
        requestHeader: true,
        responseHeader: false,
      ),
    );

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

  // Dio Client (WITHOUT auth interceptor to avoid circular dependency)
  print('📦 Registering DioClient...');
  sl.registerLazySingleton<DioClient>(
        () => DioClient(dio: sl<Dio>()),
  );

  // ============================================================================
  // Features - Authentication (Data Layer)
  // ============================================================================

  // Local Data Source
  print('📦 Registering AuthLocalDataSource...');
  sl.registerLazySingleton<AuthLocalDataSource>(
        () => AuthLocalDataSourceImpl(
      sharedPreferences: sl<SharedPreferences>(),
      secureStorage: sl<FlutterSecureStorage>(),
    ),
  );

  // Remote Data Source (NO circular dependency)
  print('📦 Registering AuthRemoteDataSource...');
  sl.registerLazySingleton<AuthRemoteDataSource>(
        () => AuthRemoteDataSourceImpl(
      dioClient: sl<DioClient>(),
    ),
  );

  // ============================================================================
  // Features - Authentication (Domain Layer)
  // ============================================================================

  // Repository
  print('📦 Registering AuthRepository...');
  sl.registerLazySingleton<AuthRepository>(
        () => AuthRepositoryImpl(
      remoteDataSource: sl<AuthRemoteDataSource>(),
      localDataSource: sl<AuthLocalDataSource>(),
      networkInfo: sl<NetworkInfo>(),
    ),
  );

  // Use Cases
  print('📦 Registering Use Cases...');
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


  // ============================================================================
  // Features - Authentication (Presentation Layer)
  // ============================================================================

  // BLoC - Use factory to create new instance each time
  print('📦 Registering AuthBloc...');
  sl.registerFactory<AuthBloc>(
        () => AuthBloc(
      signInWithEmailUseCase: sl<SignInWithEmailUseCase>(),
      signInWithGitHubUseCase: sl<SignInWithGitHubUseCase>(),
      signInWithGoogleUseCase: sl<SignInWithGoogleUseCase>(),
      signUpWithEmailUseCase: sl<SignUpWithEmailUseCase>(),
      forgotPasswordUseCase: sl<ForgotPasswordUseCase>(),
    ),
  );
  sl.registerFactory<TechStackBloc>(() => TechStackBloc());
  sl.registerFactory<GoalsBloc>(() => GoalsBloc());

  print('✅ Dependency injection completed successfully!');
}
