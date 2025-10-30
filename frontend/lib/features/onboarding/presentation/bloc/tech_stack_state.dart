part of 'tech_stack_bloc.dart';

enum TechStackStatus {
  initial,
  loading,
  loaded,
  submitting,
  success,
  error,
}

class TechStackState extends Equatable {
  final TechStackStatus status;
  final List<String> selectedTechStacks;
  final List<TechStackEntity> availableTechStacks;
  final String? errorMessage;

  const TechStackState({
    required this.status,
    required this.selectedTechStacks,
    required this.availableTechStacks,
    this.errorMessage,
  });

  factory TechStackState.initial() {
    return const TechStackState(
      status: TechStackStatus.initial,
      selectedTechStacks: [],
      availableTechStacks: [],
    );
  }

  bool isTechSelected(String techId) {
    return selectedTechStacks.contains(techId);
  }

  int get selectedCount => selectedTechStacks.length;

  TechStackState copyWith({
    TechStackStatus? status,
    List<String>? selectedTechStacks,
    List<TechStackEntity>? availableTechStacks,
    String? errorMessage,
  }) {
    return TechStackState(
      status: status ?? this.status,
      selectedTechStacks: selectedTechStacks ?? this.selectedTechStacks,
      availableTechStacks: availableTechStacks ?? this.availableTechStacks,
      errorMessage: errorMessage,
    );
  }

  @override
  List<Object?> get props => [
    status,
    selectedTechStacks,
    availableTechStacks,
    errorMessage,
  ];
}
