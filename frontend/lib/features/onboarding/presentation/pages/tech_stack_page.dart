// features/onboarding/presentation/pages/tech_stack_page.dart

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:frontend/core/router/app_router.dart';
import 'package:frontend/core/constants/app_assets.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_typography.dart';
import '../bloc/tech_stack_bloc.dart';
import '../widgets/tech_stack_chip.dart';
import '../widgets/selected_count_badge.dart';
import '../widgets/step_progress_indicator.dart';

class TechStackPage extends StatelessWidget {
  const TechStackPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => TechStackBloc()
        ..add(const TechStacksInitialized()),
      child: const TechStackView(),
    );
  }
}

class TechStackView extends StatelessWidget {
  const TechStackView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundDark,
      body: BlocConsumer<TechStackBloc, TechStackState>(
        listener: (context, state) {
          if (state.status == TechStackStatus.success) {
            Navigator.pushReplacementNamed(context, AppRouter.goals);
          } else if (state.status == TechStackStatus.error) {
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
          if (state.status == TechStackStatus.loading) {
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
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Step indicator and skip button
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          // Logo and step text
                          Row(
                            children: [
                              Container(
                                width: 40,
                                height: 40,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  gradient: AppColors.logoGradient,
                                ),
                                child: Center(
                                  child: Image.asset(AppAssets.grolioLogo)
                                ),
                              ),
                              const SizedBox(width: 12),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Step 1 of 3',
                                    style: AppTypography.bodySmall.copyWith(
                                      color: AppColors.textSecondary,
                                    ),
                                  ),
                                  Text(
                                    'Tech Stack',
                                    style: AppTypography.titleMedium.copyWith(
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),

                          // Skip button
                          TextButton(
                            onPressed: () {
                              context.read<TechStackBloc>().add(
                                const TechStacksSkipped(),
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
                        currentStep: 1,
                        totalSteps: 3,
                      ),
                    ],
                  ),
                ),

                // Content Section
                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        const SizedBox(height: 8),

                        // Title
                        const Text(
                          'Choose Your Tech Stack',
                          style: AppTypography.displaySmall,
                        ),

                        const SizedBox(height: 12),

                        // Subtitle
                        Text(
                          'Select the technologies you work with or want to learn. We\'ll personalize your feed.',
                          textAlign: TextAlign.center,
                          style: AppTypography.subtitle.copyWith(
                            height: 1.5,
                          ),
                        ),

                        const SizedBox(height: 24),

                        // Selected count badge
                        Center(
                          child: SelectedCountBadge(
                            count: state.selectedCount,
                          ),
                        ),

                        const SizedBox(height: 24),

                        // Tech stack grid
                        Wrap(
                          spacing: 12,
                          runSpacing: 12,
                          children: state.availableTechStacks.map((tech) {
                            return TechStackChip(
                              techStack: tech,
                              isSelected: state.isTechSelected(tech.id),
                              onTap: () {
                                context.read<TechStackBloc>().add(
                                  TechStackToggled(tech.id),
                                );
                              },
                            );
                          }).toList(),
                        ),

                        const SizedBox(height: 32),

                        // Info note
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
                              Icon(
                                Icons.info_outline,
                                color: AppColors.info.withOpacity(0.8),
                                size: 20,
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Text(
                                  'You can always add or remove tech stacks later from your profile settings',
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
                      gradient: state.selectedCount > 0
                          ? AppColors.primaryButtonGradient
                          : AppColors.disabledButtonGradient,
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: state.selectedCount > 0
                          ? [
                        BoxShadow(
                          color:
                          AppColors.primaryGreen.withOpacity(0.3),
                          blurRadius: 12,
                          offset: const Offset(0, 4),
                        ),
                      ]
                          : null,
                    ),
                    child: Material(
                      color: Colors.transparent,
                      child: InkWell(
                        onTap: state.selectedCount > 0 &&
                            state.status != TechStackStatus.submitting
                            ? () {
                          context.read<TechStackBloc>().add(
                            const TechStacksSubmitted(),
                          );
                        }
                            : null,
                        borderRadius: BorderRadius.circular(12),
                        child: Center(
                          child: state.status == TechStackStatus.submitting
                              ? const SizedBox(
                            height: 20,
                            width: 20,
                            child: CircularProgressIndicator(
                              strokeWidth: 2.5,
                              valueColor:
                              AlwaysStoppedAnimation<Color>(
                                Colors.white,
                              ),
                            ),
                          )
                              : Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                'Continue',
                                style: TextStyle(
                                  fontFamily: 'Inter',
                                  fontSize: 15,
                                  fontWeight: FontWeight.w600,
                                  color: state.selectedCount > 0
                                      ? Colors.white
                                      : AppColors.buttonDisabledText,
                                  letterSpacing: 0.3,
                                ),
                              ),
                              const SizedBox(width: 8),
                              Icon(
                                Icons.navigate_next_rounded,
                                color: state.selectedCount > 0
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
