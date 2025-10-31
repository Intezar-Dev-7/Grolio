// features/authentication/presentation/widgets/email_input_field.dart (Updated)

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_typography.dart';
import '../bloc/auth_bloc.dart';

class EmailInputField extends StatelessWidget {
  const EmailInputField({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthBloc, AuthState>(
      builder: (context, state) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // const Text('Email', style: AppTypography.inputLabel),
            const SizedBox(height: 8),
            TextField(
              onChanged: (value) {
                context.read<AuthBloc>().add(EmailChanged(value));
              },
              keyboardType: TextInputType.emailAddress,
              style: AppTypography.inputText,
              decoration: InputDecoration(
                hintText: 'developer@example.com',
                prefixIcon: const Icon(
                  Icons.email_outlined,
                  color: AppColors.iconColor,
                ),
                suffixIcon:
                    state.email.isNotEmpty
                        ? Icon(
                          state.isEmailValid ? Icons.check_circle : Icons.error,
                          color:
                              state.isEmailValid
                                  ? AppColors.success
                                  : AppColors.error,
                        )
                        : null,
                errorText:
                    state.email.isNotEmpty && !state.isEmailValid
                        ? 'Please enter a valid email'
                        : null,
              ),
            ),
          ],
        );
      },
    );
  }
}
