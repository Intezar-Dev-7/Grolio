// features/onboarding/presentation/pages/profile_setup_page.dart

import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:frontend/core/constants/app_assets.dart';
import 'package:frontend/core/router/app_router.dart';
import 'package:frontend/features/onboarding/presentation/widgets/step_progress_indicator.dart';
import 'package:image_picker/image_picker.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_typography.dart';
import '../bloc/profile_setup_bloc.dart';
import '../widgets/profile_image_picker.dart';
import '../widgets/tech_stack_selector.dart';
import '../widgets/social_links_input.dart';

class ProfileSetupPage extends StatefulWidget {
  const ProfileSetupPage({super.key});

  @override
  State<ProfileSetupPage> createState() => _ProfileSetupPageState();
}

class _ProfileSetupPageState extends State<ProfileSetupPage> {
  final TextEditingController _fullNameController = TextEditingController();
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _bioController = TextEditingController();
  final TextEditingController _techInputController = TextEditingController();

  final Map<String, TextEditingController> _socialControllers = {
    'github': TextEditingController(),
    'linkedin': TextEditingController(),
    'twitter': TextEditingController(),
    'instagram': TextEditingController(),
    'portfolio': TextEditingController(),
  };

  @override
  void dispose() {
    _fullNameController.dispose();
    _usernameController.dispose();
    _bioController.dispose();
    _techInputController.dispose();
    _socialControllers.forEach((_, controller) => controller.dispose());
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundDark,
        body: BlocConsumer<ProfileSetupBloc, ProfileSetupState>(
      listener: (context, state) {
        if (state.status == ProfileSetupStatus.success) {
          Navigator.pushNamedAndRemoveUntil(context, AppRouter.home,(route) => false,);
        } else if (state.status == ProfileSetupStatus.error) {
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
        if (state.status == ProfileSetupStatus.submitting) {
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
                                  'Step 3 of 3',
                                  style: AppTypography.bodySmall.copyWith(
                                    color: AppColors.textSecondary,
                                  ),
                                ),
                                Text(
                                  'Profile Setup',
                                  style: AppTypography.titleMedium.copyWith(
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),

                        const SizedBox(),
                      ],
                    ),

                    const SizedBox(height: 16),

                    // Progress bar
                    const StepProgressIndicator(
                      currentStep: 3,
                      totalSteps: 3,
                    ),
                  ],
                ),
              ),

              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Welcome text
                      Text(
                        'Welcome to Grolio!',
                        style: AppTypography.displaySmall.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Set up your developer profile to get started',
                        style: AppTypography.bodyMedium.copyWith(
                          color: AppColors.textSecondary,
                        ),
                      ),

                      const SizedBox(height: 32),

                      // Profile Image Picker
                      ProfileImagePicker(
                        onImagePicked: (image) {
                          context.read<ProfileSetupBloc>().add(
                            ProfileSetupImagePicked(image),
                          );
                        },
                      ),

                      const SizedBox(height: 32),

