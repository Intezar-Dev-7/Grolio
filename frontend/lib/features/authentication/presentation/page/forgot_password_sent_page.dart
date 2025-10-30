// features/authentication/presentation/pages/forgot_password_sent_page.dart

import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_typography.dart';
import '../widgets/primary_button.dart';
import '../widgets/secondary_button.dart';

class ForgotPasswordSentPage extends StatelessWidget {
  final String email;

  const ForgotPasswordSentPage({super.key, required this.email});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundDark,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Spacer(),

              // Success icon with animation
              TweenAnimationBuilder<double>(
                duration: const Duration(milliseconds: 600),
                tween: Tween(begin: 0.0, end: 1.0),
                curve: Curves.elasticOut,
                builder: (context, value, child) {
                  return Transform.scale(
                    scale: value,
                    child: Container(
                      width: 120,
                      height: 120,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        gradient: LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: [
                            AppColors.success.withOpacity(0.2),
                            AppColors.primaryGreen.withOpacity(0.2),
                          ],
                        ),
                      ),
                      child: Center(
                        child: Container(
                          width: 80,
                          height: 80,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            gradient: const LinearGradient(
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                              colors: [
                                AppColors.success,
                                AppColors.primaryGreen,
                              ],
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: AppColors.success.withOpacity(0.3),
                                blurRadius: 20,
                                offset: const Offset(0, 8),
                              ),
                            ],
                          ),
                          child: const Icon(
                            Icons.check,
                            color: Colors.white,
                            size: 40,
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),

              const SizedBox(height: 32),

              // Title
              const Text(
                'Check your email',
                style: AppTypography.welcomeTitle,
                textAlign: TextAlign.center,
              ),

              const SizedBox(height: 12),

              // Description with email
              RichText(
                textAlign: TextAlign.center,
                text: TextSpan(
                  style: AppTypography.subtitle.copyWith(height: 1.5),
                  children: [
                    const TextSpan(
                      text: 'We\'ve sent a password reset link to\n',
                    ),
                    TextSpan(
                      text: email,
                      style: const TextStyle(
                        color: AppColors.primaryGreen,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 40),

              // Open email app button
              PrimaryButton(
                label: 'Open Email App',
                onPressed: () {
                  // TODO: Open default email app
                  // You can use url_launcher package
                },
              ),

              const SizedBox(height: 16),

              // Back to sign in button
              SecondaryButton(
                label: 'Back to Sign in',
                onPressed: () {
                  Navigator.popUntil(context, (route) => route.isFirst);
                },
              ),

              const SizedBox(height: 32),

              // Resend link
              Center(
                child: TextButton(
                  onPressed: () {
                    // TODO: Resend reset link logic or function call

                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: const Text('Reset link sent again!'),
                        backgroundColor: AppColors.success,
                        behavior: SnackBarBehavior.floating,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    );
                  },
                  child: const Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        'Didn\'t receive the email? ',
                        style: TextStyle(color: AppColors.textSecondary),
                      ),
                      Text('Resend', style: AppTypography.link),
                    ],
                  ),
                ),
              ),

              const Spacer(),

              // Timer info
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: AppColors.surfaceDark,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: AppColors.borderColor, width: 1),
                ),
                child: Row(
                  children: [
                    const Icon(
                      Icons.schedule,
                      color: AppColors.textTertiary,
                      size: 20,
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        'The link will expire in 24 hours',
                        style: AppTypography.bodySmall.copyWith(
                          color: AppColors.textTertiary,
                        ),
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
    );
  }
}
