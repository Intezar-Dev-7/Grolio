// features/feed/presentation/bloc/feed_event.dart

part of 'feed_bloc.dart';

abstract class FeedEvent extends Equatable {
  const FeedEvent();

  @override
  List<Object?> get props => [];
}

class FeedLoadRequested extends FeedEvent {
  const FeedLoadRequested();
}

class FeedRefreshRequested extends FeedEvent {
  const FeedRefreshRequested();
}

class FeedLoadMoreRequested extends FeedEvent {
  const FeedLoadMoreRequested();
}

class PostLikeToggled extends FeedEvent {
  final String postId;

  const PostLikeToggled(this.postId);

  @override
  List<Object?> get props => [postId];
}

class PostBookmarkToggled extends FeedEvent {
  final String postId;

  const PostBookmarkToggled(this.postId);

  @override
  List<Object?> get props => [postId];
}

class PostShared extends FeedEvent {
  final String postId;

  const PostShared(this.postId);

  @override
  List<Object?> get props => [postId];
}
