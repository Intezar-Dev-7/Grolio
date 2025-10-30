// features/discover/presentation/pages/discover_page.dart

import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';

class DiscoverPage extends StatelessWidget {
  const DiscoverPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: AppColors.backgroundDark,
      body: Center(
        child: Text(
          'Discover Page',
          style: TextStyle(color: Colors.white),
        ),
      ),
    );
  }
}
