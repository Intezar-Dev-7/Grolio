// features/onboarding/presentation/bloc/tech_stack_bloc.dart

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import '../../domain/entities/tech_stack_entity.dart';

part 'tech_stack_event.dart';
part 'tech_stack_state.dart';

class TechStackBloc extends Bloc<TechStackEvent, TechStackState> {
  TechStackBloc() : super(TechStackState.initial()) {
    on<TechStacksInitialized>(_onTechStacksInitialized);
    on<TechStackToggled>(_onTechStackToggled);
    on<TechStacksSubmitted>(_onTechStacksSubmitted);
    on<TechStacksSkipped>(_onTechStacksSkipped);
  }

  Future<void> _onTechStacksInitialized(
      TechStacksInitialized event,
      Emitter<TechStackState> emit,
      ) async {
    emit(state.copyWith(status: TechStackStatus.loading));

    // TODO: Load from API or repository
    final techStacks = _getMockTechStacks();

    emit(state.copyWith(
      status: TechStackStatus.loaded,
      availableTechStacks: techStacks,
    ));
  }

  void _onTechStackToggled(
      TechStackToggled event,
      Emitter<TechStackState> emit,
      ) {
    final selectedList = List<String>.from(state.selectedTechStacks);

    if (selectedList.contains(event.techId)) {
      selectedList.remove(event.techId);
    } else {
      selectedList.add(event.techId);
    }

    emit(state.copyWith(selectedTechStacks: selectedList));
  }

  Future<void> _onTechStacksSubmitted(
      TechStacksSubmitted event,
      Emitter<TechStackState> emit,
      ) async {
    if (state.selectedTechStacks.isEmpty) {
      emit(state.copyWith(
        status: TechStackStatus.error,
        errorMessage: 'Please select at least one technology',
      ));
      return;
    }

    emit(state.copyWith(status: TechStackStatus.submitting));

    try {
      // TODO: Save to backend/repository
      await Future.delayed(const Duration(seconds: 1));

      emit(state.copyWith(status: TechStackStatus.success));
    } catch (e) {
      emit(state.copyWith(
        status: TechStackStatus.error,
        errorMessage: e.toString(),
      ));
    }
  }

  Future<void> _onTechStacksSkipped(
      TechStacksSkipped event,
      Emitter<TechStackState> emit,
      ) async {
    emit(state.copyWith(status: TechStackStatus.success));
  }

  // Mock data - replace with actual data from repository
  List<TechStackEntity> _getMockTechStacks() {
    return [
      const TechStackEntity(
        id: 'react',
        name: 'react',
        displayName: 'React',
        category: 'Frontend',
        popularity: 95,
      ),
      const TechStackEntity(
        id: 'vue',
        name: 'vue',
        displayName: 'Vue',
        category: 'Frontend',
        popularity: 80,
      ),
      const TechStackEntity(
        id: 'angular',
        name: 'angular',
        displayName: 'Angular',
        category: 'Frontend',
        popularity: 75,
      ),
      const TechStackEntity(
        id: 'typescript',
        name: 'typescript',
        displayName: 'TypeScript',
        category: 'Language',
        popularity: 90,
      ),
      const TechStackEntity(
        id: 'javascript',
        name: 'javascript',
        displayName: 'JavaScript',
        category: 'Language',
        popularity: 98,
      ),
      const TechStackEntity(
        id: 'python',
        name: 'python',
        displayName: 'Python',
        category: 'Language',
        popularity: 92,
      ),
      const TechStackEntity(
        id: 'java',
        name: 'java',
        displayName: 'Java',
        category: 'Language',
        popularity: 85,
      ),
      const TechStackEntity(
        id: 'golang',
        name: 'golang',
        displayName: 'Golang',
        category: 'Language',
        popularity: 70,
      ),
      const TechStackEntity(
        id: 'rust',
        name: 'rust',
        displayName: 'Rust',
        category: 'Language',
        popularity: 65,
      ),
      const TechStackEntity(
        id: 'swift',
        name: 'swift',
        displayName: 'Swift',
        category: 'Mobile',
        popularity: 60,
      ),
      const TechStackEntity(
        id: 'kotlin',
        name: 'kotlin',
        displayName: 'Kotlin',
        category: 'Mobile',
        popularity: 68,
      ),
      const TechStackEntity(
        id: 'flutter',
        name: 'flutter',
        displayName: 'Flutter',
        category: 'Mobile',
        popularity: 78,
      ),
      const TechStackEntity(
        id: 'nodejs',
        name: 'nodejs',
        displayName: 'NodeJS',
        category: 'Backend',
        popularity: 88,
      ),
      const TechStackEntity(
        id: 'docker',
        name: 'docker',
        displayName: 'Docker',
        category: 'DevOps',
        popularity: 87,
      ),
    ];
  }
}
