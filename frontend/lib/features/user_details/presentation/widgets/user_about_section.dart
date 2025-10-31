// features/user_details/presentation/widgets/user_about_section.dart

import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_typography.dart';
import '../../domain/entities/user_details_entity.dart';

class UserAboutSection extends StatelessWidget {
  final UserDetailsEntity user;

  const UserAboutSection({
    super.key,
    required this.user,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'About',
            style: AppTypography.titleMedium.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 12),
          Container(
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
                  user.bio,
                  style: AppTypography.bodyMedium.copyWith(
                    height: 1.6,
                  ),
                ),
                const SizedBox(height: 20),

                // Stats Row
                Row(
                  children: [
                    Expanded(
                      child: _buildStatItem(
                        icon: Icons.local_fire_department,
                        label: 'Streak',
                        value: '${user.stats.contributionStreak} days',
                        color: AppColors.warning,
                      ),
                    ),
                    Container(
                      width: 1,
                      height: 40,
                      color: AppColors.borderColor,
                    ),
                    Expanded(
                      child: _buildStatItem(
                        icon: Icons.code,
                        label: 'Contributions',
                        value: user.stats.totalContributions.toString(),
                        color: AppColors.primaryGreen,
                      ),
                    ),
                  ],
                ),

                if (user.socialLinks.isNotEmpty) ...[
                  const SizedBox(height: 20),
                  const Divider(color: AppColors.borderColor),
                  const SizedBox(height: 16),

                  Text(
                    'Social Links',
                    style: AppTypography.bodySmall.copyWith(
                      color: AppColors.textSecondary,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 12),

                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: user.socialLinks.map((link) {
                      IconData icon;
                      String label;

                      if (link.contains('github')) {
                        icon = Icons.code;
                        label = 'GitHub';
                      } else if (link.contains('twitter')) {
                        icon = Icons.tag;
                        label = 'Twitter';
                      } else if (link.contains('linkedin')) {
                        icon = Icons.work_outline;
                        label = 'LinkedIn';
                      } else {
                        icon = Icons.link;
                        label = 'Website';
                      }

                      return GestureDetector(
                        onTap: () async {
                          final uri = Uri.parse(link);
                          if (await canLaunchUrl(uri)) {
                            await launchUrl(uri);
                          }
                        },
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 8,
                          ),
                          decoration: BoxDecoration(
                            color: AppColors.primaryGreen.withOpacity(0.15),
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(
                              color: AppColors.primaryGreen.withOpacity(0.3),
                              width: 1,
                            ),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                icon,
                                size: 16,
                                color: AppColors.primaryGreen,
                              ),
                              const SizedBox(width: 6),
                              Text(
                                label,
                                style: AppTypography.bodySmall.copyWith(
                                  color: AppColors.primaryGreen,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatItem({
    required IconData icon,
    required String label,
    required String value,
    required Color color,
  }) {
    return Column(
      children: [
        Icon(
          icon,
          color: color,
          size: 24,
        ),
        const SizedBox(height: 8),
        Text(
          value,
          style: AppTypography.titleSmall.copyWith(
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
        const SizedBox(height: 2),
        Text(
          label,
          style: AppTypography.bodySmall.copyWith(
            color: AppColors.textSecondary,
            fontSize: 11,
          ),
        ),
      ],
    );
  }
}
