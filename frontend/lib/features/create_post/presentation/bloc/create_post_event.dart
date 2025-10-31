// features/create_post/presentation/bloc/create_post_event.dart

part of 'create_post_bloc.dart';

abstract class CreatePostEvent extends Equatable {
  const CreatePostEvent();

  @override
  List<Object?> get props => [];
}

class CreatePostTypeChanged extends CreatePostEvent {
  final PostType type;

  const CreatePostTypeChanged(this.type);

  @override
  List<Object?> get props => [type];
}

class CreatePostImagePicked extends CreatePostEvent {
  final XFile image;

  const CreatePostImagePicked(this.image);

  @override
  List<Object?> get props => [image];
}

class CreatePostImageRemoved extends CreatePostEvent {
  const CreatePostImageRemoved();
}

class CreatePostTagAdded extends CreatePostEvent {
  final String tag;

  const CreatePostTagAdded(this.tag);

  @override
  List<Object?> get props => [tag];
}

class CreatePostTagRemoved extends CreatePostEvent {
  final String tag;

  const CreatePostTagRemoved(this.tag);

  @override
  List<Object?> get props => [tag];
}

class CreatePostSubmitted extends CreatePostEvent {
  final String content;
  final List<String> tags;
  final String? githubUrl;
  final String? demoUrl;

  const CreatePostSubmitted({
    required this.content,
    required this.tags,
    this.githubUrl,
    this.demoUrl,
  });

  @override
  List<Object?> get props => [content, tags, githubUrl, demoUrl];
}
