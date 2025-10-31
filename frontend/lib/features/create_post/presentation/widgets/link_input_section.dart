// features/create_post/presentation/widgets/link_input_section.dart

import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_typography.dart';

class LinkInputSection extends StatelessWidget {
  final TextEditingController githubController;
  final TextEditingController demoController;

  const LinkInputSection({
    super.key,
    required this.githubController,
    required this.demoController,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Links (Optional)',
          style: AppTypography.titleSmall.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 12),

        // GitHub Link
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          decoration: BoxDecoration(
            color: AppColors.surfaceDark,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: AppColors.borderColor,
              width: 1,
            ),
          ),
          child: Row(
            children: [
              const Icon(
                Icons.code,
                color: AppColors.primaryGreen,
                size: 20,
              ),
              const SizedBox(width: 12),
              Expanded(
                child: TextField(
                  controller: githubController,
                  style: AppTypography.bodyMedium,
                  decoration: InputDecoration(
                    hintText: 'GitHub repository URL',
                    hintStyle: AppTypography.bodyMedium.copyWith(
                      color: AppColors.textTertiary,
                    ),
                    border: InputBorder.none,
                  ),
                ),
              ),
            ],
          ),
        ),

        const SizedBox(height: 12),

        // Demo Link
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          decoration: BoxDecoration(
            color: AppColors.surfaceDark,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: AppColors.borderColor,
              width: 1,
            ),
          ),
          child: Row(
            children: [
              const Icon(
                Icons.link,
                color: AppColors.primaryBlue,
                size: 20,
              ),
              const SizedBox(width: 12),
              Expanded(
                child: TextField(
                  controller: demoController,
                  style: AppTypography.bodyMedium,
                  decoration: InputDecoration(
                    hintText: 'Live demo URL',
                    hintStyle: AppTypography.bodyMedium.copyWith(
                      color: AppColors.textTertiary,
                    ),
                    border: InputBorder.none,
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
