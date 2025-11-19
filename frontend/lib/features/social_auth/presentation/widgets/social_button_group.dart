// features/phone_auth/presentation/widgets/social_login_buttons.dart

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:frontend/core/constants/app_assets.dart';
import 'package:frontend/features/social_auth/presentation/bloc/social_auth_bloc.dart';
import 'package:frontend/features/social_auth/presentation/bloc/social_auth_event.dart';
import '../../../../core/theme/app_colors.dart';

class SocialLoginButtons extends StatelessWidget {
  const SocialLoginButtons({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        // GOOGLE
        _buildSocialButton(
          context,
          onTap: () {
            context.read<SocialAuthBloc>().add(
              SocialLoginWithProvider("google"),
            );
          },
          child: Image.asset(AppAssets.googleIcon, width: 24, height: 24),
        ),

        const SizedBox(width: 16),

        // GITHUB
        _buildSocialButton(
          context,
          onTap: () {
            context.read<SocialAuthBloc>().add(
              SocialLoginWithProvider("github"),
            );
          },
          child: Image.asset(AppAssets.gitHubIcon, width: 24, height: 24),
        ),
      ],
    );
  }

  Widget _buildSocialButton(
    BuildContext context, {
    required VoidCallback onTap,
    required Widget child,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 80,
        height: 56,
        decoration: BoxDecoration(
          color: AppColors.surfaceDark,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: AppColors.borderColor, width: 1),
        ),
        child: Center(child: child),
      ),
    );
  }
}
