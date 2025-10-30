// features/devsnaps/presentation/widgets/story_circle.dart

import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_typography.dart';

class StoryCircle extends StatelessWidget {
  final String username;
  final String initial;
  final bool hasStory;
  final bool isAddStory;
  final VoidCallback onTap;

  const StoryCircle({
    super.key,
    required this.username,
    required this.initial,
    required this.hasStory,
    this.isAddStory = false,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 72,
        margin: const EdgeInsets.only(right: 12),
        child: Column(
          children: [
            Stack(
              children: [
                // Story circle with gradient border
                Container(
                  width: 64,
                  height: 64,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: hasStory
                        ? const LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        AppColors.primaryGreen,
                        AppColors.primaryBlue,
                      ],
                    )
                        : null,
                    border: !hasStory && !isAddStory
                        ? Border.all(
                      color: AppColors.borderColor,
                      width: 2,
                    )
                        : null,
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(3),
                    child: Container(
                      decoration: const BoxDecoration(
                        color: AppColors.surfaceDark,
                        shape: BoxShape.circle,
                      ),
                      child: Center(
                        child: Text(
                          initial,
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: hasStory
                                ? AppColors.primaryGreen
                                : AppColors.textSecondary,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),

                // Add icon for "Your story"
                if (isAddStory)
                  Positioned(
                    bottom: 0,
                    right: 0,
                    child: Container(
                      width: 20,
                      height: 20,
                      decoration: BoxDecoration(
                        color: AppColors.primaryGreen,
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: AppColors.backgroundDark,
                          width: 2,
                        ),
                      ),
                      child: const Icon(
                        Icons.add,
                        color: Colors.white,
                        size: 12,
                      ),
                    ),
                  ),

                // Active indicator dot
                if (hasStory)
                  Positioned(
                    top: 0,
                    right: 0,
                    child: Container(
                      width: 12,
                      height: 12,
                      decoration: BoxDecoration(
                        color: AppColors.primaryGreen,
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: AppColors.backgroundDark,
                          width: 2,
                        ),
                      ),
                    ),
                  ),
              ],
            ),
            const SizedBox(height: 6),
            Text(
              username,
              style: AppTypography.bodySmall.copyWith(
                fontSize: 11,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
