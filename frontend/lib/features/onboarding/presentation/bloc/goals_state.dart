// features/onboarding/presentation/bloc/goals_state.dart

part of 'goals_bloc.dart';

enum GoalsStatus {
  initial,
  loading,
  loaded,
  submitting,
  success,
  error,
}

class GoalsState extends Equatable {
  final GoalsStatus status;
  final List<String> selectedGoals;
  final List<GoalEntity> availableGoals;
  final String? errorMessage;

  const GoalsState({
    required this.status,
    required this.selectedGoals,
    required this.availableGoals,
    this.errorMessage,
  });

  factory GoalsState.initial() {
    return const GoalsState(
      status: GoalsStatus.initial,
      selectedGoals: [],
      availableGoals: [],
    );
  }

  bool isGoalSelected(String goalId) {
    return selectedGoals.contains(goalId);
  }

  int get selectedCount => selectedGoals.length;

  bool get canComplete => selectedGoals.isNotEmpty;

  GoalsState copyWith({
    GoalsStatus? status,
    List<String>? selectedGoals,
    List<GoalEntity>? availableGoals,
    String? errorMessage,
  }) {
    return GoalsState(
      status: status ?? this.status,
      selectedGoals: selectedGoals ?? this.selectedGoals,
      availableGoals: availableGoals ?? this.availableGoals,
      errorMessage: errorMessage,
    );
  }

  @override
  List<Object?> get props => [
    status,
    selectedGoals,
    availableGoals,
    errorMessage,
  ];
}
