// features/discover/presentation/bloc/discover_bloc.dart

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import '../../domain/entities/developer_entity.dart';
import '../../data/datasources/discover_remote_datasource.dart';

part 'discover_event.dart';
part 'discover_state.dart';

class DiscoverBloc extends Bloc<DiscoverEvent, DiscoverState> {
  final DiscoverRemoteDataSource remoteDataSource;

  DiscoverBloc({required this.remoteDataSource})
      : super(DiscoverState.initial()) {
    on<DiscoverLoadRequested>(_onLoadRequested);
    on<DiscoverRefreshRequested>(_onRefreshRequested);
    on<DiscoverLoadMoreRequested>(_onLoadMoreRequested);
    on<DiscoverTechFilterToggled>(_onTechFilterToggled);
    on<DiscoverTechFilterCleared>(_onTechFilterCleared);
    on<DeveloperFollowToggled>(_onFollowToggled);
  }

  Future<void> _onLoadRequested(
      DiscoverLoadRequested event,
      Emitter<DiscoverState> emit,
      ) async {
    emit(state.copyWith(status: DiscoverStatus.loading));

    try {
      final developers = await remoteDataSource.getRecommendedDevelopers(
        techFilters: state.selectedTechFilters,
        page: 1,
        limit: 20,
      );

      emit(state.copyWith(
        status: DiscoverStatus.success,
        developers: developers.map((m) => m.toEntity()).toList(),
        currentPage: 1,
        hasMore: developers.length >= 20,
      ));
    } catch (e) {
      emit(state.copyWith(
        status: DiscoverStatus.error,
        errorMessage: e.toString(),
      ));
    }
  }

  Future<void> _onRefreshRequested(
      DiscoverRefreshRequested event,
      Emitter<DiscoverState> emit,
      ) async {
    try {
      final developers = await remoteDataSource.getRecommendedDevelopers(
        techFilters: state.selectedTechFilters,
        page: 1,
        limit: 20,
      );

      emit(state.copyWith(
        status: DiscoverStatus.success,
        developers: developers.map((m) => m.toEntity()).toList(),
        currentPage: 1,
        hasMore: developers.length >= 20,
      ));
    } catch (e) {
      emit(state.copyWith(
        status: DiscoverStatus.error,
        errorMessage: e.toString(),
      ));
    }
  }

  Future<void> _onLoadMoreRequested(
      DiscoverLoadMoreRequested event,
      Emitter<DiscoverState> emit,
      ) async {
    if (!state.hasMore || state.status == DiscoverStatus.loadingMore) return;

    emit(state.copyWith(status: DiscoverStatus.loadingMore));

    try {
      final nextPage = state.currentPage + 1;
      final newDevelopers = await remoteDataSource.getRecommendedDevelopers(
        techFilters: state.selectedTechFilters,
        page: nextPage,
        limit: 20,
      );

      final updatedDevelopers = List<DeveloperEntity>.from(state.developers)
        ..addAll(newDevelopers.map((m) => m.toEntity()));

      emit(state.copyWith(
        status: DiscoverStatus.success,
        developers: updatedDevelopers,
        currentPage: nextPage,
        hasMore: newDevelopers.length >= 20,
      ));
    } catch (e) {
      emit(state.copyWith(
        status: DiscoverStatus.error,
        errorMessage: e.toString(),
      ));
    }
  }

  void _onTechFilterToggled(
      DiscoverTechFilterToggled event,
      Emitter<DiscoverState> emit,
      ) {
    final filters = List<String>.from(state.selectedTechFilters);

    if (filters.contains(event.tech)) {
      filters.remove(event.tech);
    } else {
      filters.add(event.tech);
    }

    emit(state.copyWith(selectedTechFilters: filters));
    add(const DiscoverLoadRequested());
  }

  void _onTechFilterCleared(
      DiscoverTechFilterCleared event,
      Emitter<DiscoverState> emit,
      ) {
    emit(state.copyWith(selectedTechFilters: []));
    add(const DiscoverLoadRequested());
  }

  Future<void> _onFollowToggled(
      DeveloperFollowToggled event,
      Emitter<DiscoverState> emit,
      ) async {
    final updatedDevelopers = state.developers.map((dev) {
      if (dev.id == event.developerId) {
        return DeveloperEntity(
          id: dev.id,
          name: dev.name,
          username: dev.username,
          avatar: dev.avatar,
          bio: dev.bio,
          matchPercentage: dev.matchPercentage,
          commonTechnologies: dev.commonTechnologies,
          mutualConnections: dev.mutualConnections,
          commonTech: dev.commonTech,
          otherTech: dev.otherTech,
          knownFor: dev.knownFor,
          isFollowing: !dev.isFollowing,
        );
      }
      return dev;
    }).toList();

    emit(state.copyWith(developers: updatedDevelopers));

    try {
      final developer = state.developers.firstWhere((d) => d.id == event.developerId);
      if (developer.isFollowing) {
        await remoteDataSource.followDeveloper(event.developerId);
      } else {
        await remoteDataSource.unfollowDeveloper(event.developerId);
      }
    } catch (e) {
      // Revert on error
      emit(state.copyWith(developers: state.developers));
    }
  }
}
