import 'package:equatable/equatable.dart';

/// Value object for happy hour day availability.
/// Parses strings like "Every day", "Mon-Fri", "Weekends".
class HappyHourDays extends Equatable {
  final Set<int> activeDays; // 1=Monday ... 7=Sunday (ISO weekday)
  final String _rawString;

  const HappyHourDays._({
    required this.activeDays,
    required String rawString,
  }) : _rawString = rawString;

  /// Parse from display string
  factory HappyHourDays.parse(String daysString) {
    final trimmed = daysString.trim().toLowerCase();
    final Set<int> days;

    if (trimmed == 'every day' || trimmed == 'alla daga') {
      days = {1, 2, 3, 4, 5, 6, 7};
    } else if (trimmed == 'mon-fri' ||
        trimmed == 'weekdays' ||
        trimmed == 'mán-fös' ||
        trimmed == 'virka daga') {
      days = {1, 2, 3, 4, 5};
    } else if (trimmed == 'weekends' ||
        trimmed == 'sat-sun' ||
        trimmed == 'helgar' ||
        trimmed == 'lau-sun') {
      days = {6, 7};
    } else if (trimmed == 'mon-thu' || trimmed == 'mán-fim') {
      days = {1, 2, 3, 4};
    } else if (trimmed == 'mon-sat' || trimmed == 'mán-lau') {
      days = {1, 2, 3, 4, 5, 6};
    } else if (trimmed == 'sun-thu' || trimmed == 'sun-fim') {
      days = {1, 2, 3, 4, 7};
    } else {
      // Try to parse individual day abbreviations
      days = _parseDayAbbreviations(trimmed);
    }

    return HappyHourDays._(
      activeDays: days,
      rawString: daysString.trim(),
    );
  }

  static Set<int> _parseDayAbbreviations(String input) {
    final Set<int> days = {};
    final dayMap = {
      'mon': 1,
      'mán': 1,
      'monday': 1,
      'tue': 2,
      'þri': 2,
      'tuesday': 2,
      'wed': 3,
      'mið': 3,
      'wednesday': 3,
      'thu': 4,
      'fim': 4,
      'thursday': 4,
      'fri': 5,
      'fös': 5,
      'friday': 5,
      'sat': 6,
      'lau': 6,
      'saturday': 6,
      'sun': 7,
      'sunnudagur': 7,
      'sunday': 7,
    };

    for (final entry in dayMap.entries) {
      if (input.contains(entry.key)) {
        days.add(entry.value);
      }
    }

    // Default to every day if we couldn't parse anything
    if (days.isEmpty) {
      return {1, 2, 3, 4, 5, 6, 7};
    }

    return days;
  }

  /// Check if a given weekday is active
  bool isActiveOn(int weekday) {
    return activeDays.contains(weekday);
  }

  /// Original display string
  String get displayString => _rawString;

  @override
  List<Object?> get props => [activeDays];
}
