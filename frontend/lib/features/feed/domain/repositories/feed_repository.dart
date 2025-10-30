// features/feed/domain/repositories/feed_repository.dart

import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../entities/post_entity.dart';

abstract class FeedRepository {
  Future<Either<Failure, List<PostEntity>>> getFeedPosts({
    int page = 1,
    int limit = 20,
  });

  Future<Either<Failure, PostEntity>> getPostById(String postId);

  Future<Either<Failure, void>> likePost(String postId);

  Future<Either<Failure, void>> unlikePost(String postId);

  Future<Either<Failure, void>> bookmarkPost(String postId);

  Future<Either<Failure, void>> unbookmarkPost(String postId);

  Future<Either<Failure, void>> sharePost(String postId);

  Future<Either<Failure, PostEntity>> createPost({
    required String content,
    List<String>? tags,
    String? imageUrl,
    String? githubUrl,
    String? demoUrl,
  });

  Future<Either<Failure, void>> deletePost(String postId);
}
