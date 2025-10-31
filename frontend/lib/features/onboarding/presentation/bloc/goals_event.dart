// features/onboarding/presentation/bloc/goals_event.dart

part of 'goals_bloc.dart';

abstract class GoalsEvent extends Equatable {
  const GoalsEvent();

  @override
  List<Object?> get props => [];
}

class GoalsInitialized extends GoalsEvent {
  const GoalsInitialized();
}

class GoalToggled extends GoalsEvent {
  final String goalId;

  const GoalToggled(this.goalId);

  @override
  List<Object?> get props => [goalId];
}

class GoalsSubmitted extends GoalsEvent {
  const GoalsSubmitted();
}

class GoalsSkipped extends GoalsEvent {
  const GoalsSkipped();
}