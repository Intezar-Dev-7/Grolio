// features/groups/data/datasources/group_remote_datasource.dart

import 'package:dio/dio.dart';
import 'package:frontend/config/api_endpoints.dart';
import 'package:frontend/features/groups/data/model/group_model.dart';
import '../../../../core/error/exceptions.dart';
import '../../../../core/network/dio_client.dart';
import '../../domain/entities/group_entity.dart';

abstract class GroupRemoteDataSource {
  Future<GroupEntity> getGroupDetails(String groupId);
  Future<void> exitGroup(String groupId);
  Future<void> addMember(String groupId, String userId);
  Future<void> removeMember(String groupId, String memberId);
  Future<void> promoteToAdmin(String groupId, String memberId);
  Future<void> demoteAdmin(String groupId, String adminId);
  Future<void> reportGroup(String groupId);
  Future<List<Map<String, dynamic>>> getGroupMedia(String groupId);
}

class GroupRemoteDataSourceImpl implements GroupRemoteDataSource {
  final DioClient dioClient;

  GroupRemoteDataSourceImpl({required this.dioClient});

/*  @override
  Future<GroupEntity> getGroupDetails(String groupId) async {
    try {
      final response = await dioClient.get(
        ApiEndpoints.getGroupDetails(groupId),
      );

      if (response.statusCode == 200) {
        final groupModel = GroupModel.fromJson(
          response.data['data'] ?? response.data,
        );
        return groupModel.toEntity();
      } else {
        throw ServerException(message: 'Failed to load group details');
      }
    } catch (e) {
      if (e is DioException) {
        throw ServerException(
          message: e.response?.data['message'] ?? 'Network error',
        );
      }
      throw ServerException(message: e.toString());
    }
  }*/

  @override
  Future<GroupEntity> getGroupDetails(String groupId) async {
    try {
      // Simulate network delay
      await Future.delayed(const Duration(seconds: 1));

      Map<String, dynamic> mockData;

      if (groupId == 'group_001') {
        mockData = mockGroupData;
      } else if (groupId == 'group_002') {
        mockData = mockGroupData2;
      } else if (groupId == 'group_003') {
        mockData = mockGroupData3;
      } else {
        throw ServerException(message: 'Group not found');
      }

      final groupModel = GroupModel.fromJson(mockData);
      return groupModel.toEntity();
    } catch (e) {
      throw ServerException(message: 'Failed to load group details: $e');
    }
  }

  @override
  Future<List<Map<String, dynamic>>> getGroupMedia(String groupId) async {
    await Future.delayed(const Duration(milliseconds: 500));

    return [
      {
        'id': 'media_001',
        'type': 'image',
        'url': 'https://via.placeholder.com/150',
        'uploaded_at': '2024-11-01T10:30:00Z',
      },
      {
        'id': 'media_002',
        'type': 'image',
        'url': 'https://via.placeholder.com/150',
        'uploaded_at': '2024-11-01T09:15:00Z',
      },
      {
        'id': 'media_003',
        'type': 'document',
        'url': 'sample.pdf',
        'uploaded_at': '2024-10-31T14:20:00Z',
      },
      {
        'id': 'media_004',
        'type': 'image',
        'url': 'https://via.placeholder.com/150',
        'uploaded_at': '2024-10-30T11:00:00Z',
      },
    ];
  }

  @override
  Future<void> exitGroup(String groupId) async {
    try {
      final response = await dioClient.post(
        ApiEndpoints.exitGroup(groupId),
      );

      if (response.statusCode != 200 && response.statusCode != 204) {
        throw ServerException(message: 'Failed to exit group');
      }
    } catch (e) {
      throw ServerException(message: e.toString());
    }
  }

  @override
  Future<void> addMember(String groupId, String userId) async {
    try {
      final response = await dioClient.post(
        ApiEndpoints.addMember(groupId),
        data: {'user_id': userId},
      );

      if (response.statusCode != 200 && response.statusCode != 201) {
        throw ServerException(message: 'Failed to add member');
      }
    } catch (e) {
      throw ServerException(message: e.toString());
    }
  }

  @override
  Future<void> removeMember(String groupId, String memberId) async {
    try {
      final response = await dioClient.delete(
        ApiEndpoints.removeMember(groupId, memberId),
      );

      if (response.statusCode != 200 && response.statusCode != 204) {
        throw ServerException(message: 'Failed to remove member');
      }
    } catch (e) {
      throw ServerException(message: e.toString());
    }
  }

