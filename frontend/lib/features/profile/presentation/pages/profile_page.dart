// features/profile/presentation/pages/profile_page.dart

import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: AppColors.backgroundDark,
      body: Center(
        child: Text(
          'Profile Page',
          style: TextStyle(color: Colors.white),
        ),
      ),
    );
  }
}
