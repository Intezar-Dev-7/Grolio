import 'package:flutter/material.dart';
import 'package:frontend/core/constants/app_assets.dart';
import '../../../../core/theme/app_colors.dart';

class AuthLogo extends StatelessWidget {
  const AuthLogo({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        width: 80,
        height: 80,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          gradient: AppColors.logoGradient,
          boxShadow: [
            BoxShadow(
              color: AppColors.primaryGreen.withOpacity(0.3),
              blurRadius: 24,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: Image.asset(AppAssets.grolioLogo),
      ),
    );
  }
}
