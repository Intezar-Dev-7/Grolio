// features/authentication/presentation/widgets/confirm_password_input_field.dart

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_typography.dart';
import '../bloc/auth_bloc.dart';

class ConfirmPasswordInputField extends StatefulWidget {
  const ConfirmPasswordInputField({super.key});

  @override
  State<ConfirmPasswordInputField> createState() =>
      _ConfirmPasswordInputFieldState();
}

class _ConfirmPasswordInputFieldState extends State<ConfirmPasswordInputField> {
  bool _isVisible = false;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthBloc, AuthState>(
      builder: (context, state) {
        final passwordsMatch =
            state.confirmPassword.isNotEmpty &&
            state.confirmPassword == state.password;
        final showError = state.confirmPassword.isNotEmpty && !passwordsMatch;

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // const Text('Confirm Password', style: AppTypography.inputLabel),
            const SizedBox(height: 8),
            TextField(
              onChanged: (value) {
                context.read<AuthBloc>().add(ConfirmPasswordChanged(value));
              },
              obscureText: !_isVisible,
              style: AppTypography.inputText,
              decoration: InputDecoration(
                hintText: '••••••••',
                prefixIcon: const Icon(
                  Icons.lock_outline,
                  color: AppColors.iconColor,
                ),
                suffixIcon: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    if (state.confirmPassword.isNotEmpty)
                      Padding(
                        padding: const EdgeInsets.only(right: 8),
                        child: Icon(
                          passwordsMatch ? Icons.check_circle : Icons.error,
                          color:
                              passwordsMatch
                                  ? AppColors.success
                                  : AppColors.error,
                          size: 20,
                        ),
                      ),
                    IconButton(
                      onPressed: () {
                        setState(() {
                          _isVisible = !_isVisible;
                        });
                      },
                      icon: Icon(
                        _isVisible
                            ? Icons.visibility_outlined
                            : Icons.visibility_off_outlined,
                        color: AppColors.iconColor,
                      ),
                    ),
                  ],
                ),
                errorText: showError ? 'Passwords do not match' : null,
              ),
            ),
          ],
        );
      },
    );
  }
}
