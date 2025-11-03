// features/phone_auth/presentation/widgets/social_login_buttons.dart

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:frontend/core/constants/app_assets.dart';
import '../../../../core/theme/app_colors.dart';
import '../bloc/phone_auth_bloc.dart';

class SocialLoginButtons extends StatelessWidget {
  const SocialLoginButtons({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        // Google
        _buildSocialButton(
          context,
          onTap: () {
            context.read<PhoneAuthBloc>().add(
              const PhoneAuthGoogleRequested(),
            );
          },
          child: Image.asset(
            AppAssets.googleIcon,
            width: 24,
            height: 24,
          ),
        ),

        const SizedBox(width: 16),

        // Apple
        _buildSocialButton(
          context,
          onTap: () {
            context.read<PhoneAuthBloc>().add(
              const PhoneAuthAppleRequested(),
            );
          },
          child: const Icon(
            Icons.apple,
            color: Colors.white,
            size: 28,
          ),
        ),

        const SizedBox(width: 16),

        // GitHub
        _buildSocialButton(
          context,
          onTap: () {
            context.read<PhoneAuthBloc>().add(
              const PhoneAuthGithubRequested(),
            );
          },
          child: Image.asset(
            AppAssets.gitHubIcon,
            width: 24,
            height: 24,
          ),
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
          border: Border.all(
            color: AppColors.borderColor,
            width: 1,
          ),
        ),
        child: Center(child: child),
      ),
    );
  }
}