  @override
  Future<void> promoteToAdmin(String groupId, String memberId) async {
    try {
      final response = await dioClient.post(
        ApiEndpoints.promoteToAdmin(groupId),
        data: {'user_id': memberId},
      );

      if (response.statusCode != 200 && response.statusCode != 201) {
        throw ServerException(message: 'Failed to promote to admin');
      }
    } catch (e) {
      throw ServerException(message: e.toString());
    }
  }

  @override
  Future<void> demoteAdmin(String groupId, String adminId) async {
    try {
      final response = await dioClient.delete(
        ApiEndpoints.demoteAdmin(groupId, adminId),
      );

      if (response.statusCode != 200 && response.statusCode != 204) {
        throw ServerException(message: 'Failed to demote admin');
      }
    } catch (e) {
      throw ServerException(message: e.toString());
    }
  }

  @override
  Future<void> reportGroup(String groupId) async {
    try {
      final response = await dioClient.post(
        ApiEndpoints.reportGroup(groupId),
        data: {
          'reason': 'Inappropriate content',
          'reported_at': DateTime.now().toIso8601String(),
        },
      );

      if (response.statusCode != 200 && response.statusCode != 201) {
        throw ServerException(message: 'Failed to report group');
      }
    } catch (e) {
      throw ServerException(message: e.toString());
    }
  }

/*  @override
  Future<List<Map<String, dynamic>>> getGroupMedia(String groupId) async {
    try {
      final response = await dioClient.get(
        ApiEndpoints.getGroupMedia(groupId),
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = response.data['data'] ?? [];
        return data.map((e) => e as Map<String, dynamic>).toList();
      } else {
        throw ServerException(message: 'Failed to load media');
      }
    } catch (e) {
      return [];
    }
  }*/

  final mockGroupData = {
    "id": "group_001",
    "name": "M-13 BCA IV Sem Statistics 2024-25",
    "description": "A collaborative group for BCA students studying Advanced Statistics. Here we share notes, doubts, and discussion materials.",
    "avatar": "https://via.placeholder.com/150/0066cc/ffffff?text=Statistics",
    "created_at": "2024-08-15T10:30:00Z",
    "created_by": "user_001",
    "members_count": 24,
    "is_admin": true,
    "is_member": true,
    "members": [
      {
        "id": "user_001",
        "name": "Anmol Kumar",
        "avatar": "https://via.placeholder.com/150/FF6B6B/ffffff?text=AK",
        "is_admin": true,
        "joined_at": "2024-08-15T10:30:00Z"
      },
      {
        "id": "user_002",
        "name": "Hemant Singh",
        "avatar": "https://via.placeholder.com/150/4ECDC4/ffffff?text=HS",
        "is_admin": true,
        "joined_at": "2024-08-15T10:35:00Z"
      },
      {
        "id": "user_003",
        "name": "Priya Sharma",
        "avatar": "https://via.placeholder.com/150/95E1D3/ffffff?text=PS",
        "is_admin": false,
        "joined_at": "2024-08-15T11:00:00Z"
      },
      {
        "id": "user_004",
        "name": "Rahul Patel",
        "avatar": "https://via.placeholder.com/150/F38181/ffffff?text=RP",
        "is_admin": false,
        "joined_at": "2024-08-15T11:15:00Z"
      },
      {
        "id": "user_005",
        "name": "Neha Gupta",
        "avatar": "https://via.placeholder.com/150/AA96DA/ffffff?text=NG",
        "is_admin": false,
        "joined_at": "2024-08-15T11:30:00Z"
      },
      {
        "id": "user_006",
        "name": "Arjun Verma",
        "avatar": "https://via.placeholder.com/150/FCBAD3/ffffff?text=AV",
        "is_admin": false,
        "joined_at": "2024-08-16T09:00:00Z"
      },
      {
        "id": "user_007",
        "name": "Divya Malhotra",
        "avatar": "https://via.placeholder.com/150/A8D8EA/ffffff?text=DM",
        "is_admin": false,
        "joined_at": "2024-08-16T10:00:00Z"
      },
      {
        "id": "user_008",
        "name": "Vikram Singh",
        "avatar": "https://via.placeholder.com/150/FF9999/ffffff?text=VS",
        "is_admin": false,
        "joined_at": "2024-08-16T11:00:00Z"
      },
    ],
    "admins": [
      {
        "id": "user_001",
        "name": "Anmol Kumar",
        "avatar": "https://via.placeholder.com/150/FF6B6B/ffffff?text=AK"
      },
      {
        "id": "user_002",
        "name": "Hemant Singh",
        "avatar": "https://via.placeholder.com/150/4ECDC4/ffffff?text=HS"
      }
    ]
  };

