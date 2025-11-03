// core/presentation/main_screen.dart

import 'package:flutter/material.dart';
import 'package:frontend/core/constants/app_assets.dart';
import 'package:frontend/core/router/app_router.dart';
import 'package:frontend/core/theme/app_colors.dart';
import 'package:frontend/features/chat/presentation/pages/chat_page.dart';
import 'package:frontend/features/discover/presentation/pages/discover_page.dart';
import 'package:frontend/features/feed/presentation/pages/feed_page.dart';
import 'package:frontend/features/profile/presentation/pages/profile_page.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _currentIndex = 0;

  final List<Widget> _pages = [
    const FeedPage(),
    const DiscoverPage(),
    const SizedBox.shrink(), // Placeholder for FAB
    const ChatPage(),
    const ProfilePage(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundDark,
      body: IndexedStack(
        index: _currentIndex,
        children: _pages,
      ),
      floatingActionButton: Container(
        width: 54,
        height: 54,
        decoration: BoxDecoration(
          gradient: AppColors.logoGradient,
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
              color: AppColors.primaryGreen.withOpacity(0.4),
              blurRadius: 20,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: () {
              Navigator.pushNamed(
                context,
                AppRouter.createPost
              );
            },
            customBorder: const CircleBorder(),
            child: const Icon(
              Icons.add,
              color: Colors.white,
              size: 32,
            ),
          ),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      // ✅ Bottom Navigation Bar with notch
      bottomNavigationBar: _buildBottomNavBar(),
    );
  }

  Widget _buildBottomNavBar() {
    return Container(
      decoration: const BoxDecoration(
        color: AppColors.surfaceDark,
        border: Border(
          top: BorderSide(
            color: AppColors.borderColor,
            width: 1,
          ),
        ),
      ),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 8),
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
                label: 'Discover',
                index: 1,
              ),
              // ✅ Empty space for FAB
              const SizedBox(width: 54),
              _buildNavItem(
                icon: AppAssets.chatIcon,
                label: 'Chat',
                index: 3,
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
    );
  }

  Widget _buildNavItem({
    required String icon,
    required String label,
    required int index,
  }) {
    final isActive = _currentIndex == index;

    return InkWell(
      onTap: () {
        setState(() {
          _currentIndex = index;
        });
      },
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Image.asset(
              icon,
              color: isActive ? AppColors.primaryGreen : AppColors.iconColor,
              width: 20,
              height: 20,
            ),
            const SizedBox(height: 4),
            Text(
              label,
              style: TextStyle(
                fontSize: 11,
                fontWeight: isActive ? FontWeight.w600 : FontWeight.w500,
                color: isActive
                    ? AppColors.primaryGreen
                    : AppColors.textTertiary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
