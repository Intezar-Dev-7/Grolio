// features/authentication/presentation/pages/signup_page.dart

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:frontend/core/router/app_router.dart';
import 'package:frontend/core/constants/app_assets.dart';
import 'package:frontend/features/authentication/presentation/widgets/terms_and_privacy_text.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/widgets/loading_overlay.dart';
import '../bloc/auth_bloc.dart';
import '../widgets/auth_logo.dart';
import '../widgets/email_input_field.dart';
import '../widgets/password_input_field.dart';
import '../widgets/confirm_password_input_field.dart';
import '../widgets/username_input_field.dart';
import '../widgets/primary_button.dart';
import '../widgets/social_auth_button.dart';
import '../widgets/divider_with_text.dart';

class SignUpPage extends StatelessWidget {
  const SignUpPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundDark,
      body: BlocConsumer<AuthBloc, AuthState>(
        listener: (context, state) {
          if (state.status == AuthStatus.authenticated) {
            Navigator.pushReplacementNamed(context, AppRouter.techStack);
          } else if (state.status == AuthStatus.error) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.errorMessage ?? 'Sign up failed'),
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
                      const AuthLogo(),

                      const SizedBox(height: 32),

                      // Title
                      const Text(
                        'Join Grolio',
                        style: AppTypography.welcomeTitle,
                        textAlign: TextAlign.center,
                      ),

                      const SizedBox(height: 8),

                      // Subtitle
                      const Text(
                        'Start your developer journey today',
                        style: AppTypography.subtitle,
                        textAlign: TextAlign.center,
                      ),

                      const SizedBox(height: 32),

                      // GitHub button
                      SocialAuthButton(
                        icon: AppAssets.gitHubIcon,
                        label: 'Sign up with GitHub',
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
                        label: 'Sign up with Google',
                        onPressed: state.status == AuthStatus.loading
                            ? null
                            : () {
                          context.read<AuthBloc>().add(
                            const SignInWithGoogleRequested(),
                          );
                        },
                      ),

                      const SizedBox(height: 24),

                      // Divider
                      const DividerWithText(text: 'or continue with email'),

                      const SizedBox(height: 24),

                      // Email input
                      const EmailInputField(),

                      const SizedBox(height: 16),

                      // Username input
                      const UsernameInputField(),

                      const SizedBox(height: 16),

                      // Password input
                      const PasswordInputField(),

                      const SizedBox(height: 16),

                      // Confirm Password input
                      const ConfirmPasswordInputField(),

                      const SizedBox(height: 24),

                      // Create account button
                      PrimaryButton(
                        label: 'Create account',
                        onPressed: state.isSignUpFormValid &&
                            state.status != AuthStatus.loading
                            ? () {
                          context.read<AuthBloc>().add(
                            SignUpWithEmailRequested(
                              email: state.email,
                              password: state.password,
                              username: state.username,
                            ),
                          );
                        }
                            : null,
                      ),

                      const SizedBox(height: 24),

                      // Sign in link
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'Already have an account? ',
                            style: AppTypography.bodyMedium.copyWith(
                              color: AppColors.textSecondary,
                            ),
                          ),
                          TextButton(
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            style: TextButton.styleFrom(
                              padding: EdgeInsets.zero,
                              minimumSize: Size.zero,
                              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                            ),
                            child: const Text(
                              'Sign in',
                              style: AppTypography.link,
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 32),

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


                      const SizedBox(height: 16),
                      const TermsAndPrivacyText(),
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
