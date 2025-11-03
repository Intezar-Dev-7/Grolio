// features/discover/presentation/widgets/discover_header.dart

import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_typography.dart';

class DiscoverSearchBar extends StatelessWidget {
  const DiscoverSearchBar({super.key});

  @override
  Widget build(BuildContext context) {
    return SliverToBoxAdapter(
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 24,vertical: 12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Search Bar
            Container(
              height: 48,
              decoration: BoxDecoration(
                color: AppColors.surfaceDark,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: AppColors.borderColor,
                  width: 1,
                ),
              ),
              child: TextField(
                style: AppTypography.bodyMedium,
                decoration: InputDecoration(
                  hintText: 'Search developers, projects, hackathons...',
                  hintStyle: AppTypography.bodyMedium.copyWith(
                    color: AppColors.textTertiary,
                  ),
                  prefixIcon: const Icon(
                    Icons.search,
                    color: AppColors.iconColor,
                    size: 20,
                  ),
                  border: InputBorder.none,
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 14,
                  ),
                ),
                onTap: () {
                  // TODO: Navigate to search page
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
