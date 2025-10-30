// main.dart

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:frontend/LoadingScreen.dart';
import 'package:frontend/core/router/app_router.dart';
import 'package:frontend/features/authentication/presentation/page/forgot_password_page.dart';
import 'package:frontend/features/authentication/presentation/page/forgot_password_sent_page.dart';
import 'package:frontend/features/authentication/presentation/page/login_page.dart';
import 'package:frontend/features/authentication/presentation/page/signup_page.dart';
import 'config/dependency_injection.dart' as di;
import 'core/network/network_service.dart';
import 'core/theme/app_theme.dart';
import 'features/authentication/presentation/bloc/auth_bloc.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize all dependencies
  await di.init();

  // Initialize network interceptors after DI
  NetworkService.initializeInterceptors(
    di.sl<Dio>(),
    di.sl<FlutterSecureStorage>(),
  );

  // Set system UI
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.light,
      systemNavigationBarColor: Color(0xFF0D0D0D),
      systemNavigationBarIconBrightness: Brightness.light,
    ),
  );

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider<AuthBloc>(
      create: (context) => di.sl<AuthBloc>(),
      child: MaterialApp(
        title: 'Grolio',
        debugShowCheckedModeBanner: false,
        theme: AppTheme.darkTheme,
        initialRoute: AppRouter.initial,
        onGenerateRoute: AppRouter.onGenerateRoute,
      ),
    );
  }
}
