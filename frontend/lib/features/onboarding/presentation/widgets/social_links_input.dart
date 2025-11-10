// features/onboarding/presentation/widgets/social_links_input.dart

import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_typography.dart';

class SocialLinksInput extends StatelessWidget {
  final Map<String, TextEditingController> controllers;

  const SocialLinksInput({super.key, required this.controllers});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Social Links',
          style: AppTypography.bodyMedium.copyWith(fontWeight: FontWeight.w600),
        ),
        const SizedBox(height: 12),

        // GitHub
        _buildSocialInput(
          icon: Icons.code,
          iconColor: AppColors.primaryGreen,
          controller: controllers['github']!,
          hint: 'github.com/username',
        ),
        const SizedBox(height: 12),

        // LinkedIn
        _buildSocialInput(
          icon: Icons.work_outline,
          iconColor: const Color(0xFF0077B5),
          controller: controllers['linkedin']!,
          hint: 'linkedin.com/in/username',
        ),
        const SizedBox(height: 12),

        // Twitter
        _buildSocialInput(
          icon: Icons.tag,
          iconColor: const Color(0xFF1DA1F2),
          controller: controllers['twitter']!,
          hint: 'twitter.com/username',
        ),
        const SizedBox(height: 12),

        // Instagram
        _buildSocialInput(
          icon: Icons.camera_alt_outlined,
          iconColor: const Color(0xFFE4405F),
          controller: controllers['instagram']!,
          hint: 'instagram.com/username',
        ),
        const SizedBox(height: 12),

        // Portfolio
        _buildSocialInput(
          icon: Icons.link,
          iconColor: AppColors.primaryBlue,
          controller: controllers['portfolio']!,
          hint: 'yourportfolio.com',
        ),
      ],
    );
  }

  Widget _buildSocialInput({
    required IconData icon,
    required Color iconColor,
    required TextEditingController controller,
    required String hint,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.surfaceDark,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.borderColor, width: 1),
      ),
      child: Row(
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: iconColor.withOpacity(0.1),
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(12),
                bottomLeft: Radius.circular(12),
              ),
            ),
            child: Icon(icon, color: iconColor, size: 20),
          ),
          Expanded(
            child: TextField(
              controller: controller,
              style: AppTypography.bodyMedium,
              decoration: InputDecoration(
                hintText: hint,
                hintStyle: AppTypography.bodyMedium.copyWith(
                  color: AppColors.textTertiary,
                ),
                border: InputBorder.none,
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 14,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
