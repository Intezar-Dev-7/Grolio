// features/home/presentation/pages/main_screen.dart

import 'package:flutter/material.dart';
import '../../../../core/constants/app_assets.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../feed/presentation/pages/feed_page.dart';
import '../../../devsnaps/presentation/pages/devsnaps_page.dart';
import '../../../discover/presentation/pages/discover_page.dart';
import '../../../chat/presentation/pages/chat_page.dart';
import '../../../profile/presentation/pages/profile_page.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _currentIndex = 0;

  final List<Widget> _pages = [
    const FeedPage(),
    const DevSnapsPage(),
    const DiscoverPage(),
    const ChatPage(),
    const ProfilePage(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundDark,
      body: IndexedStack(index: _currentIndex, children: _pages),
      bottomNavigationBar: Container(
        decoration: const BoxDecoration(
          color: AppColors.surfaceDark,
          border: Border(
            top: BorderSide(color: AppColors.borderColor, width: 1),
          ),
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 2, vertical: 2),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildNavItem(
                  icon: AppAssets.homeIcon,
                  label: 'Feed',
                  index: 0,
                ),
                _buildNavItem(
                  icon: AppAssets.snapIcon,
                  label: 'DevSnaps',
                  index: 1,
                ),
                _buildNavItem(
                  icon: AppAssets.communityIcon,
                  label: 'Discover',
                  index: 2,
                ),
                _buildNavItem(
                  icon: AppAssets.chatIcon,
                  label: 'Chat',
                  index: 3,
                  showBadge: true,
                ),
                _buildNavItem(
                  icon: AppAssets.profileIcon,
                  label: 'Profile',
                  index: 4,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildNavItem({
    required String icon,
    required String label,
    required int index,
    bool showBadge = false,
  }) {
    final isSelected = _currentIndex == index;

    return GestureDetector(
      onTap: () {
        setState(() {
          _currentIndex = index;
        });
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color:
              isSelected
                  ? AppColors.primaryGreen.withOpacity(0.05)
                  : Colors.transparent,
          borderRadius: BorderRadius.circular(12),
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [AppColors.black90.withOpacity(0.1), AppColors.white90],
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Stack(
              children: [
                Image.asset(
                  icon,
                  width: 24,
                  height: 24,
                  color:
                      isSelected ? AppColors.primaryGreen : AppColors.iconColor,
                ),
                if (showBadge)
                  Positioned(
                    right: 0,
                    top: 0,
                    child: Container(
                      width: 8,
                      height: 8,
                      decoration: const BoxDecoration(
                        color: AppColors.error,
                        shape: BoxShape.circle,
                      ),
                    ),
                  ),
              ],
            ),
            const SizedBox(height: 4),
            Text(
              label,
              style: TextStyle(
                fontSize: 11,
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
                color:
                    isSelected
                        ? AppColors.primaryGreen
                        : AppColors.textSecondary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
