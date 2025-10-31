// features/discover/presentation/bloc/discover_state.dart

part of 'discover_bloc.dart';

enum DiscoverStatus {
  initial,
  loading,
  success,
  error,
  loadingMore,
}

class DiscoverState extends Equatable {
  final DiscoverStatus status;
  final List<DeveloperEntity> developers;
  final List<String> selectedTechFilters;
  final String? errorMessage;
  final int currentPage;
  final bool hasMore;

  const DiscoverState({
    required this.status,
    required this.developers,
    required this.selectedTechFilters,
    this.errorMessage,
    required this.currentPage,
    required this.hasMore,
  });

  factory DiscoverState.initial() {
    return const DiscoverState(
      status: DiscoverStatus.initial,
      developers: [],
      selectedTechFilters: [],
      currentPage: 1,
      hasMore: true,
    );
  }

  DiscoverState copyWith({
    DiscoverStatus? status,
    List<DeveloperEntity>? developers,
    List<String>? selectedTechFilters,
    String? errorMessage,
    int? currentPage,
    bool? hasMore,
  }) {
    return DiscoverState(
      status: status ?? this.status,
      developers: developers ?? this.developers,
      selectedTechFilters: selectedTechFilters ?? this.selectedTechFilters,
      errorMessage: errorMessage,
      currentPage: currentPage ?? this.currentPage,
      hasMore: hasMore ?? this.hasMore,
    );
  }

  @override
  List<Object?> get props => [
    status,
    developers,
    selectedTechFilters,
    errorMessage,
    currentPage,
    hasMore,
  ];
}
