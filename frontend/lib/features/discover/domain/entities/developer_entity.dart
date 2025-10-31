// features/discover/domain/entities/developer_entity.dart

import 'package:equatable/equatable.dart';

class DeveloperEntity extends Equatable {
  final String id;
  final String name;
  final String username;
  final String? avatar;
  final String bio;
  final int matchPercentage;
  final int commonTechnologies;
  final int mutualConnections;
  final List<String> commonTech;
  final List<String> otherTech;
  final String? knownFor;
  final bool isFollowing;

  const DeveloperEntity({
    required this.id,
    required this.name,
    required this.username,
    this.avatar,
    required this.bio,
    required this.matchPercentage,
    required this.commonTechnologies,
    required this.mutualConnections,
    required this.commonTech,
    required this.otherTech,
    this.knownFor,
    required this.isFollowing,
  });

  @override
  List<Object?> get props => [
    id,
    name,
    username,
    avatar,
    bio,
    matchPercentage,
    commonTechnologies,
    mutualConnections,
    commonTech,
    otherTech,
    knownFor,
    isFollowing,
  ];
}
