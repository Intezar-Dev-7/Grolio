// features/authentication/presentation/widgets/terms_and_privacy_text.dart

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_typography.dart';

class TermsAndPrivacyText extends StatelessWidget {
  const TermsAndPrivacyText({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: RichText(
        textAlign: TextAlign.center,
        text: TextSpan(
          style: AppTypography.bodySmall.copyWith(
            color: AppColors.textTertiary,
          ),
          children: [
            const TextSpan(text: 'By signing up, you agree to our '),
            TextSpan(
              text: 'Terms of Service',
              style: AppTypography.bodySmall.copyWith(
                color: AppColors.primaryGreen,
                fontWeight: FontWeight.w500,
              ),
              recognizer: TapGestureRecognizer()
                ..onTap = () {
                  // Navigate to Terms of Service
                  Navigator.pushNamed(context, '/terms');
                },
            ),
            const TextSpan(text: ' and '),
            TextSpan(
              text: 'Privacy Policy',
              style: AppTypography.bodySmall.copyWith(
                color: AppColors.primaryGreen,
                fontWeight: FontWeight.w500,
              ),
              recognizer: TapGestureRecognizer()
                ..onTap = () {
                  // Navigate to Privacy Policy
                  Navigator.pushNamed(context, '/privacy');
                },
            ),
          ],
        ),
      ),
    );
  }
}
