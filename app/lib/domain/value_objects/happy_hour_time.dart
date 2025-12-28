import 'package:equatable/equatable.dart';

/// Value object representing a happy hour time window.
/// Handles overnight spans (e.g., 22:00 - 02:00).
class HappyHourTime extends Equatable {
  final int startHour;
  final int startMinute;
  final int endHour;
  final int endMinute;
  final String _rawString;

  const HappyHourTime._({
    required this.startHour,
    required this.startMinute,
    required this.endHour,
    required this.endMinute,
    required String rawString,
  }) : _rawString = rawString;

  /// Parse from "HH:MM - HH:MM" format
  factory HappyHourTime.parse(String timeString) {
    final trimmed = timeString.trim();

    // Match pattern like "15:00 - 17:00" or "15:00-17:00"
    final regex = RegExp(r'^(\d{1,2}):(\d{2})\s*-\s*(\d{1,2}):(\d{2})$');
    final match = regex.firstMatch(trimmed);

    if (match == null) {
      // Return a default invalid time that is never active
      return HappyHourTime._(
        startHour: 0,
        startMinute: 0,
        endHour: 0,
        endMinute: 0,
        rawString: trimmed,
      );
    }

    return HappyHourTime._(
      startHour: int.parse(match.group(1)!),
      startMinute: int.parse(match.group(2)!),
      endHour: int.parse(match.group(3)!),
      endMinute: int.parse(match.group(4)!),
      rawString: trimmed,
    );
  }

  /// Check if given time falls within this window
  /// Handles overnight spans correctly
  bool isActiveAt(DateTime time) {
    final currentMinutes = time.hour * 60 + time.minute;
    final startMinutes = startHour * 60 + startMinute;
    final endMinutes = endHour * 60 + endMinute;

    // If start and end are the same, treat as invalid/never active
    if (startMinutes == endMinutes) {
      return false;
    }

    // Check if this is an overnight span (e.g., 22:00 - 02:00)
    if (endMinutes < startMinutes) {
      // Active if: currentTime >= startTime OR currentTime <= endTime
      return currentMinutes >= startMinutes || currentMinutes <= endMinutes;
    } else {
      // Normal daytime window
      // Active if: currentTime >= startTime AND currentTime <= endTime
      return currentMinutes >= startMinutes && currentMinutes <= endMinutes;
    }
  }

  /// Format for display: "15:00 - 19:00"
  String get displayString => _rawString;

  @override
  List<Object?> get props => [startHour, startMinute, endHour, endMinute];
}
