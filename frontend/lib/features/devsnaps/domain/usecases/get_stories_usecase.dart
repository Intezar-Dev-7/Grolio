// features/devsnaps/domain/usecases/get_stories_usecase.dart

import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/story_entity.dart';
import '../repositories/devsnap_repository.dart';

class GetStoriesUseCase implements UseCase<List<StoryEntity>, NoParams> {
  final DevSnapRepository repository;

  GetStoriesUseCase(this.repository);

  @override
  Future<Either<Failure, List<StoryEntity>>> call(NoParams params) async {
    return await repository.getStories();
  }
}
