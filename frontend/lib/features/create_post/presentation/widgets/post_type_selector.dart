// features/create_post/presentation/widgets/post_type_selector.dart

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_typography.dart';
import '../../domain/entities/create_post_entity.dart';
import '../bloc/create_post_bloc.dart';

class PostTypeSelector extends StatelessWidget {
  const PostTypeSelector({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CreatePostBloc, CreatePostState>(
      builder: (context, state) {
        return Container(
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
            children: [
              _buildTypeButton(
                context,
                'Post',
                Icons.article_outlined,
                PostType.post,
                state.postType == PostType.post,
              ),
              _buildTypeButton(
                context,
                'DevSnap',
                Icons.bolt_outlined,
                PostType.devSnap,
                state.postType == PostType.devSnap,
              ),
              _buildTypeButton(
                context,
                'Project',
                Icons.code_outlined,
                PostType.project,
                state.postType == PostType.project,
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildTypeButton(
      BuildContext context,
      String label,
      IconData icon,
      PostType type,
      bool isSelected,
      ) {
    return Expanded(
      child: GestureDetector(
        onTap: () {
          context.read<CreatePostBloc>().add(CreatePostTypeChanged(type));
        },
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 12),
          decoration: BoxDecoration(
            gradient:
            isSelected ? AppColors.primaryButtonGradient : null,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                icon,
                size: 18,
                color: isSelected ? Colors.white : AppColors.iconColor,
              ),
              const SizedBox(width: 6),
              Text(
                label,
                style: AppTypography.bodyMedium.copyWith(
                  color: isSelected ? Colors.white : AppColors.textSecondary,
                  fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
