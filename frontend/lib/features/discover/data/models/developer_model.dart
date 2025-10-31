// features/discover/data/models/developer_model.dart

import '../../domain/entities/developer_entity.dart';

class DeveloperModel {
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

  DeveloperModel({
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

  factory DeveloperModel.fromJson(Map<String, dynamic> json) {
    return DeveloperModel(
      id: json['id'] as String,
      name: json['name'] as String,
      username: json['username'] as String,
      avatar: json['avatar'] as String?,
      bio: json['bio'] as String,
      matchPercentage: json['match_percentage'] as int,
      commonTechnologies: json['common_technologies'] as int,
      mutualConnections: json['mutual_connections'] as int,
      commonTech: (json['common_tech'] as List<dynamic>)
          .map((e) => e as String)
          .toList(),
      otherTech: (json['other_tech'] as List<dynamic>)
          .map((e) => e as String)
          .toList(),
      knownFor: json['known_for'] as String?,
      isFollowing: json['is_following'] as bool? ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'username': username,
      'avatar': avatar,
      'bio': bio,
      'match_percentage': matchPercentage,
      'common_technologies': commonTechnologies,
      'mutual_connections': mutualConnections,
      'common_tech': commonTech,
      'other_tech': otherTech,
      'known_for': knownFor,
      'is_following': isFollowing,
    };
  }

  DeveloperEntity toEntity() {
    return DeveloperEntity(
      id: id,
      name: name,
      username: username,
      avatar: avatar,
      bio: bio,
      matchPercentage: matchPercentage,
      commonTechnologies: commonTechnologies,
      mutualConnections: mutualConnections,
      commonTech: commonTech,
      otherTech: otherTech,
      knownFor: knownFor,
      isFollowing: isFollowing,
    );
  }
}
