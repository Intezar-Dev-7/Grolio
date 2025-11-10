// features/onboarding/presentation/widgets/tech_stack_selector.dart

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_typography.dart';
import '../bloc/profile_setup_bloc.dart';

class TechStackSelector extends StatelessWidget {
  final TextEditingController controller;
  final Function(String) onTechAdded;

  const TechStackSelector({
    super.key,
    required this.controller,
    required this.onTechAdded,
  });

  final List<String> popularTechs = const [
    '#React',
    '#Vue',
    '#Angular',
    '#TypeScript',
    '#JavaScript',
    '#Python',
    '#Java',
    '#Golang',
  ];

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Tech Stack / Skills',
          style: AppTypography.bodyMedium.copyWith(fontWeight: FontWeight.w600),
        ),
        const SizedBox(height: 12),

        // Selected tech chips
        BlocBuilder<ProfileSetupBloc, ProfileSetupState>(
          builder: (context, state) {
            if (state.techStack.isEmpty) {
              return const SizedBox.shrink();
            }

            return Column(
              children: [
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children:
                      state.techStack.map((tech) {
                        return Container(
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
                              Text(
                                tech,
                                style: AppTypography.bodySmall.copyWith(
                                  color: AppColors.primaryGreen,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              const SizedBox(width: 6),
                              GestureDetector(
                                onTap: () {
                                  context.read<ProfileSetupBloc>().add(
                                    ProfileSetupTechRemoved(tech),
                                  );
                                },
                                child: const Icon(
                                  Icons.close,
                                  size: 16,
                                  color: AppColors.primaryGreen,
                                ),
                              ),
                            ],
                          ),
                        );
                      }).toList(),
                ),
                const SizedBox(height: 12),
              ],
            );
          },
        ),

        // Popular tech chips
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children:
              popularTechs.map((tech) {
                return BlocBuilder<ProfileSetupBloc, ProfileSetupState>(
                  builder: (context, state) {
                    final isSelected = state.techStack.contains(tech);
                    return GestureDetector(
                      onTap: () {
                        if (isSelected) {
                          context.read<ProfileSetupBloc>().add(
                            ProfileSetupTechRemoved(tech),
                          );
                        } else {
                          onTechAdded(tech);
                        }
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 8,
                        ),
                        decoration: BoxDecoration(
                          color:
                              isSelected
                                  ? AppColors.primaryGreen.withOpacity(0.15)
                                  : AppColors.surfaceDark,
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(
                            color:
                                isSelected
                                    ? AppColors.primaryGreen.withOpacity(0.3)
                                    : AppColors.borderColor,
                            width: 1,
                          ),
                        ),
                        child: Text(
                          tech,
                          style: AppTypography.bodySmall.copyWith(
                            color:
                                isSelected
                                    ? AppColors.primaryGreen
                                    : AppColors.textSecondary,
                            fontWeight:
                                isSelected
                                    ? FontWeight.w500
                                    : FontWeight.normal,
                          ),
                        ),
                      ),
                    );
                  },
                );
              }).toList(),
        ),

        const SizedBox(height: 12),

        // Custom input
        Row(
          children: [
            Expanded(
              child: TextField(
                controller: controller,
                style: AppTypography.bodyMedium,
                decoration: InputDecoration(
                  hintText: 'Add custom skill...',
                  hintStyle: AppTypography.bodyMedium.copyWith(
                    color: AppColors.textTertiary,
                  ),
                  filled: true,
                  fillColor: AppColors.surfaceDark,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(
                      color: AppColors.borderColor,
                      width: 1,
                    ),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(
                      color: AppColors.borderColor,
                      width: 1,
                    ),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(
                      color: AppColors.primaryGreen,
                      width: 1,
                    ),
                  ),
                  contentPadding: const EdgeInsets.all(16),
                ),
                onSubmitted: (value) {
                  if (value.trim().isNotEmpty) {
                    onTechAdded(
                      value.trim().startsWith('#')
                          ? value.trim()
                          : '#${value.trim()}',
                    );
                  }
                },
              ),
            ),
            const SizedBox(width: 8),
            SizedBox(
              width: 52,
              height: 52,
              child: ElevatedButton(
                onPressed: () {
                  if (controller.text.trim().isNotEmpty) {
                    onTechAdded(
                      controller.text.trim().startsWith('#')
                          ? controller.text.trim()
                          : '#${controller.text.trim()}',
                    );
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primaryGreen,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  padding: EdgeInsets.zero,
                  elevation: 0,
                ),
                child: const Text(
                  'Add',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
