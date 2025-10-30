// features/devsnaps/domain/usecases/create_devsnap_usecase.dart

import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/devsnap_entity.dart';
import '../repositories/devsnap_repository.dart';

class CreateDevSnapUseCase
    implements UseCase<DevSnapEntity, CreateDevSnapParams> {
  final DevSnapRepository repository;

  CreateDevSnapUseCase(this.repository);

  @override
  Future<Either<Failure, DevSnapEntity>> call(
      CreateDevSnapParams params,
      ) async {
    return await repository.createDevSnap(
      imageUrl: params.imageUrl,
      caption: params.caption,
      tags: params.tags,
      codeSnippet: params.codeSnippet,
      language: params.language,
    );
  }
}

class CreateDevSnapParams {
  final String imageUrl;
  final String? caption;
  final List<String>? tags;
  final String? codeSnippet;
  final String? language;

  CreateDevSnapParams({
    required this.imageUrl,
    this.caption,
    this.tags,
    this.codeSnippet,
    this.language,
  });
}
