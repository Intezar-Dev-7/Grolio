// features/onboarding/presentation/widgets/step_progress_indicator.dart

import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';

class StepProgressIndicator extends StatelessWidget {
  final int currentStep;
  final int totalSteps;

  const StepProgressIndicator({
    super.key,
    required this.currentStep,
    required this.totalSteps,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: List.generate(totalSteps, (index) {
        final isCompleted = index < currentStep;
        final isActive = index == currentStep - 1;

        return Expanded(
          child: Container(
            height: 4,
            margin: EdgeInsets.only(
              right: index < totalSteps - 1 ? 8 : 0,
            ),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(2),
              gradient: isCompleted || isActive
                  ? AppColors.primaryButtonGradient
                  : LinearGradient(
                colors: [
                  AppColors.borderColor,
                  AppColors.borderColor,
                ],
              ),
            ),
          ),
        );
      }),
    );
  }
}
