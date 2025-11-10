import 'package:flutter/material.dart';
import 'package:frontend/core/constants/app_assets.dart';
import 'package:frontend/core/router/app_router.dart';
import 'package:frontend/core/theme/app_colors.dart';
import 'package:frontend/core/theme/app_typography.dart';
import 'package:frontend/core/widgets/notification_badge.dart';
import 'package:frontend/features/profile/presentation/pages/profile_page.dart';

class ProfileAppBar extends StatelessWidget {
  const ProfileAppBar({super.key, required this.widget});

  final ProfilePage? widget;

  @override
  Widget build(BuildContext context) {
    return SliverAppBar(
      floating: true,
      snap: true,
      automaticallyImplyLeading: false,
      backgroundColor: AppColors.backgroundDark,
      elevation: 0,
      centerTitle: false,
      title: Text(
        'Profile',
        style: AppTypography.headlineMedium.copyWith(
          fontWeight: FontWeight.bold,
        ),
      ),
      actions: [
        InkWell(
          onTap: () {
            Navigator.pushNamed(context, AppRouter.notifications);
          },
          child: NotificationBadge(
            child: Image.asset(
              AppAssets.notificationIcon,
              height: 22,
              width: 22,
              color: AppColors.iconActive,
            ),
          ),
        ),
        /*BlocBuilder<NotificationBloc, NotificationState>(
          builder: (context, state) {
            if (state.unreadCount > 0) {
              return Stack(
                children: [
                  IconButton(
                    onPressed: () {
                      Navigator.pushNamed(context, AppRouter.notifications);
                    },
                    icon: Image.asset(
                      AppAssets.notificationIcon,
                      width: 24,
                      height: 24,
                      color: AppColors.iconActive,
                    ),
                  ),
                  Positioned(
                    right: 0,
                    top: -6,
                    child: Container(
                      padding: const EdgeInsets.all(4),
                      margin: const EdgeInsets.all(8),
                      decoration: const BoxDecoration(
                        color: AppColors.error,
                        shape: BoxShape.circle,
                      ),
                      constraints: const BoxConstraints(
                        minWidth: 16,
                        minHeight: 16,
                      ),
                      child: Text(
                        state.unreadCount > 9 ? '9+' : '${state.unreadCount}',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                ],
              );
            }
            return const SizedBox.shrink();
          },
        ),*/
        IconButton(
          icon: const Icon(Icons.more_vert, color: AppColors.iconColor),
          onPressed: () {},
        ),
        const SizedBox(width: 4),
      ],
    );
  }
}
