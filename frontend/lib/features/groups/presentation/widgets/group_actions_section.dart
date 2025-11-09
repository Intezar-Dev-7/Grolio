// features/groups/presentation/widgets/group_actions_section.dart

import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_typography.dart';

class GroupActionsSection extends StatelessWidget {
  final String groupName;
  final bool isAdmin;
  final bool isMember;
  final VoidCallback onExitGroup;
  final VoidCallback onReportGroup;

  const GroupActionsSection({
    super.key,
    required this.groupName,
    required this.isAdmin,
    required this.isMember,
    required this.onExitGroup,
    required this.onReportGroup,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 8),
      decoration: BoxDecoration(
        color: AppColors.surfaceDark,
        border: Border(
          top: BorderSide(
            color: AppColors.borderColor,
            width: 1,
          ),
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Add to Favourites
          _buildActionTile(
            icon: Icons.favorite_border,
            label: 'Add to Favourites',
            iconColor: AppColors.iconColor,
            textColor: AppColors.textPrimary,
            onTap: () {
              // TODO: Add to favourites
            },
          ),

          const Divider(
            color: AppColors.borderColor,
            thickness: 1,
            height: 1,
          ),

          // Exit Group
          _buildActionTile(
            icon: Icons.exit_to_app,
            label: 'Exit group',
            iconColor: AppColors.error,
            textColor: AppColors.error,
            onTap: onExitGroup,
          ),

          // Report Group
          _buildActionTile(
            icon: Icons.report_outlined,
            label: 'Report group',
            iconColor: AppColors.error,
            textColor: AppColors.error,
            onTap: onReportGroup,
          ),
        ],
      ),
    );
  }

  Widget _buildActionTile({
    required IconData icon,
    required String label,
    required Color iconColor,
    required Color textColor,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        child: Row(
          children: [
            Icon(
              icon,
              color: iconColor,
              size: 24,
            ),
            const SizedBox(width: 16),
            Text(
              label,
              style: AppTypography.bodyMedium.copyWith(
                color: textColor,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
