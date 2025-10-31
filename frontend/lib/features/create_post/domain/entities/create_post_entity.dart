// features/create_post/domain/entities/create_post_entity.dart

import 'package:equatable/equatable.dart';

class CreatePostEntity extends Equatable {
  final String content;
  final List<String> tags;
  final String? imageUrl;
  final String? githubUrl;
  final String? demoUrl;
  final PostType type;

  const CreatePostEntity({
    required this.content,
    required this.tags,
    this.imageUrl,
    this.githubUrl,
    this.demoUrl,
    required this.type,
  });

  @override
  List<Object?> get props => [
    content,
    tags,
    imageUrl,
    githubUrl,
    demoUrl,
    type,
  ];
}

enum PostType {
  post,
  devSnap,
  project,
}