  final mockGroupData2 = {
    "id": "group_002",
    "name": "Chutiyaapaa 💀😂",
    "description": "Friends group for casual talks and memes",
    "avatar": "https://via.placeholder.com/150/FF1744/ffffff?text=Friends",
    "created_at": "2024-07-10T14:20:00Z",
    "created_by": "user_003",
    "members_count": 12,
    "is_admin": false,
    "is_member": true,
    "members": [
      {
        "id": "user_003",
        "name": "ANUJ Kumar",
        "avatar": "https://via.placeholder.com/150/FF6B6B/ffffff?text=AN",
        "is_admin": true,
        "joined_at": "2024-07-10T14:20:00Z"
      },
      {
        "id": "user_009",
        "name": "Archana Singh",
        "avatar": "https://via.placeholder.com/150/4ECDC4/ffffff?text=AR",
        "is_admin": false,
        "joined_at": "2024-07-10T14:25:00Z"
      },
      {
        "id": "user_010",
        "name": "Butki Sharma",
        "avatar": "https://via.placeholder.com/150/95E1D3/ffffff?text=BS",
        "is_admin": false,
        "joined_at": "2024-07-10T14:30:00Z"
      },
      {
        "id": "user_011",
        "name": "Hemant Verma",
        "avatar": "https://via.placeholder.com/150/F38181/ffffff?text=HV",
        "is_admin": false,
        "joined_at": "2024-07-10T14:35:00Z"
      },
      {
        "id": "user_012",
        "name": "Kaddu Singh",
        "avatar": "https://via.placeholder.com/150/AA96DA/ffffff?text=KS",
        "is_admin": false,
        "joined_at": "2024-07-10T15:00:00Z"
      },
      {
        "id": "user_013",
        "name": "Khusboo Malhotra",
        "avatar": "https://via.placeholder.com/150/FCBAD3/ffffff?text=KM",
        "is_admin": false,
        "joined_at": "2024-07-11T09:00:00Z"
      },
    ],
    "admins": [
      {
        "id": "user_003",
        "name": "ANUJ Kumar",
        "avatar": "https://via.placeholder.com/150/FF6B6B/ffffff?text=AN"
      }
    ]
  };

  final mockGroupData3 = {
    "id": "group_003",
    "name": "Web Development Team",
    "description": "Team for collaborative web development projects and learning",
    "avatar": "https://via.placeholder.com/150/00BCD4/ffffff?text=WebDev",
    "created_at": "2024-09-01T08:00:00Z",
    "created_by": "user_014",
    "members_count": 18,
    "is_admin": false,
    "is_member": true,
    "members": [
      {
        "id": "user_014",
        "name": "Rajesh Kumar",
        "avatar": "https://via.placeholder.com/150/FF6B6B/ffffff?text=RK",
        "is_admin": true,
        "joined_at": "2024-09-01T08:00:00Z"
      },
      {
        "id": "user_015",
        "name": "Sneha Patel",
        "avatar": "https://via.placeholder.com/150/4ECDC4/ffffff?text=SP",
        "is_admin": true,
        "joined_at": "2024-09-01T08:15:00Z"
      },
      {
        "id": "user_016",
        "name": "Rohan Desai",
        "avatar": "https://via.placeholder.com/150/95E1D3/ffffff?text=RD",
        "is_admin": false,
        "joined_at": "2024-09-01T09:00:00Z"
      },
      {
        "id": "user_017",
        "name": "Pooja Trivedi",
        "avatar": "https://via.placeholder.com/150/F38181/ffffff?text=PT",
        "is_admin": false,
        "joined_at": "2024-09-01T10:00:00Z"
      },
      {
        "id": "user_018",
        "name": "Anil Kumar",
        "avatar": "https://via.placeholder.com/150/AA96DA/ffffff?text=AK",
        "is_admin": false,
        "joined_at": "2024-09-02T09:00:00Z"
      },
    ],
    "admins": [
      {
        "id": "user_014",
        "name": "Rajesh Kumar",
        "avatar": "https://via.placeholder.com/150/FF6B6B/ffffff?text=RK"
      },
      {
        "id": "user_015",
        "name": "Sneha Patel",
        "avatar": "https://via.placeholder.com/150/4ECDC4/ffffff?text=SP"
      }
    ]
  };
}
