// features/authentication/presentation/widgets/username_input_field.dart

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_typography.dart';
import '../bloc/auth_bloc.dart';

class UsernameInputField extends StatelessWidget {
  const UsernameInputField({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthBloc, AuthState>(
      builder: (context, state) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // const Text('Username', style: AppTypography.inputLabel),
            const SizedBox(height: 8),
            TextField(
              onChanged: (value) {
                context.read<AuthBloc>().add(UsernameChanged(value));
              },
              style: AppTypography.inputText,
              decoration: InputDecoration(
                hintText: 'johndoe',
                prefixIcon: const Icon(
                  Icons.person_outline,
                  color: AppColors.iconColor,
                ),
                suffixIcon:
                    state.username.isNotEmpty
                        ? Icon(
                          state.isUsernameValid
                              ? Icons.check_circle
                              : Icons.error,
                          color:
                              state.isUsernameValid
                                  ? AppColors.success
                                  : AppColors.error,
                        )
                        : null,
                errorText:
                    state.username.isNotEmpty && !state.isUsernameValid
                        ? '3-20 characters, letters, numbers, underscore only'
                        : null,
              ),
            ),
          ],
        );
      },
    );
  }
}
