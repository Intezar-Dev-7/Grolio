// features/create_post/presentation/pages/create_post_page.dart

import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_typography.dart';
import '../../domain/entities/create_post_entity.dart';
import '../bloc/create_post_bloc.dart';
import '../widgets/post_type_selector.dart';
import '../widgets/image_picker_section.dart';
import '../widgets/tag_input_section.dart';
import '../widgets/link_input_section.dart';

class CreatePostPage extends StatefulWidget {
  const CreatePostPage({super.key});

  @override
  State<CreatePostPage> createState() => _CreatePostPageState();
}

class _CreatePostPageState extends State<CreatePostPage> {
  final TextEditingController _contentController = TextEditingController();
  final TextEditingController _tagController = TextEditingController();
  final TextEditingController _githubController = TextEditingController();
  final TextEditingController _demoController = TextEditingController();

  @override
  void dispose() {
    _contentController.dispose();
    _tagController.dispose();
    _githubController.dispose();
    _demoController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<CreatePostBloc, CreatePostState>(
      listener: (context, state) {
        if (state.status == CreatePostStatus.success) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Post created successfully!'),
              backgroundColor: AppColors.success,
            ),
          );
          _contentController.clear();
          _tagController.clear();
          _githubController.clear();
          _demoController.clear();
          // Navigate back or reset
        } else if (state.status == CreatePostStatus.error) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.errorMessage ?? 'An error occurred'),
              backgroundColor: AppColors.error,
            ),
          );
        }
      },
      child: Scaffold(
        backgroundColor: AppColors.backgroundDark,
        appBar: AppBar(
          backgroundColor: AppColors.backgroundDark,
          elevation: 0,
          leading: IconButton(
            icon: const Icon(
              Icons.close,
              color: AppColors.iconColor,
            ),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
          title: Text(
            'Create Post',
            style: AppTypography.titleLarge.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          actions: [
            BlocBuilder<CreatePostBloc, CreatePostState>(
              builder: (context, state) {
                return TextButton(
                  onPressed: state.status == CreatePostStatus.submitting
                      ? null
                      : () {
                    context.read<CreatePostBloc>().add(
                      CreatePostSubmitted(
                        content: _contentController.text,
                        tags: state.tags,
                        githubUrl: _githubController.text.isEmpty
                            ? null
                            : _githubController.text,
                        demoUrl: _demoController.text.isEmpty
                            ? null
                            : _demoController.text,
                      ),
                    );
                  },
                  child: state.status == CreatePostStatus.submitting
                      ? const SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      valueColor: AlwaysStoppedAnimation<Color>(
                        AppColors.primaryGreen,
                      ),
                    ),
                  )
                      : Text(
                    'Post',
                    style: TextStyle(
                      color: AppColors.primaryGreen,
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                );
              },
            ),
          ],
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Post Type Selector
              const PostTypeSelector(),

              const SizedBox(height: 24),

              // Content Input
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: AppColors.surfaceDark,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: AppColors.borderColor,
                    width: 1,
                  ),
                ),
                child: TextField(
                  controller: _contentController,
                  maxLines: 8,
                  style: AppTypography.bodyMedium,
                  decoration: InputDecoration(
                    hintText: 'What\'s on your mind? Share your ideas, code, or projects...',
                    hintStyle: AppTypography.bodyMedium.copyWith(
                      color: AppColors.textTertiary,
                    ),
                    border: InputBorder.none,
                  ),
                ),
              ),

              const SizedBox(height: 24),

              // Image Picker Section
              ImagePickerSection(
                onImagePicked: (image) {
                  context
                      .read<CreatePostBloc>()
                      .add(CreatePostImagePicked(image));
                },
              ),

              const SizedBox(height: 24),

              // Tag Input Section
              TagInputSection(
                controller: _tagController,
                onTagAdded: (tag) {
                  context.read<CreatePostBloc>().add(CreatePostTagAdded(tag));
                  _tagController.clear();
                },
              ),

              const SizedBox(height: 24),

              // Link Input Section
              LinkInputSection(
                githubController: _githubController,
                demoController: _demoController,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
