// features/groups/data/models/group_model.dart

import '../../domain/entities/group_entity.dart';

class GroupModel {
  final String id;
  final String name;
  final String? description;
  final String? avatar;
  final DateTime createdAt;
  final String createdBy;
  final int membersCount;
  final bool isAdmin;
  final bool isMember;
  final List<GroupMemberModel> members;
  final List<GroupAdminModel> admins;

  GroupModel({
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

  factory GroupModel.fromJson(Map<String, dynamic> json) {
    return GroupModel(
      id: json['id'] as String,
      name: json['name'] as String,
      description: json['description'] as String?,
      avatar: json['avatar'] as String?,
      createdAt: DateTime.parse(json['created_at'] as String),
      createdBy: json['created_by'] as String,
      membersCount: json['members_count'] as int,
      isAdmin: json['is_admin'] as bool,
      isMember: json['is_member'] as bool,
      members: (json['members'] as List<dynamic>)
          .map((e) => GroupMemberModel.fromJson(e as Map<String, dynamic>))
          .toList(),
      admins: (json['admins'] as List<dynamic>)
          .map((e) => GroupAdminModel.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }

  GroupEntity toEntity() {
    return GroupEntity(
      id: id,
      name: name,
      description: description,
      avatar: avatar,
      createdAt: createdAt,
      createdBy: createdBy,
      membersCount: membersCount,
      isAdmin: isAdmin,
      isMember: isMember,
      members: members.map((m) => m.toEntity()).toList(),
      admins: admins.map((a) => a.toEntity()).toList(),
    );
  }
}

class GroupMemberModel {
  final String id;
  final String name;
  final String? avatar;
  final bool isAdmin;
  final DateTime joinedAt;

  GroupMemberModel({
    required this.id,
    required this.name,
    this.avatar,
    required this.isAdmin,
    required this.joinedAt,
  });

  factory GroupMemberModel.fromJson(Map<String, dynamic> json) {
    return GroupMemberModel(
      id: json['id'] as String,
      name: json['name'] as String,
      avatar: json['avatar'] as String?,
      isAdmin: json['is_admin'] as bool,
      joinedAt: DateTime.parse(json['joined_at'] as String),
    );
  }

  GroupMember toEntity() {
    return GroupMember(
      id: id,
      name: name,
      avatar: avatar,
      isAdmin: isAdmin,
      joinedAt: joinedAt,
    );
  }
}

class GroupAdminModel {
  final String id;
  final String name;
  final String? avatar;

  GroupAdminModel({
    required this.id,
    required this.name,
    this.avatar,
  });

  factory GroupAdminModel.fromJson(Map<String, dynamic> json) {
    return GroupAdminModel(
      id: json['id'] as String,
      name: json['name'] as String,
      avatar: json['avatar'] as String?,
    );
  }

  GroupAdmin toEntity() {
    return GroupAdmin(
      id: id,
      name: name,
      avatar: avatar,
    );
  }
}
