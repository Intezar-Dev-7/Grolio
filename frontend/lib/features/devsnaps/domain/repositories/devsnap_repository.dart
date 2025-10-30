// features/devsnaps/domain/repositories/devsnap_repository.dart

import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../entities/devsnap_entity.dart';
import '../entities/story_entity.dart';

abstract class DevSnapRepository {
  Future<Either<Failure, List<StoryEntity>>> getStories();

  Future<Either<Failure, List<DevSnapEntity>>> getUserDevSnaps(String userId);

  Future<Either<Failure, List<DevSnapEntity>>> getRecentDevSnaps({
    int page = 1,
    int limit = 20,
  });

  Future<Either<Failure, DevSnapEntity>> createDevSnap({
    required String imageUrl,
    String? caption,
    List<String>? tags,
    String? codeSnippet,
    String? language,
  });

  Future<Either<Failure, void>> markAsViewed(String devSnapId);

  Future<Either<Failure, void>> likeDevSnap(String devSnapId);

  Future<Either<Failure, void>> deleteDevSnap(String devSnapId);
}
