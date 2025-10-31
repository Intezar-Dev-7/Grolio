// features/create_post/presentation/widgets/tag_input_section.dart

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_typography.dart';
import '../bloc/create_post_bloc.dart';

class TagInputSection extends StatelessWidget {
  final TextEditingController controller;
  final Function(String) onTagAdded;

  const TagInputSection({
    super.key,
    required this.controller,
    required this.onTagAdded,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Tags',
          style: AppTypography.titleSmall.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 12),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          decoration: BoxDecoration(
            color: AppColors.surfaceDark,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: AppColors.borderColor,
              width: 1,
            ),
          ),
          child: Row(
            children: [
              const Icon(
                Icons.tag,
                color: AppColors.primaryGreen,
                size: 20,
              ),
              const SizedBox(width: 12),
              Expanded(
                child: TextField(
                  controller: controller,
                  style: AppTypography.bodyMedium,
                  decoration: InputDecoration(
                    hintText: 'Add tags (e.g., Flutter, React)',
                    hintStyle: AppTypography.bodyMedium.copyWith(
                      color: AppColors.textTertiary,
                    ),
                    border: InputBorder.none,
                  ),
                  onSubmitted: (value) {
                    if (value.trim().isNotEmpty) {
                      onTagAdded(value.trim().startsWith('#')
                          ? value.trim()
                          : '#${value.trim()}');
                    }
                  },
                ),
              ),
              IconButton(
                icon: const Icon(
                  Icons.add,
                  color: AppColors.primaryGreen,
                ),
                onPressed: () {
                  if (controller.text.trim().isNotEmpty) {
                    onTagAdded(controller.text.trim().startsWith('#')
                        ? controller.text.trim()
                        : '#${controller.text.trim()}');
                  }
                },
              ),
            ],
          ),
        ),
        const SizedBox(height: 12),
        BlocBuilder<CreatePostBloc, CreatePostState>(
          builder: (context, state) {
            if (state.tags.isEmpty) {
              return const SizedBox.shrink();
            }

            return Wrap(
              spacing: 8,
              runSpacing: 8,
              children: state.tags.map((tag) {
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
                        tag,
                        style: AppTypography.bodySmall.copyWith(
                          color: AppColors.primaryGreen,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(width: 6),
                      GestureDetector(
                        onTap: () {
                          context
                              .read<CreatePostBloc>()
                              .add(CreatePostTagRemoved(tag));
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
            );
          },
        ),
      ],
    );
  }
}
