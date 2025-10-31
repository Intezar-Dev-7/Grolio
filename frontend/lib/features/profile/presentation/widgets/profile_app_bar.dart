import 'package:flutter/material.dart';
import 'package:frontend/core/constants/app_assets.dart';
import 'package:frontend/core/theme/app_colors.dart';
import 'package:frontend/core/theme/app_typography.dart';
import 'package:frontend/core/widgets/app_bar_logo_icon.dart';
import 'package:frontend/features/profile/presentation/pages/profile_page.dart';

class ProfileAppBar extends StatelessWidget {
  const ProfileAppBar({
    super.key,
    required this.widget,
  });

  final ProfilePage? widget;

  @override
  Widget build(BuildContext context) {
    return SliverAppBar(
      floating: true,
      snap: true,
      automaticallyImplyLeading: false,
      backgroundColor: AppColors.backgroundDark,
      elevation: 0,
      leading: widget!.userId != null
          ? IconButton(
        icon: const Icon(
          Icons.arrow_back_ios_new_rounded,
          color: AppColors.iconColor,
        ),
        onPressed: () => Navigator.pop(context),
      )
          : null,
      title: Row(
        children: [
          const AppBarLogoIcon(),
          const SizedBox(width: 12),
          Text(
            'Profile',
            style: AppTypography.headlineMedium.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
      actions: [
        IconButton(
          icon: Image.asset(
            AppAssets.searchIcon,
            color: AppColors.iconColor,
            width: 20,
            height: 20,
          ),
          onPressed: () {},
        ),
        Stack(
          children: [
            IconButton(
              icon: Image.asset(
                AppAssets.notificationIcon,
                color: AppColors.iconColor,
                width: 22,
                height: 22,
              ),
              onPressed: () {},
            ),
            Positioned(
              right: 8,
              top: 6,
              child: Container(
                padding: const EdgeInsets.all(2),
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
        IconButton(
          icon: const Icon(
            Icons.filter_list,
            color: AppColors.iconColor,
          ),
          onPressed: () {},
        ),
        const SizedBox(width: 4),
      ],
    );
  }
}