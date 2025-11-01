// features/onboarding/presentation/widgets/profile_image_picker.dart

import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import '../../../../core/theme/app_colors.dart';
import '../bloc/profile_setup_bloc.dart';

class ProfileImagePicker extends StatelessWidget {
  final Function(XFile) onImagePicked;

  const ProfileImagePicker({
    super.key,
    required this.onImagePicked,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: BlocBuilder<ProfileSetupBloc, ProfileSetupState>(
        builder: (context, state) {
          return Stack(
            children: [
              // Avatar circle
              Container(
                width: 120,
                height: 120,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: AppColors.surfaceDark,
                  border: Border.all(
                    color: AppColors.borderColor,
                    width: 2,
                  ),
                ),
                child: state.selectedImage != null
                    ? ClipOval(
                  child: Image.file(
                    File(state.selectedImage!.path),
                    fit: BoxFit.cover,
                  ),
                )
                    : Icon(
                  Icons.person_outline,
                  size: 50,
                  color: AppColors.iconColor,
                ),
              ),

              // Upload button
              Positioned(
                bottom: 0,
                right: 0,
                child: GestureDetector(
                  onTap: () async {
                    final ImagePicker picker = ImagePicker();
                    final XFile? image = await picker.pickImage(
                      source: ImageSource.gallery,
                      maxWidth: 512,
                      maxHeight: 512,
                      imageQuality: 85,
                    );

                    if (image != null) {
                      onImagePicked(image);
                    }
                  },
                  child: Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      gradient: AppColors.primaryButtonGradient,
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: AppColors.backgroundDark,
                        width: 3,
                      ),
                    ),
                    child: state.status == ProfileSetupStatus.uploadingImage
                        ? const Padding(
                      padding: EdgeInsets.all(8),
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        valueColor: AlwaysStoppedAnimation<Color>(
                          Colors.white,
                        ),
                      ),
                    )
                        : const Icon(
                      Icons.add,
                      color: Colors.white,
                      size: 24,
                    ),
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
