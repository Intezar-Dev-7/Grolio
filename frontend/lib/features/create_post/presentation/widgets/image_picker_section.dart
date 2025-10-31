// features/create_post/presentation/widgets/image_picker_section.dart

import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_typography.dart';
import '../bloc/create_post_bloc.dart';

class ImagePickerSection extends StatelessWidget {
  final Function(XFile) onImagePicked;

  const ImagePickerSection({
    super.key,
    required this.onImagePicked,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CreatePostBloc, CreatePostState>(
      builder: (context, state) {
        if (state.selectedImage != null) {
          return _buildImagePreview(context, state.selectedImage!);
        }

        return _buildImagePicker(context, state);
      },
    );
  }

  Widget _buildImagePicker(BuildContext context, CreatePostState state) {
    return GestureDetector(
      onTap: () async {
        final ImagePicker picker = ImagePicker();
        final XFile? image = await picker.pickImage(
          source: ImageSource.gallery,
          maxWidth: 1920,
          maxHeight: 1080,
          imageQuality: 85,
        );

        if (image != null) {
          onImagePicked(image);
        }
      },
      child: Container(
        padding: const EdgeInsets.all(32),
        decoration: BoxDecoration(
          color: AppColors.surfaceDark,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: AppColors.borderColor,
            width: 1,
            style: BorderStyle.solid,
          ),
        ),
        child: Column(
          children: [
            if (state.status == CreatePostStatus.uploadingImage)
              const CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(
                  AppColors.primaryGreen,
                ),
              )
            else
              Container(
                width: 64,
                height: 64,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      AppColors.primaryGreen.withOpacity(0.2),
                      AppColors.primaryBlue.withOpacity(0.2),
                    ],
                  ),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: AppColors.primaryGreen.withOpacity(0.3),
                    width: 1,
                  ),
                ),
                child: const Icon(
                  Icons.image_outlined,
                  color: AppColors.primaryGreen,
                  size: 32,
                ),
              ),
            const SizedBox(height: 16),
            Text(
              state.status == CreatePostStatus.uploadingImage
                  ? 'Uploading image...'
                  : 'Add Image',
              style: AppTypography.titleMedium.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              state.status == CreatePostStatus.uploadingImage
                  ? 'Please wait'
                  : 'Upload a screenshot or image',
              style: AppTypography.bodySmall.copyWith(
                color: AppColors.textSecondary,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildImagePreview(BuildContext context, XFile image) {
    return Stack(
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(16),
          child: Image.file(
            File(image.path),
            width: double.infinity,
            height: 250,
            fit: BoxFit.cover,
          ),
        ),
        Positioned(
          top: 8,
          right: 8,
          child: GestureDetector(
            onTap: () {
              context.read<CreatePostBloc>().add(const CreatePostImageRemoved());
            },
            child: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.black.withOpacity(0.7),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.close,
                color: Colors.white,
                size: 20,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
