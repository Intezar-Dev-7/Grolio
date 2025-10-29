// features/onboarding/presentation/bloc/goals_bloc.dart

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import '../../domain/entities/goal_entity.dart';

part 'goals_event.dart';
part 'goals_state.dart';

class GoalsBloc extends Bloc<GoalsEvent, GoalsState> {
  GoalsBloc() : super(GoalsState.initial()) {
    on<GoalsInitialized>(_onGoalsInitialized);
    on<GoalToggled>(_onGoalToggled);
    on<GoalsSubmitted>(_onGoalsSubmitted);
  }

  Future<void> _onGoalsInitialized(
      GoalsInitialized event,
      Emitter<GoalsState> emit,
      ) async {
    emit(state.copyWith(status: GoalsStatus.loading));

    // TODO: Load from API or repository
    final goals = _getMockGoals();

    emit(state.copyWith(
      status: GoalsStatus.loaded,
      availableGoals: goals,
    ));
  }

  void _onGoalToggled(
      GoalToggled event,
      Emitter<GoalsState> emit,
      ) {
    final selectedList = List<String>.from(state.selectedGoals);

    if (selectedList.contains(event.goalId)) {
      selectedList.remove(event.goalId);
    } else {
      selectedList.add(event.goalId);
    }

    emit(state.copyWith(selectedGoals: selectedList));
  }

  Future<void> _onGoalsSubmitted(
      GoalsSubmitted event,
      Emitter<GoalsState> emit,
      ) async {
    if (state.selectedGoals.isEmpty) {
      emit(state.copyWith(
        status: GoalsStatus.error,
        errorMessage: 'Please select at least one goal',
      ));
      return;
    }

    emit(state.copyWith(status: GoalsStatus.submitting));

    try {
      // TODO: Save to backend/repository
      await Future.delayed(const Duration(seconds: 1));

      emit(state.copyWith(status: GoalsStatus.success));
    } catch (e) {
      emit(state.copyWith(
        status: GoalsStatus.error,
        errorMessage: e.toString(),
      ));
    }
  }

  // Mock data
  List<GoalEntity> _getMockGoals() {
    return const [
      GoalEntity(
        id: 'learn_skills',
        title: 'Learn New Skills',
        description: 'Master new technologies and frameworks',
        icon: Icons.book_outlined,
        iconColor: Color(0xFF4CAF93),
        borderColor: Color(0xFF4CAF93),
      ),
      GoalEntity(
        id: 'build_projects',
        title: 'Build Projects',
        description: 'Create and ship amazing applications',
        icon: Icons.rocket_launch_outlined,
        iconColor: Color(0xFF2196F3),
        borderColor: Color(0xFF2196F3),
      ),
      GoalEntity(
        id: 'collaborate',
        title: 'Collaborate',
        description: 'Work with other developers on projects',
        icon: Icons.people_outline,
        iconColor: Color(0xFFAB47BC),
        borderColor: Color(0xFFAB47BC),
      ),
      GoalEntity(
        id: 'compete_win',
        title: 'Compete & Win',
        description: 'Join hackathons and coding challenges',
        icon: Icons.emoji_events_outlined,
        iconColor: Color(0xFFFFA726),
        borderColor: Color(0xFFFFA726),
      ),
      GoalEntity(
        id: 'share_knowledge',
        title: 'Share Knowledge',
        description: 'Help others and contribute to community',
        icon: Icons.share_outlined,
        iconColor: Color(0xFF26C6DA),
        borderColor: Color(0xFF26C6DA),
      ),
      GoalEntity(
        id: 'grow_career',
        title: 'Grow Career',
        description: 'Advance professionally and build network',
        icon: Icons.trending_up,
        iconColor: Color(0xFFEC407A),
        borderColor: Color(0xFFEC407A),
      ),
    ];
  }
}
