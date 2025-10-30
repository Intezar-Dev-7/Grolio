// features/feed/domain/usecases/like_post_usecase.dart

import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../repositories/feed_repository.dart';

class LikePostUseCase implements UseCase<void, String> {
  final FeedRepository repository;

  LikePostUseCase(this.repository);

  @override
  Future<Either<Failure, void>> call(String postId) async {
    return await repository.likePost(postId);
  }
}
