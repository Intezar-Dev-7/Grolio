// features/authentication/presentation/pages/reset_password_page.dart

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/widgets/loading_overlay.dart';
import '../bloc/auth_bloc.dart';
import '../widgets/auth_logo.dart';
import '../widgets/password_input_field.dart';
import '../widgets/confirm_password_input_field.dart';
import '../widgets/primary_button.dart';

class ResetPasswordPage extends StatelessWidget {
  final String token;

  const ResetPasswordPage({super.key, required this.token});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundDark,
      body: BlocConsumer<AuthBloc, AuthState>(
        listener: (context, state) {
          if (state.status == AuthStatus.authenticated) {
            // Show success and navigate to login
            Navigator.pushNamedAndRemoveUntil(
              context,
              '/reset-password-success',
              (route) => false,
            );
          } else if (state.status == AuthStatus.error) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.errorMessage ?? 'Failed to reset password'),
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
                        'Create New Password',
                        style: AppTypography.welcomeTitle,
                        textAlign: TextAlign.center,
                      ),

                      const SizedBox(height: 12),

                      // Description
                      Text(
                        'Your new password must be different from previously used passwords',
                        style: AppTypography.subtitle.copyWith(height: 1.5),
                        textAlign: TextAlign.center,
                      ),

                      const SizedBox(height: 40),

                      // New Password
                      const PasswordInputField(showStrengthIndicator: true),

                      const SizedBox(height: 20),

                      // Confirm Password
                      const ConfirmPasswordInputField(),

                      const SizedBox(height: 32),

                      // Password requirements
                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: AppColors.surfaceDark,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: AppColors.borderColor,
                            width: 1,
                          ),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Password must contain:',
                              style: AppTypography.titleSmall,
                            ),
                            const SizedBox(height: 12),
                            _PasswordRequirement(
                              text: 'At least 8 characters',
                              isMet: state.password.length >= 8,
                            ),
                            const SizedBox(height: 8),
                            _PasswordRequirement(
                              text: 'One uppercase letter',
                              isMet: state.password.contains(RegExp(r'[A-Z]')),
                            ),
                            const SizedBox(height: 8),
                            _PasswordRequirement(
                              text: 'One lowercase letter',
                              isMet: state.password.contains(RegExp(r'[a-z]')),
                            ),
                            const SizedBox(height: 8),
                            _PasswordRequirement(
                              text: 'One number',
                              isMet: state.password.contains(RegExp(r'[0-9]')),
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 32),

                      // Reset password button
                      PrimaryButton(
                        label: 'Reset Password',
                        onPressed:
                            state.isPasswordValid &&
                                    state.isConfirmPasswordValid &&
                                    state.password == state.confirmPassword
                                ? () {
                                  // TODO: Implement reset password with token
                                }
                                : null,
                      ),

                      const SizedBox(height: 40),
                    ],
                  ),
                ),
              ),

              if (state.status == AuthStatus.loading) const LoadingOverlay(),
            ],
          );
        },
      ),
    );
  }
}

// Password requirement widget
class _PasswordRequirement extends StatelessWidget {
  final String text;
  final bool isMet;

  const _PasswordRequirement({required this.text, required this.isMet});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(
          isMet ? Icons.check_circle : Icons.radio_button_unchecked,
          color: isMet ? AppColors.success : AppColors.textTertiary,
          size: 18,
        ),
        const SizedBox(width: 12),
        Text(
          text,
          style: AppTypography.bodySmall.copyWith(
            color: isMet ? AppColors.success : AppColors.textSecondary,
          ),
        ),
      ],
    );
  }
}
