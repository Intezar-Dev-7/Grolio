// features/user_details/presentation/widgets/user_actions_section.dart

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_typography.dart';
import '../../domain/entities/user_details_entity.dart';
import '../bloc/user_details_bloc.dart';

class UserActionsSection extends StatelessWidget {
  final UserDetailsEntity user;

  const UserActionsSection({
    super.key,
    required this.user,
  });

  @override
  Widget build(BuildContext context) {
    return Transform.translate(
      offset: const Offset(0, -20),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Row(
          children: [
            // Follow Button
            Expanded(
              flex: 2,
              child: SizedBox(
                height: 48,
                child: ElevatedButton(
                  onPressed: () {
                    context
                        .read<UserDetailsBloc>()
                        .add(const UserDetailsFollowToggled());
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: user.isFollowing
                        ? AppColors.surfaceDark
                        : AppColors.primaryGreen,
                    foregroundColor:
                    user.isFollowing ? AppColors.textPrimary : Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                      side: BorderSide(
                        color: user.isFollowing
                            ? AppColors.borderColor
                            : AppColors.primaryGreen,
                        width: 1,
                      ),
                    ),
                    elevation: 0,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        user.isFollowing ? Icons.check : Icons.person_add,
                        size: 20,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        user.isFollowing ? 'Following' : 'Follow',
                        style: AppTypography.bodyMedium.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),

            const SizedBox(width: 12),

            // Message Button
            Expanded(
              child: SizedBox(
                height: 48,
                child: ElevatedButton(
                  onPressed: () {
                    // TODO: Navigate to chat conversation
                    Navigator.pop(context);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.surfaceDark,
                    foregroundColor: AppColors.primaryGreen,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                      side: BorderSide(
                        color: AppColors.primaryGreen.withOpacity(0.3),
                        width: 1,
                      ),
                    ),
                    elevation: 0,
                  ),
                  child: const Icon(
                    Icons.chat_bubble_outline,
                    size: 20,
                  ),
                ),
              ),
            ),

            const SizedBox(width: 12),

            // Call Button
            SizedBox(
              width: 48,
              height: 48,
              child: ElevatedButton(
                onPressed: () {
                  // TODO: Implement call
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.surfaceDark,
                  foregroundColor: AppColors.primaryBlue,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                    side: BorderSide(
                      color: AppColors.primaryBlue.withOpacity(0.3),
                      width: 1,
                    ),
                  ),
                  padding: EdgeInsets.zero,
                  elevation: 0,
                ),
                child: const Icon(
                  Icons.call,
                  size: 20,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
