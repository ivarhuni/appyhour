import 'package:flutter_test/flutter_test.dart';
import 'package:happyhour_app/domain/bars/models/happy_hour_time.dart';

void main() {
  group('HappyHourTime', () {
    group('parse', () {
      test('parses standard format "15:00 - 17:00"', () {
        final time = HappyHourTime.parse('15:00 - 17:00');
        expect(time.startHour, 15);
        expect(time.startMinute, 0);
        expect(time.endHour, 17);
        expect(time.endMinute, 0);
      });

      test('parses format without spaces "15:00-17:00"', () {
        final time = HappyHourTime.parse('15:00-17:00');
        expect(time.startHour, 15);
        expect(time.startMinute, 0);
        expect(time.endHour, 17);
        expect(time.endMinute, 0);
      });

      test('parses format with minutes "15:30 - 17:45"', () {
        final time = HappyHourTime.parse('15:30 - 17:45');
        expect(time.startHour, 15);
        expect(time.startMinute, 30);
        expect(time.endHour, 17);
        expect(time.endMinute, 45);
      });

      test('parses overnight format "22:00 - 02:00"', () {
        final time = HappyHourTime.parse('22:00 - 02:00');
        expect(time.startHour, 22);
        expect(time.startMinute, 0);
        expect(time.endHour, 2);
        expect(time.endMinute, 0);
      });

      test('handles invalid format gracefully', () {
        final time = HappyHourTime.parse('invalid');
        expect(time.startHour, 0);
        expect(time.startMinute, 0);
        expect(time.endHour, 0);
        expect(time.endMinute, 0);
      });
    });

    group('isActiveAt', () {
      test('returns true when time is within normal window', () {
        final time = HappyHourTime.parse('15:00 - 17:00');
        final testTime = DateTime(2024, 1, 1, 16);
        expect(time.isActiveAt(testTime), true);
      });

      test('returns true at start time', () {
        final time = HappyHourTime.parse('15:00 - 17:00');
        final testTime = DateTime(2024, 1, 1, 15);
        expect(time.isActiveAt(testTime), true);
      });

      test('returns true at end time', () {
        final time = HappyHourTime.parse('15:00 - 17:00');
        final testTime = DateTime(2024, 1, 1, 17);
        expect(time.isActiveAt(testTime), true);
      });

      test('returns false before start time', () {
        final time = HappyHourTime.parse('15:00 - 17:00');
        final testTime = DateTime(2024, 1, 1, 14, 59);
        expect(time.isActiveAt(testTime), false);
      });

      test('returns false after end time', () {
        final time = HappyHourTime.parse('15:00 - 17:00');
        final testTime = DateTime(2024, 1, 1, 17, 1);
        expect(time.isActiveAt(testTime), false);
      });

      test('handles overnight span - before midnight', () {
        final time = HappyHourTime.parse('22:00 - 02:00');
        final testTime = DateTime(2024, 1, 1, 23);
        expect(time.isActiveAt(testTime), true);
      });

      test('handles overnight span - after midnight', () {
        final time = HappyHourTime.parse('22:00 - 02:00');
        final testTime = DateTime(2024, 1, 2, 1);
        expect(time.isActiveAt(testTime), true);
      });

      test('handles overnight span - outside window (afternoon)', () {
        final time = HappyHourTime.parse('22:00 - 02:00');
        final testTime = DateTime(2024, 1, 1, 15);
        expect(time.isActiveAt(testTime), false);
      });

      test('handles overnight span - exactly at start', () {
        final time = HappyHourTime.parse('22:00 - 02:00');
        final testTime = DateTime(2024, 1, 1, 22);
        expect(time.isActiveAt(testTime), true);
      });

      test('handles overnight span - exactly at end', () {
        final time = HappyHourTime.parse('22:00 - 02:00');
        final testTime = DateTime(2024, 1, 2, 2);
        expect(time.isActiveAt(testTime), true);
      });

      test('returns false for invalid time (same start and end)', () {
        final time = HappyHourTime.parse('invalid');
        final testTime = DateTime(2024, 1, 1, 12);
        expect(time.isActiveAt(testTime), false);
      });
    });

    group('displayString', () {
      test('returns original string', () {
        final time = HappyHourTime.parse('15:00 - 17:00');
        expect(time.displayString, '15:00 - 17:00');
      });
    });

    group('equality', () {
      test('equal times are equal', () {
        final time1 = HappyHourTime.parse('15:00 - 17:00');
        final time2 = HappyHourTime.parse('15:00 - 17:00');
        expect(time1, time2);
      });

      test('different times are not equal', () {
        final time1 = HappyHourTime.parse('15:00 - 17:00');
        final time2 = HappyHourTime.parse('16:00 - 18:00');
        expect(time1, isNot(time2));
      });
    });
  });
}