                      // Full Name
                      Text(
                        'Full Name *',
                        style: AppTypography.bodyMedium.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 8),
                      TextField(
                        controller: _fullNameController,
                        style: AppTypography.bodyMedium,
                        decoration: InputDecoration(
                          hintText: 'John Doe',
                          hintStyle: AppTypography.bodyMedium.copyWith(
                            color: AppColors.textTertiary,
                          ),
                          filled: true,
                          fillColor: AppColors.surfaceDark,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: const BorderSide(
                              color: AppColors.borderColor,
                              width: 1,
                            ),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: const BorderSide(
                              color: AppColors.borderColor,
                              width: 1,
                            ),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: const BorderSide(
                              color: AppColors.primaryGreen,
                              width: 1,
                            ),
                          ),
                          contentPadding: const EdgeInsets.all(16),
                        ),
                      ),

                      const SizedBox(height: 24),

                      // Username
                      Text(
                        'Username *',
                        style: AppTypography.bodyMedium.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 8),
                      BlocBuilder<ProfileSetupBloc, ProfileSetupState>(
                        builder: (context, state) {
                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              TextField(
                                controller: _usernameController,
                                style: AppTypography.bodyMedium,
                                onChanged: (value) {
                                  context.read<ProfileSetupBloc>().add(
                                    ProfileSetupUsernameChanged(value),
                                  );
                                },
                                decoration: InputDecoration(
                                  hintText: 'johndoe',
                                  hintStyle: AppTypography.bodyMedium.copyWith(
                                    color: AppColors.textTertiary,
                                  ),
                                  filled: true,
                                  fillColor: AppColors.surfaceDark,
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(12),
                                    borderSide: const BorderSide(
                                      color: AppColors.borderColor,
                                      width: 1,
                                    ),
                                  ),
                                  enabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(12),
                                    borderSide: BorderSide(
                                      color:
                                          state.isUsernameAvailable &&
                                                  _usernameController.text.length >= 3
                                              ? AppColors.success
                                              : AppColors.borderColor,
                                      width: 1,
                                    ),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(12),
                                    borderSide: const BorderSide(
                                      color: AppColors.primaryGreen,
                                      width: 1,
                                    ),
                                  ),
                                  contentPadding: const EdgeInsets.all(16),
                                  suffixIcon:
                                      state.status ==
                                              ProfileSetupStatus.checkingUsername
                                          ? const Padding(
                                            padding: EdgeInsets.all(12),
                                            child: SizedBox(
                                              width: 20,
                                              height: 20,
                                              child: CircularProgressIndicator(
                                                strokeWidth: 2,
                                                valueColor:
                                                    AlwaysStoppedAnimation<Color>(
                                                      AppColors.primaryGreen,
                                                    ),
                                              ),
                                            ),
                                          )
                                          : _usernameController.text.length >= 3
                                          ? Icon(
                                            state.isUsernameAvailable
                                                ? Icons.check_circle
                                                : Icons.cancel,
                                            color:
                                                state.isUsernameAvailable
                                                    ? AppColors.success
                                                    : AppColors.error,
                                          )
                                          : null,
                                ),
                              ),
                              const SizedBox(height: 6),
                              Text(
                                'Only lowercase letters, numbers, and underscores',
                                style: AppTypography.bodySmall.copyWith(
                                  color: AppColors.textTertiary,
                                  fontSize: 12,
                                ),
                              ),
                            ],
                          );
                        },
                      ),

                      const SizedBox(height: 24),

                      // Bio / Short Intro
                      Text(
                        'Bio / Short Intro',
                        style: AppTypography.bodyMedium.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 8),
                      TextField(
                        controller: _bioController,
                        maxLines: 4,
                        maxLength: 160,
                        style: AppTypography.bodyMedium,
                        decoration: InputDecoration(
                          hintText:
                              'Tell us about yourself... (e.g., Full-stack developer passionate about open source)',
                          hintStyle: AppTypography.bodyMedium.copyWith(
                            color: AppColors.textTertiary,
                          ),
                          filled: true,
                          fillColor: AppColors.surfaceDark,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: const BorderSide(
                              color: AppColors.borderColor,
                              width: 1,
                            ),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: const BorderSide(
                              color: AppColors.borderColor,
                              width: 1,
                            ),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: const BorderSide(
                              color: AppColors.primaryGreen,
                              width: 1,
                            ),
                          ),
                          contentPadding: const EdgeInsets.all(16),
                        ),
                      ),

                      const SizedBox(height: 24),

                      // Tech Stack / Skills
                      TechStackSelector(
                        controller: _techInputController,
                        onTechAdded: (tech) {
                          context.read<ProfileSetupBloc>().add(
                            ProfileSetupTechAdded(tech),
                          );
                          _techInputController.clear();
                        },
                      ),

                      const SizedBox(height: 32),

                      // Social Links
                      SocialLinksInput(controllers: _socialControllers),

                      const SizedBox(height: 16),

                      // Info message
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: AppColors.warning.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: AppColors.warning.withOpacity(0.3),
                            width: 1,
                          ),
                        ),
                        child: Row(
                          children: [
                            const Icon(
                              Icons.lightbulb_outline,
                              color: AppColors.warning,
                              size: 20,
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Text(
                                'You can always update your profile later from settings',
                                style: AppTypography.bodySmall.copyWith(
                                  color: AppColors.textSecondary,
                                  fontSize: 12,
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
              // Continue Button
              Padding(
                padding: const EdgeInsets.all(24),
                child: SizedBox(
                      width: double.infinity,
                      height: 52,
                      child: ElevatedButton(
                        onPressed:
                        state.status == ProfileSetupStatus.submitting
                            ? null
                            : () {
                          final socialLinks = <String, String>{};
                          _socialControllers.forEach((key, controller) {
                            if (controller.text.isNotEmpty) {
                              socialLinks[key] = controller.text;
                            }
                          });

                          context.read<ProfileSetupBloc>().add(
                            ProfileSetupSubmitted(
                              fullName: _fullNameController.text,
                              username: _usernameController.text,
                              bio: _bioController.text,
                              socialLinks: socialLinks,
                            ),
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primaryGreen,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          elevation: 0,
                        ),
                        child:
                        state.status == ProfileSetupStatus.submitting
                            ? const SizedBox(
                          width: 24,
                          height: 24,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            valueColor: AlwaysStoppedAnimation<Color>(
                              Colors.white,
                            ),
                          ),
                        )
                            : Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              'Continue to Dashboard',
                              style: AppTypography.bodyLarge.copyWith(
                                fontWeight: FontWeight.w600,
                                color: Colors.white,
                              ),
                            ),
                            const SizedBox(width: 8),
                            const Icon(
                              Icons.arrow_forward,
                              color: Colors.white,
                              size: 20,
                            ),
                          ],
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
