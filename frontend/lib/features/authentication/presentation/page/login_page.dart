import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:frontend/core/router/app_router.dart';
import 'package:frontend/core/constants/app_assets.dart';
import 'package:frontend/core/widgets/loading_overlay.dart';
import 'package:frontend/features/authentication/presentation/bloc/auth_bloc.dart';
import 'package:frontend/features/authentication/presentation/widgets/auth_logo.dart';
import 'package:frontend/features/authentication/presentation/widgets/divider_with_text.dart';
import 'package:frontend/features/authentication/presentation/widgets/email_input_field.dart';
import 'package:frontend/features/authentication/presentation/widgets/password_input_field.dart';
import 'package:frontend/features/authentication/presentation/widgets/primary_button.dart';
import 'package:frontend/features/authentication/presentation/widgets/social_auth_button.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_typography.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundDark,
      body: BlocConsumer<AuthBloc, AuthState>(
        listener: (context, state) {
          if (state.status == AuthStatus.authenticated) {
            // Navigate to home screen
            print("Goto home screen");
          } else if (state.status == AuthStatus.error) {
            // Show error message
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.errorMessage ?? 'Authentication failed'),
                backgroundColor: AppColors.error,
                behavior: SnackBarBehavior.floating,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            );
          }
        },
        builder: (context, state) {
          return Stack(
            children: [
              SafeArea(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      const SizedBox(height: 40),

                      // Logo
                      const Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          AuthLogo(),

                          SizedBox(width: 12),

                          // Welcome text
                          Column(
                            children: [
                              Text(
                                'Welcome back',
                                style: AppTypography.welcomeTitle,
                                textAlign: TextAlign.center,
                              ),

                              SizedBox(height: 8),

                              // Subtitle
                              Text(
                                'Continue your developer journey',
                                style: AppTypography.subtitle,
                                textAlign: TextAlign.center,
                              ),
                            ],
                          ),
                        ],
                      ),

                      const SizedBox(height: 32),

                      // GitHub button
                      SocialAuthButton(
                        icon: AppAssets.gitHubIcon,
                        label: 'Continue with GitHub',
                        onPressed: state.status == AuthStatus.loading
                            ? null
                            : () {
                          context.read<AuthBloc>().add(
                            const SignInWithGitHubRequested(),
                          );
                        },
                      ),

                      const SizedBox(height: 16),

                      // Google button
                      SocialAuthButton(
                        icon: AppAssets.mailIcon,
                        label: 'Continue with Google',
                        onPressed: state.status == AuthStatus.loading
                            ? null
                            : () {
                          Navigator.pushNamed(context, AppRouter.techStack);
                          /*context.read<AuthBloc>().add(
                            const SignInWithGoogleRequested(),
                          );*/
                        },
                      ),

                      const SizedBox(height: 24),

                      // Divider
                      const DividerWithText(text: 'or continue with email'),

                      const SizedBox(height: 14),

                      // Email input
                      const EmailInputField(),

                      const SizedBox(height: 16),

                      // Password input
                      const PasswordInputField(),

                      const SizedBox(height: 2),

                      // Forgot password
                      Align(
                        alignment: Alignment.centerRight,
                        child: TextButton(
                          onPressed: () {
                            Navigator.pushNamed(context, AppRouter.forgotPassword);
                          },
                          child: const Text(
                            'Forgot password?',
                            style: AppTypography.link,
                          ),
                        ),
                      ),

                      const SizedBox(height: 4),

                      // Sign in button
                      PrimaryButton(
                        label: 'Sign in',
                        onPressed: state.isEmailValid &&
                            state.status != AuthStatus.loading
                            ? () {
                          context.read<AuthBloc>().add(
                            SignInWithEmailRequested(
                              email: state.email,
                              password: state.password,
                            ),
                          );
                        }
                            : null,
                      ),

                      const SizedBox(height: 14),

                      // Sign up link
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "Don't have an account? ",
                            style: AppTypography.bodyMedium.copyWith(
                              color: AppColors.textSecondary,
                            ),
                          ),
                          TextButton(
                            onPressed: () {
                              Navigator.pushNamed(context, AppRouter.signup);
                            },
                            style: TextButton.styleFrom(
                              padding: EdgeInsets.zero,
                              minimumSize: Size.zero,
                              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                            ),
                            child: const Text(
                              'Sign up',
                              style: AppTypography.link,
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 12),

                      // Join community banner
                      Container(
                        padding: const EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          color: AppColors.surfaceDark,
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(
                            color: AppColors.borderColor,
                            width: 1,
                          ),
                        ),
                        child: Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                color: AppColors.primaryGreen.withOpacity(0.1),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: const Icon(
                                Icons.people_outline,
                                color: AppColors.primaryGreen,
                                size: 24,
                              ),
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text(
                                    'Join 10,000+ developers',
                                    style: AppTypography.titleMedium,
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    'Share code, collaborate on projects, and grow your network',
                                    style: AppTypography.bodySmall.copyWith(
                                      color: AppColors.textSecondary,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 40),
                    ],
                  ),
                ),
              ),

              // Loading overlay
              if (state.status == AuthStatus.loading)
                const LoadingOverlay(),
            ],
          );
        },
      ),
    );
  }
}
