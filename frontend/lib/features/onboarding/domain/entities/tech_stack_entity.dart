import 'package:equatable/equatable.dart';

class TechStackEntity extends Equatable {
  final String id;
  final String name;
  final String displayName;
  final String category;
  final int popularity;

  const TechStackEntity({
    required this.id,
    required this.name,
    required this.displayName,
    required this.category,
    required this.popularity,
  });

  @override
  List<Object?> get props => [id, name, displayName, category, popularity];
}
