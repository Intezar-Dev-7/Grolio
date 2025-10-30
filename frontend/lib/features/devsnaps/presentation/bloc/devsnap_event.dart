// features/devsnaps/presentation/bloc/devsnap_event.dart

part of 'devsnap_bloc.dart';

abstract class DevSnapEvent extends Equatable {
  const DevSnapEvent();

  @override
  List<Object?> get props => [];
}

class DevSnapStoriesLoadRequested extends DevSnapEvent {
  const DevSnapStoriesLoadRequested();
}

class DevSnapRecentLoadRequested extends DevSnapEvent {
  const DevSnapRecentLoadRequested();
}

class DevSnapRecentLoadMoreRequested extends DevSnapEvent {
  const DevSnapRecentLoadMoreRequested();
}

class DevSnapCreated extends DevSnapEvent {
  final String imageUrl;
  final String? caption;
  final List<String>? tags;
  final String? codeSnippet;
  final String? language;

  const DevSnapCreated({
    required this.imageUrl,
    this.caption,
    this.tags,
    this.codeSnippet,
    this.language,
  });

  @override
  List<Object?> get props => [imageUrl, caption, tags, codeSnippet, language];
}

class DevSnapMarkedAsViewed extends DevSnapEvent {
  final String devSnapId;

  const DevSnapMarkedAsViewed(this.devSnapId);

  @override
  List<Object?> get props => [devSnapId];
}

class DevSnapLiked extends DevSnapEvent {
  final String devSnapId;

  const DevSnapLiked(this.devSnapId);

  @override
  List<Object?> get props => [devSnapId];
}
