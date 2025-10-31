// features/profile/presentation/widgets/achievements_section.dart

import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_typography.dart';
import '../../domain/entities/user_profile_entity.dart';

class AchievementsSection extends StatelessWidget {
  final List<AchievementEntity> achievements;

  const AchievementsSection({
    super.key,
    required this.achievements,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.surfaceDark,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: AppColors.borderColor,
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Achievements',
            style: AppTypography.titleMedium.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: achievements.map((achievement) {
              return _buildAchievementItem(achievement);
            }).toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildAchievementItem(AchievementEntity achievement) {
    return Column(
      children: [
        Container(
          width: 56,
          height: 56,
          decoration: BoxDecoration(
            gradient: achievement.isUnlocked
                ? LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                AppColors.primaryGreen.withOpacity(0.2),
                AppColors.primaryBlue.withOpacity(0.2),
              ],
            )
                : null,
            color: achievement.isUnlocked
                ? null
                : AppColors.backgroundDark,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: achievement.isUnlocked
                  ? AppColors.primaryGreen.withOpacity(0.3)
                  : AppColors.borderColor,
              width: 1,
            ),
          ),
          child: Center(
            child: Text(
              achievement.icon,
              style: TextStyle(
                fontSize: 28,
                color: achievement.isUnlocked
                    ? null
                    : AppColors.textTertiary.withOpacity(0.3),
              ),
            ),
          ),
        ),
        const SizedBox(height: 8),
        Text(
          achievement.title,
          style: AppTypography.bodySmall.copyWith(
            color: achievement.isUnlocked
                ? AppColors.textPrimary
                : AppColors.textTertiary,
            fontSize: 10,
            fontWeight: FontWeight.w500,
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}
