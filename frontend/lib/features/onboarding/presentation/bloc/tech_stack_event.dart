part of 'tech_stack_bloc.dart';

abstract class TechStackEvent extends Equatable {
  const TechStackEvent();

  @override
  List<Object?> get props => [];
}

class TechStackToggled extends TechStackEvent {
  final String techId;

  const TechStackToggled(this.techId);

  @override
  List<Object?> get props => [techId];
}

class TechStacksSubmitted extends TechStackEvent {
  const TechStacksSubmitted();
}

class TechStacksSkipped extends TechStackEvent {
  const TechStacksSkipped();
}

class TechStacksInitialized extends TechStackEvent {
  const TechStacksInitialized();
}
