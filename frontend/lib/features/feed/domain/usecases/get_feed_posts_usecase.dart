// features/feed/domain/usecases/get_feed_posts_usecase.dart

import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/post_entity.dart';
import '../repositories/feed_repository.dart';

class GetFeedPostsUseCase
    implements UseCase<List<PostEntity>, GetFeedPostsParams> {
  final FeedRepository repository;

  GetFeedPostsUseCase(this.repository);

  @override
  Future<Either<Failure, List<PostEntity>>> call(
    GetFeedPostsParams params,
  ) async {
    return await repository.getFeedPosts(
      page: params.page,
      limit: params.limit,
    );
  }
}

class GetFeedPostsParams {
  final int page;
  final int limit;

  GetFeedPostsParams({this.page = 1, this.limit = 20});
}
