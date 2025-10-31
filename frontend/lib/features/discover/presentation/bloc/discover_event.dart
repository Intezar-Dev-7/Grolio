// features/discover/presentation/bloc/discover_event.dart

part of 'discover_bloc.dart';

abstract class DiscoverEvent extends Equatable {
  const DiscoverEvent();

  @override
  List<Object?> get props => [];
}

class DiscoverLoadRequested extends DiscoverEvent {
  const DiscoverLoadRequested();
}

class DiscoverRefreshRequested extends DiscoverEvent {
  const DiscoverRefreshRequested();
}

class DiscoverLoadMoreRequested extends DiscoverEvent {
  const DiscoverLoadMoreRequested();
}

class DiscoverTechFilterToggled extends DiscoverEvent {
  final String tech;

  const DiscoverTechFilterToggled(this.tech);

  @override
  List<Object?> get props => [tech];
}

class DiscoverTechFilterCleared extends DiscoverEvent {
  const DiscoverTechFilterCleared();
}

class DeveloperFollowToggled extends DiscoverEvent {
  final String developerId;

  const DeveloperFollowToggled(this.developerId);

  @override
  List<Object?> get props => [developerId];
}
