// features/discover/presentation/widgets/tech_filter_section.dart

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_typography.dart';
import '../bloc/discover_bloc.dart';

class TechFilterSection extends StatelessWidget {
  const TechFilterSection({super.key});

  @override
  Widget build(BuildContext context) {
    final availableTechs = [
      'All',
      '#React',
      '#TypeScript',
      '#Python',
      '#Flutter',
      '#NodeJS',
      '#Docker',
      '#AWS',
      '#Kubernetes',
    ];

    return SliverToBoxAdapter(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Row(
              children: [
                const Icon(
                  Icons.tune,
                  color: AppColors.iconColor,
                  size: 16,
                ),
                const SizedBox(width: 8),
                Text(
                  'Filter by Tech Stack:',
                  style: AppTypography.bodySmall.copyWith(
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),
          BlocBuilder<DiscoverBloc, DiscoverState>(
            builder: (context, state) {
              return SizedBox(
                height: 40,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  itemCount: availableTechs.length,
                  itemBuilder: (context, index) {
                    final tech = availableTechs[index];
                    final isAll = tech == 'All';
                    final isSelected = isAll
                        ? state.selectedTechFilters.isEmpty
                        : state.selectedTechFilters.contains(tech);

                    return Padding(
                      padding: const EdgeInsets.only(right: 8),
                      child: GestureDetector(
                        onTap: () {
                          if (isAll) {
                            context
                                .read<DiscoverBloc>()
                                .add(const DiscoverTechFilterCleared());
                          } else {
                            context
                                .read<DiscoverBloc>()
                                .add(DiscoverTechFilterToggled(tech));
                          }
                        },
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 8,
                          ),
                          decoration: BoxDecoration(
                            color: isSelected
                                ? AppColors.primaryGreen
                                : AppColors.surfaceDark,
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(
                              color: isSelected
                                  ? AppColors.primaryGreen
                                  : AppColors.borderColor,
                              width: 1,
                            ),
                          ),
                          child: Text(
                            tech,
                            style: AppTypography.bodySmall.copyWith(
                              color: isSelected
                                  ? Colors.white
                                  : AppColors.textPrimary,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                ),
              );
            },
          ),
          const SizedBox(height: 16),
        ],
      ),
    );
  }
}
