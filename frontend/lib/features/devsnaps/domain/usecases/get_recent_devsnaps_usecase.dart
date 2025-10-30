// features/devsnaps/domain/usecases/get_recent_devsnaps_usecase.dart

import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/devsnap_entity.dart';
import '../repositories/devsnap_repository.dart';

class GetRecentDevSnapsUseCase
    implements UseCase<List<DevSnapEntity>, GetRecentDevSnapsParams> {
  final DevSnapRepository repository;

  GetRecentDevSnapsUseCase(this.repository);

  @override
  Future<Either<Failure, List<DevSnapEntity>>> call(
      GetRecentDevSnapsParams params,
      ) async {
    return await repository.getRecentDevSnaps(
      page: params.page,
      limit: params.limit,
    );
  }
}

class GetRecentDevSnapsParams {
  final int page;
  final int limit;

  GetRecentDevSnapsParams({
    this.page = 1,
    this.limit = 20,
  });
}
