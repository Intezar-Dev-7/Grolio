// features/create_post/presentation/bloc/create_post_state.dart

part of 'create_post_bloc.dart';

enum CreatePostStatus {
  initial,
  uploadingImage,
  submitting,
  success,
  error,
}

class CreatePostState extends Equatable {
  final CreatePostStatus status;
  final PostType postType;
  final XFile? selectedImage;
  final String? uploadedImageUrl;
  final List<String> tags;
  final String? errorMessage;

  const CreatePostState({
    required this.status,
    required this.postType,
    this.selectedImage,
    this.uploadedImageUrl,
    required this.tags,
    this.errorMessage,
  });

  factory CreatePostState.initial() {
    return const CreatePostState(
      status: CreatePostStatus.initial,
      postType: PostType.post,
      tags: [],
    );
  }

  CreatePostState copyWith({
    CreatePostStatus? status,
    PostType? postType,
    XFile? selectedImage,
    String? uploadedImageUrl,
    List<String>? tags,
    String? errorMessage,
    bool clearImage = false,
  }) {
    return CreatePostState(
      status: status ?? this.status,
      postType: postType ?? this.postType,
      selectedImage: clearImage ? null : (selectedImage ?? this.selectedImage),
      uploadedImageUrl: clearImage
          ? null
          : (uploadedImageUrl ?? this.uploadedImageUrl),
      tags: tags ?? this.tags,
      errorMessage: errorMessage,
    );
  }

  @override
  List<Object?> get props => [
    status,
    postType,
    selectedImage,
    uploadedImageUrl,
    tags,
    errorMessage,
  ];
}
