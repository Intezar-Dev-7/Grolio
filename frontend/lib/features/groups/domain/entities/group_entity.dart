// features/groups/domain/entities/group_entity.dart

import 'package:equatable/equatable.dart';

class GroupEntity extends Equatable {
  final String id;
  final String name;
  final String? description;
  final String? avatar;
  final DateTime createdAt;
  final String createdBy;
  final int membersCount;
  final bool isAdmin;
  final bool isMember;
  final List<GroupMember> members;
  final List<GroupAdmin> admins;

  const GroupEntity({
    required this.id,
    required this.name,
    this.description,
    this.avatar,
    required this.createdAt,
    required this.createdBy,
    required this.membersCount,
    required this.isAdmin,
    required this.isMember,
    required this.members,
    required this.admins,
  });

  @override
  List<Object?> get props => [
    id,
    name,
    description,
    avatar,
    createdAt,
    createdBy,
    membersCount,
    isAdmin,
    isMember,
    members,
    admins,
  ];
}

class GroupMember extends Equatable {
  final String id;
  final String name;
  final String? avatar;
  final bool isAdmin;
  final DateTime joinedAt;

  const GroupMember({
    required this.id,
    required this.name,
    this.avatar,
    required this.isAdmin,
    required this.joinedAt,
  });

  @override
  List<Object?> get props => [id, name, avatar, isAdmin, joinedAt];
}

class GroupAdmin extends Equatable {
  final String id;
  final String name;
  final String? avatar;

  const GroupAdmin({
    required this.id,
    required this.name,
    this.avatar,
  });

  @override
  List<Object?> get props => [id, name, avatar];
}
