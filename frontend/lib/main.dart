import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:frontend/core/router/app_router.dart';
import 'package:frontend/features/chat/presentation/bloc/chat_bloc.dart';
import 'package:frontend/features/create_post/presentation/bloc/create_post_bloc.dart';
import 'package:frontend/features/discover/presentation/bloc/discover_bloc.dart';
import 'package:frontend/features/notifications/presentation/bloc/notification_bloc.dart';
import 'package:frontend/features/phone_auth/presentation/bloc/phone_auth_bloc.dart';
import 'package:frontend/features/profile/presentation/bloc/profile_bloc.dart';
import 'package:frontend/features/social_auth/presentation/bloc/social_auth_bloc.dart';
import 'package:timeago/timeago.dart' as timeago;
import 'config/dependency_injection.dart' as di;
import 'core/theme/app_theme.dart';
import 'features/feed/presentation/bloc/feed_bloc.dart';
import 'package:uni_links/uni_links.dart';
import 'package:frontend/features/social_auth/presentation/bloc/social_auth_event.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  timeago.setLocaleMessages('en', timeago.EnMessages());

  await di.init();

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

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    super.initState();

    // Deep Link Listener for Google / GitHub OAuth callback
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final socialBloc = context.read<SocialAuthBloc>();

      uriLinkStream.listen((uri) {
        if (uri != null && uri.scheme == 'grolio') {
          socialBloc.add(SocialReceivedDeepLink(uri));
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<PhoneAuthBloc>(create: (_) => di.sl<PhoneAuthBloc>()),
        BlocProvider<FeedBloc>(create: (_) => di.sl<FeedBloc>()),
        BlocProvider<DiscoverBloc>(create: (_) => di.sl<DiscoverBloc>()),
        BlocProvider<ChatBloc>(create: (_) => di.sl<ChatBloc>()),
        BlocProvider<ProfileBloc>(create: (_) => di.sl<ProfileBloc>()),
        BlocProvider<CreatePostBloc>(create: (_) => di.sl<CreatePostBloc>()),
        BlocProvider<NotificationBloc>(
          create:
              (_) =>
                  di.sl<NotificationBloc>()
                    ..add(const NotificationLoadRequested()),
        ),
        BlocProvider<SocialAuthBloc>(create: (_) => di.sl<SocialAuthBloc>()),
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
