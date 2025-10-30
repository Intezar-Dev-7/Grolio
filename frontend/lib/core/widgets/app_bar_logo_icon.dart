import 'package:flutter/material.dart';
import 'package:frontend/core/constants/app_assets.dart';
import 'package:frontend/core/theme/app_colors.dart';

class AppBarLogoIcon extends StatelessWidget {
  const AppBarLogoIcon({super.key});
  
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 32,
      height: 32,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        gradient: AppColors.logoGradient,
      ),
      child: Image.asset(AppAssets.grolioLogo)
    );
  }
}
