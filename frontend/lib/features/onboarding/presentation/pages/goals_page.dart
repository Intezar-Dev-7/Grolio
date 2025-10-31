// features/onboarding/presentation/pages/goals_page.dart

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:frontend/core/router/app_router.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_typography.dart';
import '../bloc/goals_bloc.dart';
import '../widgets/goal_card.dart';
import '../widgets/selected_count_badge.dart';
import '../widgets/step_progress_indicator.dart';
import '../widgets/celebration_message.dart';

class GoalsPage extends StatelessWidget {
  const GoalsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => GoalsBloc()..add(const GoalsInitialized()),
      child: const GoalsView(),
    );
  }
}

class GoalsView extends StatelessWidget {
  const GoalsView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundDark,
      body: BlocConsumer<GoalsBloc, GoalsState>(
        listener: (context, state) {
          if (state.status == GoalsStatus.success) {
            Navigator.pushReplacementNamed(context, AppRouter.home);
          } else if (state.status == GoalsStatus.error) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.errorMessage ?? 'An error occurred'),
                backgroundColor: AppColors.error,
                behavior: SnackBarBehavior.floating,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            );
          }
        },
        builder: (context, state) {
          if (state.status == GoalsStatus.loading) {
            return const Center(
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(
                  AppColors.primaryGreen,
                ),
              ),
            );
          }

          return SafeArea(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Header Section
                Padding(
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      // Logo and step text
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              Container(
                                width: 40,
                                height: 40,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(15),
                                  gradient: const LinearGradient(
                                    begin: AlignmentGeometry.topLeft,
                                    end: AlignmentGeometry.bottomRight,
                                    colors: [
                                      AppColors.primaryGreen,
                                      AppColors.primaryBlue,
                                    ],
                                  ),
                                ),
                                child: const Center(
                                  child: Icon(
                                    Icons.track_changes,
                                    color: Colors.white,
                                    size: 24,
                                  ),
                                ),
                              ),
                              const SizedBox(width: 12),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Step 2 of 2',
                                    style: AppTypography.bodySmall.copyWith(
                                      color: AppColors.textSecondary,
                                    ),
                                  ),
                                  Text(
                                    'Your Goals',
                                    style: AppTypography.titleMedium.copyWith(
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                          TextButton(
                            onPressed: () {
                              context.read<GoalsBloc>().add(
                                    const GoalsSkipped(),
                                  );
                            },
                            child: Text(
                              'Skip',
                              style: AppTypography.labelMedium.copyWith(
                                color: AppColors.textSecondary,
                              ),
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 16),

                      // Progress bar
                      const StepProgressIndicator(
                        currentStep: 2,
                        totalSteps: 2,
                      ),
                    ],
                  ),
                ),

                // Content Section
                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 8),

                        // Title
                        const Text(
                          'What Are Your Goals?',
                          style: AppTypography.displaySmall,
                        ),

                        const SizedBox(height: 12),

                        // Subtitle
                        Text(
                          'Choose what you want to achieve. We\'ll help you track your progress and stay motivated.',
                          style: AppTypography.subtitle.copyWith(height: 1.5),
                        ),

                        const SizedBox(height: 24),

                        // Selected count badge
                        Center(
                          child: SelectedCountBadge(count: state.selectedCount),
                        ),

                        const SizedBox(height: 24),

                        // Goals cards
                        ...state.availableGoals.map((goal) {
                          final isSelected = state.isGoalSelected(goal.id);
                          return Padding(
                            padding: const EdgeInsets.only(bottom: 16),
                            child: GoalCard(
                              goal: goal,
                              isSelected: isSelected,
                              onTap: () {
                                context.read<GoalsBloc>().add(
                                  GoalToggled(goal.id),
                                );
                              },
                            ),
                          );
                        }),

                        const SizedBox(height: 16),

                        // Celebration message (shows when goals selected)
                        if (state.selectedCount > 0)
                          CelebrationMessage(count: state.selectedCount),

                        const SizedBox(height: 16),

                        // Info message
                        Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: AppColors.surfaceDark,
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                              color: AppColors.borderColor,
                              width: 1,
                            ),
                          ),
                          child: Row(
                            children: [
                              const Icon(
                                Icons.lightbulb_outline,
                                color: Color(0xFFFFA726),
                                size: 20,
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Text(
                                  'Track your progress, earn achievements, and compete on leaderboards',
                                  style: AppTypography.bodySmall.copyWith(
                                    color: AppColors.textSecondary,
                                    height: 1.4,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),

                        const SizedBox(height: 32),
                      ],
                    ),
                  ),
                ),

                // Bottom button
                Padding(
                  padding: const EdgeInsets.all(24),
                  child: Container(
                    width: double.infinity,
                    height: 52,
                    decoration: BoxDecoration(
                      gradient:
                          state.canComplete
                              ? const LinearGradient(
                                begin: Alignment.centerLeft,
                                end: Alignment.centerRight,
                                colors: [
                                  AppColors.primaryGreen,
                                  AppColors.primaryBlue,
                                ],
                              )
                              : LinearGradient(
                                colors: [
                                  AppColors.buttonDisabled,
                                  AppColors.buttonDisabled.withOpacity(0.8),
                                ],
                              ),
                      borderRadius: BorderRadius.circular(12),
                      boxShadow:
                          state.canComplete
                              ? [
                                BoxShadow(
                                  color: const Color(
                                    0xFF4CAF93,
                                  ).withOpacity(0.3),
                                  blurRadius: 12,
                                  offset: const Offset(0, 4),
                                ),
                              ]
                              : null,
                    ),
                    child: Material(
                      color: Colors.transparent,
                      child: InkWell(
                        onTap:
                            state.canComplete &&
                                    state.status != GoalsStatus.submitting
                                ? () {
                                  context.read<GoalsBloc>().add(
                                    const GoalsSubmitted(),
                                  );
                                }
                                : null,
                        borderRadius: BorderRadius.circular(12),
                        child: Center(
                          child:
                              state.status == GoalsStatus.submitting
                                  ? const SizedBox(
                                    height: 20,
                                    width: 20,
                                    child: CircularProgressIndicator(
                                      strokeWidth: 2.5,
                                      valueColor: AlwaysStoppedAnimation<Color>(
                                        Colors.white,
                                      ),
                                    ),
                                  )
                                  : Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Text(
                                        'Complete Setup',
                                        style: TextStyle(
                                          fontFamily: 'Inter',
                                          fontSize: 15,
                                          fontWeight: FontWeight.w600,
                                          color:
                                              state.canComplete
                                                  ? Colors.white
                                                  : AppColors
                                                      .buttonDisabledText,
                                          letterSpacing: 0.3,
                                        ),
                                      ),
                                      const SizedBox(width: 8),
                                      Icon(
                                        Icons.navigate_next_rounded,
                                        color:
                                            state.canComplete
                                                ? Colors.white
                                                : AppColors.buttonDisabledText,
                                        size: 20,
                                      ),
                                    ],
                                  ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
