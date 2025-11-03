// main.dart

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:frontend/core/router/app_router.dart';
import 'package:frontend/features/chat/presentation/bloc/chat_bloc.dart';
import 'package:frontend/features/create_post/presentation/bloc/create_post_bloc.dart';
import 'package:frontend/features/discover/presentation/bloc/discover_bloc.dart';
import 'package:frontend/features/phone_auth/presentation/bloc/phone_auth_bloc.dart';
import 'package:frontend/features/profile/presentation/bloc/profile_bloc.dart';
import 'package:timeago/timeago.dart' as timeago;
import 'config/dependency_injection.dart' as di;
import 'core/theme/app_theme.dart';
import 'features/feed/presentation/bloc/feed_bloc.dart';
import 'features/devsnaps/presentation/bloc/devsnap_bloc.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize timeago
  timeago.setLocaleMessages('en', timeago.EnMessages());

  // Initialize dependency injection
  await di.init();

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
    return MultiBlocProvider(
      providers: [
        // Authentication BLoC
        BlocProvider<PhoneAuthBloc>(
          create: (context) => di.sl<PhoneAuthBloc>(),
        ),

        // Feed BLoC
        BlocProvider<FeedBloc>(
          create: (context) => di.sl<FeedBloc>(),
        ),

        // DevSnaps BLoC
        BlocProvider<DevSnapBloc>(
          create: (context) => di.sl<DevSnapBloc>(),
        ),

        // Discover BLoC
        BlocProvider<DiscoverBloc>(
          create: (context) => di.sl<DiscoverBloc>(),
        ),

        // Chat BLoc
        BlocProvider<ChatBloc>(
          create: (context) => di.sl<ChatBloc>(),
        ),

        // Profile BLoC
        BlocProvider<ProfileBloc>(
          create: (context) => di.sl<ProfileBloc>(),
        ),

        // Create Post BLoC
        BlocProvider<CreatePostBloc>(
          create: (context) => di.sl<CreatePostBloc>(),
        ),
      ],
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
