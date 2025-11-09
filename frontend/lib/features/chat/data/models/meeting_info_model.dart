import 'package:frontend/features/chat/domain/entities/meeting_info_entity.dart';

class MeetingInfoModel {
  final String title;
  final String platform;
  final DateTime startTime;
  final DateTime endTime;
  final String? meetingLink;
  final bool isAttending;

  MeetingInfoModel({
    required this.title,
    required this.platform,
    required this.startTime,
    required this.endTime,
    this.meetingLink,
    required this.isAttending,
  });

  factory MeetingInfoModel.fromJson(Map<String, dynamic> json) {
    return MeetingInfoModel(
      title: json['title'] as String,
      platform: json['platform'] as String,
      startTime: DateTime.parse(json['start_time'] as String),
      endTime: DateTime.parse(json['end_time'] as String),
      meetingLink: json['meeting_link'] as String?,
      isAttending: json['is_attending'] as bool,
    );
  }

  MeetingInfo toEntity() {
    return MeetingInfo(
      title: title,
      platform: platform,
      startTime: startTime,
      endTime: endTime,
      meetingLink: meetingLink,
      isAttending: isAttending,
    );
  }
}