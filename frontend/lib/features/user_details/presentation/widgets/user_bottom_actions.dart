// features/user_details/presentation/widgets/user_bottom_actions.dart

import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_typography.dart';

class UserBottomActions extends StatelessWidget {
  final String userName;
  final VoidCallback onAddToFavourites;
  final VoidCallback onAddToList;
  final VoidCallback onBlock;
  final VoidCallback onReport;

  const UserBottomActions({
    super.key,
    required this.userName,
    required this.onAddToFavourites,
    required this.onAddToList,
    required this.onBlock,
    required this.onReport,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 8),
      margin: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: AppColors.surfaceDark,
        border: const Border(
          top: BorderSide(
            color: AppColors.borderColor,
            width: 1,
          ),
        ),
        borderRadius: BorderRadius.circular(16),
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
            onTap: onAddToFavourites,
          ),

          // Add to list
          _buildActionTile(
            icon: Icons.list_alt,
            label: 'Add to list',
            iconColor: AppColors.iconColor,
            textColor: AppColors.textPrimary,
            onTap: onAddToList,
          ),

          const Divider(
            color: AppColors.borderColor,
            thickness: 1,
            height: 1,
          ),

          // Block user
          _buildActionTile(
            icon: Icons.block,
            label: 'Block $userName',
            iconColor: AppColors.error,
            textColor: AppColors.error,
            onTap: onBlock,
          ),

          // Report user
          _buildActionTile(
            icon: Icons.report_outlined,
            label: 'Report $userName',
            iconColor: AppColors.error,
            textColor: AppColors.error,
            onTap: onReport,
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
