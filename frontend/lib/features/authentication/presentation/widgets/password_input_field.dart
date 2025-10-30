// features/authentication/presentation/widgets/password_input_field.dart (Updated with strength indicator)

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/utils/validators.dart';
import '../bloc/auth_bloc.dart';

class PasswordInputField extends StatelessWidget {
  final bool showStrengthIndicator;

  const PasswordInputField({
    super.key,
    this.showStrengthIndicator = false,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthBloc, AuthState>(
      builder: (context, state) {
        final strength = Validators.getPasswordStrength(state.password);

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Password',
              style: AppTypography.inputLabel,
            ),
            const SizedBox(height: 8),
            TextField(
              onChanged: (value) {
                context.read<AuthBloc>().add(PasswordChanged(value));
              },
              obscureText: !state.isPasswordVisible,
              style: AppTypography.inputText,
              decoration: InputDecoration(
                hintText: '••••••••',
                prefixIcon: const Icon(
                  Icons.lock_outline,
                  color: AppColors.iconColor,
                ),
                suffixIcon: IconButton(
                  onPressed: () {
                    context.read<AuthBloc>().add(
                      const PasswordVisibilityToggled(),
                    );
                  },
                  icon: Icon(
                    state.isPasswordVisible
                        ? Icons.visibility_outlined
                        : Icons.visibility_off_outlined,
                    color: AppColors.iconColor,
                  ),
                ),
                errorText: state.password.isNotEmpty && !state.isPasswordValid
                    ? 'Password must be at least 8 characters'
                    : null,
              ),
            ),

            // Password strength indicator (only for sign up)
            if (showStrengthIndicator && state.password.isNotEmpty) ...[
              const SizedBox(height: 8),
              Row(
                children: [
                  Expanded(
                    child: Row(
                      children: List.generate(4, (index) {
                        return Expanded(
                          child: Container(
                            height: 4,
                            margin: EdgeInsets.only(
                              right: index < 3 ? 4 : 0,
                            ),
                            decoration: BoxDecoration(
                              color: index < strength
                                  ? _getStrengthColor(strength)
                                  : AppColors.borderColor,
                              borderRadius: BorderRadius.circular(2),
                            ),
                          ),
                        );
                      }),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Text(
                    _getStrengthText(strength),
                    style: AppTypography.bodySmall.copyWith(
                      color: _getStrengthColor(strength),
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ],
          ],
        );
      },
    );
  }

  Color _getStrengthColor(int strength) {
    switch (strength) {
      case 1:
        return AppColors.error;
      case 2:
        return AppColors.warning;
      case 3:
        return const Color(0xFFFFEB3B); // Yellow
      case 4:
        return AppColors.success;
      default:
        return AppColors.borderColor;
    }
  }

  String _getStrengthText(int strength) {
    switch (strength) {
      case 1:
        return 'Weak';
      case 2:
        return 'Fair';
      case 3:
        return 'Good';
      case 4:
        return 'Strong';
      default:
        return '';
    }
  }
}
