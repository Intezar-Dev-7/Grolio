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

class _MainScreenState extends State<MainScreen> with TickerProviderStateMixin {
  int _currentIndex = 0;
  late AnimationController _fabAnimationController;
  late Animation<double> _fabAnimation;

  final List<Widget> _pages = [
    const FeedPage(),
    const DiscoverPage(),
    const SizedBox.shrink(),
    const ChatPage(),
    const ProfilePage(),
  ];

  @override
  void initState() {
    super.initState();
    _fabAnimationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
    _fabAnimation = CurvedAnimation(
      parent: _fabAnimationController,
      curve: Curves.easeInOut,
    );
    _fabAnimationController.forward();
  }

  @override
  void dispose() {
    _fabAnimationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // ✅ Check if keyboard is visible
    final keyboardVisible = MediaQuery.of(context).viewInsets.bottom > 0;

    return Scaffold(
      backgroundColor: AppColors.backgroundDark,
      body: IndexedStack(
        index: _currentIndex,
        children: _pages,
      ),
      extendBody: true,
      // ✅ Hide FAB when keyboard is visible
      floatingActionButton: keyboardVisible
          ? null
          : ScaleTransition(
        scale: _fabAnimation,
        child: Container(
          width: 60,
          height: 60,
          decoration: BoxDecoration(
            gradient: AppColors.logoGradient,
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: AppColors.primaryGreen.withOpacity(0.3),
                blurRadius: 24,
                offset: const Offset(0, 8),
                spreadRadius: 0,
              ),
              BoxShadow(
                color: AppColors.primaryGreen.withOpacity(0.2),
                blurRadius: 12,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: () {
                _fabAnimationController.reverse().then((_) {
                  _fabAnimationController.forward();
                });
                Navigator.pushNamed(context, AppRouter.createPost);
              },
              customBorder: const CircleBorder(),
              child: const Icon(
                Icons.add_rounded,
                color: Colors.white,
                size: 32,
              ),
            ),
          ),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      // ✅ Hide bottom nav when keyboard is visible (optional)
      bottomNavigationBar: keyboardVisible ? null : _buildModernBottomNavBar(),
    );
  }

  Widget _buildModernBottomNavBar() {
    return Container(
      height: 85,
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      decoration: BoxDecoration(
        color: AppColors.surfaceDark,
        borderRadius: BorderRadius.circular(28),
        border: Border.all(
          color: AppColors.borderColor.withOpacity(0.5),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.3),
            blurRadius: 24,
            offset: const Offset(0, 8),
          ),
          BoxShadow(
            color: AppColors.primaryGreen.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(28),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            _buildModernNavItem(
              icon: AppAssets.homeIcon,
              label: 'Feed',
              index: 0,
            ),
            _buildModernNavItem(
              icon: AppAssets.snapIcon,
              label: 'Discover',
              index: 1,
            ),
            const SizedBox(width: 64),
            _buildModernNavItem(
              icon: AppAssets.chatIcon,
              label: 'Chat',
              index: 3,
            ),
            _buildModernNavItem(
              icon: AppAssets.profileIcon,
              label: 'Profile',
              index: 4,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildModernNavItem({
    required String icon,
    required String label,
    required int index,
  }) {
    final isActive = _currentIndex == index;

    return Expanded(
      child: GestureDetector(
        onTap: () {
          if (_currentIndex != index) {
            setState(() {
              _currentIndex = index;
            });
          }
        },
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeInOut,
          padding: const EdgeInsets.symmetric(vertical: 8),
          decoration: BoxDecoration(
            color: isActive
                ? AppColors.primaryGreen.withOpacity(0.1)
                : Colors.transparent,
            borderRadius: BorderRadius.circular(20),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              AnimatedScale(
                scale: isActive ? 1.1 : 1.0,
                duration: const Duration(milliseconds: 300),
                curve: Curves.easeInOut,
                child: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: isActive
                        ? AppColors.primaryGreen.withOpacity(0.15)
                        : Colors.transparent,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Image.asset(
                    icon,
                    color: isActive
                        ? AppColors.primaryGreen
                        : AppColors.iconColor,
                    width: 24,
                    height: 24,
                  ),
                ),
              ),
              const SizedBox(height: 4),
              AnimatedOpacity(
                opacity: isActive ? 1.0 : 0.6,
                duration: const Duration(milliseconds: 300),
                child: Text(
                  label,
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: isActive ? FontWeight.w700 : FontWeight.w500,
                    color: isActive
                        ? AppColors.primaryGreen
                        : AppColors.textTertiary,
                    letterSpacing: 0.5,
                  ),
                ),
              ),
              if (isActive)
                AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  margin: const EdgeInsets.only(top: 2),
                  width: 4,
                  height: 4,
                  decoration: BoxDecoration(
                    color: AppColors.primaryGreen,
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.primaryGreen.withOpacity(0.5),
                        blurRadius: 4,
                        spreadRadius: 1,
                      ),
                    ],
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
