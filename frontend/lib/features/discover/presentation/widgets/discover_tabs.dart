// features/discover/presentation/widgets/discover_tabs.dart

import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_typography.dart';

class DiscoverTabs extends StatefulWidget {
  const DiscoverTabs({super.key});

  @override
  State<DiscoverTabs> createState() => _DiscoverTabsState();
}

class _DiscoverTabsState extends State<DiscoverTabs> {
  int _selectedIndex = 0;

  final List<Map<String, dynamic>> _tabs = [
    {'icon': Icons.code, 'label': 'Projects'},
    {'icon': Icons.event, 'label': 'Events'},
  ];

  @override
  Widget build(BuildContext context) {
    return SliverToBoxAdapter(
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        padding: const EdgeInsets.all(4),
        decoration: BoxDecoration(
          color: AppColors.surfaceDark,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: AppColors.borderColor,
            width: 1,
          ),
        ),
        child: Row(
          children: List.generate(_tabs.length, (index) {
            final isSelected = _selectedIndex == index;
            final tab = _tabs[index];

            return Expanded(
              child: GestureDetector(
                onTap: () {
                  setState(() {
                    _selectedIndex = index;
                  });
                },
                child: Container(
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  decoration: BoxDecoration(
                    gradient: isSelected
                        ? AppColors.primaryButtonGradient
                        : null,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        tab['icon'] as IconData,
                        size: 16,
                        color: isSelected
                            ? Colors.white
                            : AppColors.iconColor,
                      ),
                      const SizedBox(width: 6),
                      Text(
                        tab['label'] as String,
                        style: AppTypography.bodySmall.copyWith(
                          color: isSelected
                              ? Colors.white
                              : AppColors.textSecondary,
                          fontWeight:
                          isSelected ? FontWeight.w600 : FontWeight.w500,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          }),
        ),
      ),
    );
  }
}
