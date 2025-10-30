// features/feed/presentation/bloc/feed_state.dart

part of 'feed_bloc.dart';

enum FeedStatus {
  initial,
  loading,
  success,
  error,
  loadingMore,
}

class FeedState extends Equatable {
  final FeedStatus status;
  final List<PostEntity> posts;
  final String? errorMessage;
  final int currentPage;
  final bool hasMore;

  const FeedState({
    required this.status,
    required this.posts,
    this.errorMessage,
    required this.currentPage,
    required this.hasMore,
  });

  factory FeedState.initial() {
    return const FeedState(
      status: FeedStatus.initial,
      posts: [],
      currentPage: 1,
      hasMore: true,
    );
  }

  FeedState copyWith({
    FeedStatus? status,
    List<PostEntity>? posts,
    String? errorMessage,
    int? currentPage,
    bool? hasMore,
  }) {
    return FeedState(
      status: status ?? this.status,
      posts: posts ?? this.posts,
      errorMessage: errorMessage,
      currentPage: currentPage ?? this.currentPage,
      hasMore: hasMore ?? this.hasMore,
    );
  }

  @override
  List<Object?> get props => [
    status,
    posts,
    errorMessage,
    currentPage,
    hasMore,
  ];
}
