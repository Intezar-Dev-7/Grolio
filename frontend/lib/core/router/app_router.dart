import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:frontend/LoadingScreen.dart';
import 'package:frontend/config/dependency_injection.dart' as di;
import 'package:frontend/features/create_post/presentation/page/create_post_page.dart';
import 'package:frontend/features/home/presentation/pages/main_screen.dart';
import 'package:frontend/features/onboarding/presentation/bloc/profile_setup_bloc.dart';
import 'package:frontend/features/onboarding/presentation/pages/goals_page.dart';
import 'package:frontend/features/onboarding/presentation/pages/profile_setup_page.dart';
import 'package:frontend/features/onboarding/presentation/pages/tech_stack_page.dart';
import '../../../features/authentication/presentation/page/login_page.dart';
import '../../../features/authentication/presentation/page/signup_page.dart';
import '../../../features/authentication/presentation/page/forgot_password_page.dart';
import '../../../features/authentication/presentation/page/forgot_password_sent_page.dart';
import '../../../features/authentication/presentation/page/reset_password_page.dart';
import '../../../features/authentication/presentation/page/reset_password_success_page.dart';

class AppRouter {
  // ============================================================================
  // Route Names (Constants for type safety)
  // ============================================================================

  static const String initial = '/';
  static const String loading = '/loading';
  static const String login = '/login';
  static const String signup = '/signup';
  static const String forgotPassword = '/forgot-password';
  static const String forgotPasswordSent = '/forgot-password-sent';
  static const String resetPassword = '/reset-password';
  static const String resetPasswordSuccess = '/reset-password-success';
  static const String home = '/home';
  static const String profile = '/profile';
  static const String profileSetup = '/profile-setup';
  static const String postDetail = '/post-detail';
  static const String createPost = '/create-post';
  static const String editProfile = '/edit-profile';
  static const String settings = '/settings';
  static const String notifications = '/notifications';
  static const String techStack = '/tech-stack';
  static const String goals = '/goals';

  // ============================================================================
  // Main Route Generator (Using onGenerateRoute)
  // ============================================================================

  static Route<dynamic> onGenerateRoute(RouteSettings settings) {
    // Extract arguments from settings
    final args = settings.arguments;

    switch (settings.name) {
      // ========================================================================
      // Authentication Routes
      // ========================================================================

      case initial:
      case loading:
        return _buildRoute(const LoadingScreen(), settings: settings);

      case login:
        return _buildRoute(const LoginPage(), settings: settings);

      case signup:
        return _buildRoute(const SignUpPage(), settings: settings);

      // ========================================================================
      // Forgot Password Flow (WITH DATA PASSING)
      // ========================================================================

      case forgotPassword:
        return _buildRoute(const ForgotPasswordPage(), settings: settings);

      case forgotPasswordSent:
        // Extract email from arguments
        if (args is String) {
          return _buildRoute(
            ForgotPasswordSentPage(email: args),
            settings: settings,
          );
        }
        // Fallback if no email provided
        return _buildRoute(
          const ForgotPasswordSentPage(email: 'your-email@example.com'),
          settings: settings,
        );

      case resetPassword:
        // Extract token from arguments
        if (args is String) {
          return _buildRoute(
            ResetPasswordPage(token: args),
            settings: settings,
          );
        }
        return _errorRoute(settings);

      case resetPasswordSuccess:
        return _buildRoute(
          const ResetPasswordSuccessPage(),
          settings: settings,
        );

      // ========================================================================
      // App Routes (Example with complex data)
      // ========================================================================

      case techStack:
        return _buildRoute(
            const TechStackPage(),
            settings: settings
        );

      case goals:
        return _buildRoute(
          const GoalsPage(),
          settings: settings,
        );

      case home:
        return _buildRoute(
          const MainScreen(),
          settings: settings,
        );

      case profileSetup:
        return MaterialPageRoute(
          builder: (_) => BlocProvider(
            create: (_) => di.sl<ProfileSetupBloc>(),
            child: const ProfileSetupPage(),
          ),
        );

      case createPost:
        return _buildRoute(
          const CreatePostPage(),
          settings: settings,
        );

      case profile:
        // Example: Passing user ID
        if (args is String) {
          return _buildRoute(
            Scaffold(
              body: Center(child: Text('Profile Page - User ID: $args')),
            ),
            settings: settings,
          );
        }
        return _errorRoute(settings);

      // ========================================================================
      // Default/Error Route
      // ========================================================================

      default:
        return _errorRoute(settings);
    }
  }

  // ============================================================================
  // Helper Methods
  // ============================================================================

  /// Build a standard route with custom transition
  static MaterialPageRoute _buildRoute(
    Widget page, {
    required RouteSettings settings,
  }) {
    return MaterialPageRoute(builder: (_) => page, settings: settings);
  }

  /// Build a route with custom page transition
  static PageRouteBuilder _buildCustomRoute(
    Widget page, {
    required RouteSettings settings,
    Duration duration = const Duration(milliseconds: 300),
  }) {
    return PageRouteBuilder(
      settings: settings,
      pageBuilder: (context, animation, secondaryAnimation) => page,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        // Slide transition from right to left
        const begin = Offset(1.0, 0.0);
        const end = Offset.zero;
        const curve = Curves.easeInOut;

        var tween = Tween(
          begin: begin,
          end: end,
        ).chain(CurveTween(curve: curve));

        return SlideTransition(position: animation.drive(tween), child: child);
      },
      transitionDuration: duration,
    );
  }

  /// Error route for undefined routes
  static MaterialPageRoute _errorRoute(RouteSettings settings) {
    return MaterialPageRoute(
      builder:
          (_) => Scaffold(
            appBar: AppBar(title: const Text('Error')),
            body: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.error_outline, size: 80, color: Colors.red),
                  const SizedBox(height: 20),
                  Text(
                    'Route not found: ${settings.name}',
                    style: const TextStyle(fontSize: 16),
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () {
                      // Navigate back or to home
                    },
                    child: const Text('Go Back'),
                  ),
                ],
              ),
            ),
          ),
    );
  }
}
