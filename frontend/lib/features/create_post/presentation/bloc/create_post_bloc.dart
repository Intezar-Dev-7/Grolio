// features/create_post/presentation/bloc/create_post_bloc.dart

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:frontend/features/create_post/data/datasource/create_post_remote_datasource.dart';
import 'package:image_picker/image_picker.dart';
import '../../domain/entities/create_post_entity.dart';

part 'create_post_event.dart';
part 'create_post_state.dart';

class CreatePostBloc extends Bloc<CreatePostEvent, CreatePostState> {
  final CreatePostRemoteDataSource remoteDataSource;

  CreatePostBloc({required this.remoteDataSource})
      : super(CreatePostState.initial()) {
    on<CreatePostTypeChanged>(_onTypeChanged);
    on<CreatePostImagePicked>(_onImagePicked);
    on<CreatePostImageRemoved>(_onImageRemoved);
    on<CreatePostTagAdded>(_onTagAdded);
    on<CreatePostTagRemoved>(_onTagRemoved);
    on<CreatePostSubmitted>(_onSubmitted);
  }

  void _onTypeChanged(
      CreatePostTypeChanged event,
      Emitter<CreatePostState> emit,
      ) {
    emit(state.copyWith(postType: event.type));
  }

  Future<void> _onImagePicked(
      CreatePostImagePicked event,
      Emitter<CreatePostState> emit,
      ) async {
    emit(state.copyWith(
      selectedImage: event.image,
      status: CreatePostStatus.uploadingImage,
    ));

    try {
      final imageUrl = await remoteDataSource.uploadImage(event.image);
      emit(state.copyWith(
        status: CreatePostStatus.initial,
        uploadedImageUrl: imageUrl,
      ));
    } catch (e) {
      emit(state.copyWith(
        status: CreatePostStatus.error,
        errorMessage: 'Failed to upload image',
        clearImage: true,
      ));
    }
  }

  void _onImageRemoved(
      CreatePostImageRemoved event,
      Emitter<CreatePostState> emit,
      ) {
    emit(state.copyWith(clearImage: true));
  }

  void _onTagAdded(
      CreatePostTagAdded event,
      Emitter<CreatePostState> emit,
      ) {
    if (!state.tags.contains(event.tag)) {
      final updatedTags = List<String>.from(state.tags)..add(event.tag);
      emit(state.copyWith(tags: updatedTags));
    }
  }

  void _onTagRemoved(
      CreatePostTagRemoved event,
      Emitter<CreatePostState> emit,
      ) {
    final updatedTags = List<String>.from(state.tags)..remove(event.tag);
    emit(state.copyWith(tags: updatedTags));
  }

  Future<void> _onSubmitted(
      CreatePostSubmitted event,
      Emitter<CreatePostState> emit,
      ) async {
    if (event.content.trim().isEmpty) {
      emit(state.copyWith(
        status: CreatePostStatus.error,
        errorMessage: 'Please enter some content',
      ));
      return;
    }

    emit(state.copyWith(status: CreatePostStatus.submitting));

    try {
      await remoteDataSource.createPost(
        content: event.content,
        tags: event.tags,
        imageUrl: state.uploadedImageUrl,
        githubUrl: event.githubUrl,
        demoUrl: event.demoUrl,
        type: state.postType == PostType.post
            ? 'post'
            : state.postType == PostType.devSnap
            ? 'devsnap'
            : 'project',
      );

      emit(state.copyWith(status: CreatePostStatus.success));
    } catch (e) {
      emit(state.copyWith(
        status: CreatePostStatus.error,
        errorMessage: 'Failed to create post',
      ));
    }
  }
}
