// features/feed/presentation/widgets/feed_app_bar.dart

import 'package:flutter/material.dart';
import 'package:frontend/core/widgets/app_bar_logo_icon.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_typography.dart';

class FeedAppBar extends StatelessWidget {
  const FeedAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    return SliverAppBar(
      floating: true,
      snap: true,
      automaticallyImplyLeading: false,
      backgroundColor: AppColors.backgroundDark,
      elevation: 0,
      title: Row(
        children: [
          // Logo
          const AppBarLogoIcon(),
          const SizedBox(width: 12),
          // App name
          Text(
            'Feed',
            style: AppTypography.headlineMedium.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
      actions: [
        // Search button
        IconButton(
          icon: const Icon(
            Icons.search,
            color: AppColors.iconColor,
          ),
          onPressed: () {
            // Navigate to search
          },
        ),
        // Notification button with badge
        Stack(
          children: [
            IconButton(
              icon: const Icon(
                Icons.notifications_outlined,
                color: AppColors.iconColor,
              ),
              onPressed: () {
                // Navigate to notifications
              },
            ),
            Positioned(
              right: 8,
              top: 8,
              child: Container(
                padding: const EdgeInsets.all(4),
                decoration: const BoxDecoration(
                  color: AppColors.error,
                  shape: BoxShape.circle,
                ),
                constraints: const BoxConstraints(
                  minWidth: 16,
                  minHeight: 16,
                ),
                child: const Center(
                  child: Text(
                    '3',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
        // Filter button
        IconButton(
          icon: const Icon(
            Icons.filter_list,
            color: AppColors.iconColor,
          ),
          onPressed: () {
            // Show filter options
          },
        ),
        const SizedBox(width: 4),
      ],
    );
  }
}
