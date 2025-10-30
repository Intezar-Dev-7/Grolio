// features/devsnaps/presentation/bloc/devsnap_state.dart

part of 'devsnap_bloc.dart';

enum DevSnapStatus {
  initial,
  loading,
  success,
  error,
  loadingMore,
}

class DevSnapState extends Equatable {
  final DevSnapStatus status;
  final List<StoryEntity> stories;
  final List<DevSnapEntity> recentSnaps;
  final String? errorMessage;
  final int currentPage;
  final bool hasMore;

  const DevSnapState({
    required this.status,
    required this.stories,
    required this.recentSnaps,
    this.errorMessage,
    required this.currentPage,
    required this.hasMore,
  });

  factory DevSnapState.initial() {
    return const DevSnapState(
      status: DevSnapStatus.initial,
      stories: [],
      recentSnaps: [],
      currentPage: 1,
      hasMore: true,
    );
  }

  DevSnapState copyWith({
    DevSnapStatus? status,
    List<StoryEntity>? stories,
    List<DevSnapEntity>? recentSnaps,
    String? errorMessage,
    int? currentPage,
    bool? hasMore,
  }) {
    return DevSnapState(
      status: status ?? this.status,
      stories: stories ?? this.stories,
      recentSnaps: recentSnaps ?? this.recentSnaps,
      errorMessage: errorMessage,
      currentPage: currentPage ?? this.currentPage,
      hasMore: hasMore ?? this.hasMore,
    );
  }

  @override
  List<Object?> get props => [
    status,
    stories,
    recentSnaps,
    errorMessage,
    currentPage,
    hasMore,
  ];
}
