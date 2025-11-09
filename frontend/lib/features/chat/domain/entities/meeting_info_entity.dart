import 'package:equatable/equatable.dart';

class MeetingInfo extends Equatable {
  final String title;
  final String platform;
  final DateTime startTime;
  final DateTime endTime;
  final String? meetingLink;
  final bool isAttending;

  const MeetingInfo({
    required this.title,
    required this.platform,
    required this.startTime,
    required this.endTime,
    this.meetingLink,
    required this.isAttending,
  });

  String get formattedDate {
    final day = startTime.day.toString().padLeft(2, '0');
    final month = _getMonthName(startTime.month);
    return '$day $month';
  }

  String get formattedTime {
    final startHour = startTime.hour > 12 ? startTime.hour - 12 : startTime.hour;
    final startMinute = startTime.minute.toString().padLeft(2, '0');
    final startPeriod = startTime.hour >= 12 ? 'PM' : 'AM';

    final endHour = endTime.hour > 12 ? endTime.hour - 12 : endTime.hour;
    final endMinute = endTime.minute.toString().padLeft(2, '0');
    final endPeriod = endTime.hour >= 12 ? 'PM' : 'AM';

    return '($startHour:$startMinute $startPeriod - $endHour:$endMinute $endPeriod)';
  }

  String _getMonthName(int month) {
    const months = [
      'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
      'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'
    ];
    return months[month - 1];
  }

  @override
  List<Object?> get props => [
    title,
    platform,
    startTime,
    endTime,
    meetingLink,
    isAttending,
  ];
}