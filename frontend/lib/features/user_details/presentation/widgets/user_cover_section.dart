// features/user_details/presentation/widgets/user_cover_section.dart

import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../../../core/theme/app_colors.dart';
import '../../domain/entities/user_details_entity.dart';

class UserCoverSection extends StatelessWidget {
  final UserDetailsEntity user;

  const UserCoverSection({
    super.key,
    required this.user,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      fit: StackFit.expand,
      children: [
        // Cover Image
        if (user.coverImage != null)
          CachedNetworkImage(
            imageUrl: user.coverImage!,
            fit: BoxFit.cover,
            placeholder: (context, url) => Container(
              color: AppColors.surfaceDark,
            ),
            errorWidget: (context, url, error) => Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    AppColors.primaryGreen.withOpacity(0.3),
                    AppColors.primaryBlue.withOpacity(0.3),
                  ],
                ),
              ),
            ),
          )
        else
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  AppColors.primaryGreen.withOpacity(0.3),
                  AppColors.primaryBlue.withOpacity(0.3),
                ],
              ),
            ),
          ),

        // Gradient overlay
        Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Colors.transparent,
                Colors.black.withOpacity(0.7),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
