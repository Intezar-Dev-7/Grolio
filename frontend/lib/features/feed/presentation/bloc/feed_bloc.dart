// features/feed/presentation/bloc/feed_bloc.dart

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import '../../domain/entities/post_entity.dart';
import '../../domain/usecases/get_feed_posts_usecase.dart';
import '../../domain/usecases/like_post_usecase.dart';
import '../../domain/usecases/bookmark_post_usecase.dart';

part 'feed_event.dart';
part 'feed_state.dart';

class FeedBloc extends Bloc<FeedEvent, FeedState> {
  final GetFeedPostsUseCase getFeedPostsUseCase;
  final LikePostUseCase likePostUseCase;
  final BookmarkPostUseCase bookmarkPostUseCase;

  FeedBloc({
    required this.getFeedPostsUseCase,
    required this.likePostUseCase,
    required this.bookmarkPostUseCase,
  }) : super(FeedState.initial()) {
    on<FeedLoadRequested>(_onFeedLoadRequested);
    on<FeedRefreshRequested>(_onFeedRefreshRequested);
    on<FeedLoadMoreRequested>(_onFeedLoadMoreRequested);
    on<PostLikeToggled>(_onPostLikeToggled);
    on<PostBookmarkToggled>(_onPostBookmarkToggled);
    on<PostShared>(_onPostShared);
  }

  Future<void> _onFeedLoadRequested(
      FeedLoadRequested event,
      Emitter<FeedState> emit,
      ) async {
    emit(state.copyWith(status: FeedStatus.loading));

    final result = await getFeedPostsUseCase(
      GetFeedPostsParams(page: 1, limit: 20),
    );

    result.fold(
          (failure) => emit(state.copyWith(
        status: FeedStatus.error,
        errorMessage: failure.message,
      )),
          (posts) => emit(state.copyWith(
        status: FeedStatus.success,
        posts: posts,
        currentPage: 1,
        hasMore: posts.length >= 20,
      )),
    );
  }

  Future<void> _onFeedRefreshRequested(
      FeedRefreshRequested event,
      Emitter<FeedState> emit,
      ) async {
    final result = await getFeedPostsUseCase(
      GetFeedPostsParams(page: 1, limit: 20),
    );

    result.fold(
          (failure) => emit(state.copyWith(
        status: FeedStatus.error,
        errorMessage: failure.message,
      )),
          (posts) => emit(state.copyWith(
        status: FeedStatus.success,
        posts: posts,
        currentPage: 1,
        hasMore: posts.length >= 20,
      )),
    );
  }

  Future<void> _onFeedLoadMoreRequested(
      FeedLoadMoreRequested event,
      Emitter<FeedState> emit,
      ) async {
    if (!state.hasMore || state.status == FeedStatus.loadingMore) return;

    emit(state.copyWith(status: FeedStatus.loadingMore));

    final nextPage = state.currentPage + 1;
    final result = await getFeedPostsUseCase(
      GetFeedPostsParams(page: nextPage, limit: 20),
    );

    result.fold(
          (failure) => emit(state.copyWith(
        status: FeedStatus.error,
        errorMessage: failure.message,
      )),
          (newPosts) {
        final updatedPosts = List<PostEntity>.from(state.posts)
          ..addAll(newPosts);
        emit(state.copyWith(
          status: FeedStatus.success,
          posts: updatedPosts,
          currentPage: nextPage,
          hasMore: newPosts.length >= 20,
        ));
      },
    );
  }

  Future<void> _onPostLikeToggled(
      PostLikeToggled event,
      Emitter<FeedState> emit,
      ) async {
    // Optimistic update
    final updatedPosts = state.posts.map((post) {
      if (post.id == event.postId) {
        final newStats = post.stats.copyWith(
          isLiked: !post.stats.isLiked,
          likes: post.stats.isLiked
              ? post.stats.likes - 1
              : post.stats.likes + 1,
        );
        return PostEntity(
          id: post.id,
          author: post.author,
          content: post.content,
          imageUrl: post.imageUrl,
          tags: post.tags,
          githubUrl: post.githubUrl,
          demoUrl: post.demoUrl,
          stats: newStats,
          createdAt: post.createdAt,
        );
      }
      return post;
    }).toList();

    emit(state.copyWith(posts: updatedPosts));

    // API call
    final result = await likePostUseCase(event.postId);

    result.fold(
          (failure) {
        // Revert on failure
        emit(state.copyWith(posts: state.posts));
      },
          (_) {},
    );
  }

  Future<void> _onPostBookmarkToggled(
      PostBookmarkToggled event,
      Emitter<FeedState> emit,
      ) async {
    // Optimistic update
    final updatedPosts = state.posts.map((post) {
      if (post.id == event.postId) {
        final newStats = post.stats.copyWith(
          isBookmarked: !post.stats.isBookmarked,
        );
        return PostEntity(
          id: post.id,
          author: post.author,
          content: post.content,
          imageUrl: post.imageUrl,
          tags: post.tags,
          githubUrl: post.githubUrl,
          demoUrl: post.demoUrl,
          stats: newStats,
          createdAt: post.createdAt,
        );
      }
      return post;
    }).toList();

    emit(state.copyWith(posts: updatedPosts));

    // API call
    final result = await bookmarkPostUseCase(event.postId);

    result.fold(
          (failure) {
        // Revert on failure
        emit(state.copyWith(posts: state.posts));
      },
          (_) {},
    );
  }

  Future<void> _onPostShared(
      PostShared event,
      Emitter<FeedState> emit,
      ) async {
    // Implement share functionality
  }
}
