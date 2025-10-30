// features/devsnaps/presentation/bloc/devsnap_bloc.dart

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import '../../../../core/usecases/usecase.dart';
import '../../domain/entities/devsnap_entity.dart';
import '../../domain/entities/story_entity.dart';
import '../../domain/usecases/get_stories_usecase.dart';
import '../../domain/usecases/get_recent_devsnaps_usecase.dart';
import '../../domain/usecases/create_devsnap_usecase.dart';

part 'devsnap_event.dart';
part 'devsnap_state.dart';

class DevSnapBloc extends Bloc<DevSnapEvent, DevSnapState> {
  final GetStoriesUseCase getStoriesUseCase;
  final GetRecentDevSnapsUseCase getRecentDevSnapsUseCase;
  final CreateDevSnapUseCase createDevSnapUseCase;

  DevSnapBloc({
    required this.getStoriesUseCase,
    required this.getRecentDevSnapsUseCase,
    required this.createDevSnapUseCase,
  }) : super(DevSnapState.initial()) {
    on<DevSnapStoriesLoadRequested>(_onStoriesLoadRequested);
    on<DevSnapRecentLoadRequested>(_onRecentLoadRequested);
    on<DevSnapRecentLoadMoreRequested>(_onRecentLoadMoreRequested);
    on<DevSnapCreated>(_onDevSnapCreated);
    on<DevSnapMarkedAsViewed>(_onMarkedAsViewed);
    on<DevSnapLiked>(_onLiked);
  }

  Future<void> _onStoriesLoadRequested(
      DevSnapStoriesLoadRequested event,
      Emitter<DevSnapState> emit,
      ) async {
    emit(state.copyWith(status: DevSnapStatus.loading));

    final result = await getStoriesUseCase(NoParams());

    result.fold(
          (failure) => emit(state.copyWith(
        status: DevSnapStatus.error,
        errorMessage: failure.message,
      )),
          (stories) => emit(state.copyWith(
        status: DevSnapStatus.success,
        stories: stories,
      )),
    );
  }

  Future<void> _onRecentLoadRequested(
      DevSnapRecentLoadRequested event,
      Emitter<DevSnapState> emit,
      ) async {
    emit(state.copyWith(status: DevSnapStatus.loading));

    final result = await getRecentDevSnapsUseCase(
      GetRecentDevSnapsParams(page: 1, limit: 20),
    );

    result.fold(
          (failure) => emit(state.copyWith(
        status: DevSnapStatus.error,
        errorMessage: failure.message,
      )),
          (snaps) => emit(state.copyWith(
        status: DevSnapStatus.success,
        recentSnaps: snaps,
        currentPage: 1,
        hasMore: snaps.length >= 20,
      )),
    );
  }

  Future<void> _onRecentLoadMoreRequested(
      DevSnapRecentLoadMoreRequested event,
      Emitter<DevSnapState> emit,
      ) async {
    if (!state.hasMore || state.status == DevSnapStatus.loadingMore) return;

    emit(state.copyWith(status: DevSnapStatus.loadingMore));

    final nextPage = state.currentPage + 1;
    final result = await getRecentDevSnapsUseCase(
      GetRecentDevSnapsParams(page: nextPage, limit: 20),
    );

    result.fold(
          (failure) => emit(state.copyWith(
        status: DevSnapStatus.error,
        errorMessage: failure.message,
      )),
          (newSnaps) {
        final updatedSnaps = List<DevSnapEntity>.from(state.recentSnaps)
          ..addAll(newSnaps);
        emit(state.copyWith(
          status: DevSnapStatus.success,
          recentSnaps: updatedSnaps,
          currentPage: nextPage,
          hasMore: newSnaps.length >= 20,
        ));
      },
    );
  }

  Future<void> _onDevSnapCreated(
      DevSnapCreated event,
      Emitter<DevSnapState> emit,
      ) async {
    final result = await createDevSnapUseCase(
      CreateDevSnapParams(
        imageUrl: event.imageUrl,
        caption: event.caption,
        tags: event.tags,
        codeSnippet: event.codeSnippet,
        language: event.language,
      ),
    );

    result.fold(
          (failure) => emit(state.copyWith(
        status: DevSnapStatus.error,
        errorMessage: failure.message,
      )),
          (snap) {
        // Optionally add to stories
        emit(state.copyWith(status: DevSnapStatus.success));
      },
    );
  }

  Future<void> _onMarkedAsViewed(
      DevSnapMarkedAsViewed event,
      Emitter<DevSnapState> emit,
      ) async {
    // Update local state immediately
    // API call would happen in the background
  }

  Future<void> _onLiked(
      DevSnapLiked event,
      Emitter<DevSnapState> emit,
      ) async {
    // Update local state immediately
    // API call would happen in the background
  }
}
