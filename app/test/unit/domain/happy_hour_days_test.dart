import 'package:flutter_test/flutter_test.dart';
import 'package:happyhour_app/domain/value_objects/happy_hour_days.dart';

void main() {
  group('HappyHourDays', () {
    group('parse', () {
      test('parses "Every day"', () {
        final days = HappyHourDays.parse('Every day');
        expect(days.activeDays, {1, 2, 3, 4, 5, 6, 7});
      });

      test('parses "Mon-Fri"', () {
        final days = HappyHourDays.parse('Mon-Fri');
        expect(days.activeDays, {1, 2, 3, 4, 5});
      });

      test('parses "Weekdays"', () {
        final days = HappyHourDays.parse('Weekdays');
        expect(days.activeDays, {1, 2, 3, 4, 5});
      });

      test('parses "Weekends"', () {
        final days = HappyHourDays.parse('Weekends');
        expect(days.activeDays, {6, 7});
      });

      test('parses "Sat-Sun"', () {
        final days = HappyHourDays.parse('Sat-Sun');
        expect(days.activeDays, {6, 7});
      });

      test('parses case-insensitively', () {
        final days = HappyHourDays.parse('EVERY DAY');
        expect(days.activeDays, {1, 2, 3, 4, 5, 6, 7});
      });

      test('handles unknown pattern as every day', () {
        final days = HappyHourDays.parse('Special Days');
        expect(days.activeDays, {1, 2, 3, 4, 5, 6, 7});
      });
    });

    group('isActiveOn', () {
      test('returns true for active day', () {
        final days = HappyHourDays.parse('Mon-Fri');
        expect(days.isActiveOn(1), true); // Monday
        expect(days.isActiveOn(3), true); // Wednesday
        expect(days.isActiveOn(5), true); // Friday
      });

      test('returns false for inactive day', () {
        final days = HappyHourDays.parse('Mon-Fri');
        expect(days.isActiveOn(6), false); // Saturday
        expect(days.isActiveOn(7), false); // Sunday
      });

      test('every day returns true for all days', () {
        final days = HappyHourDays.parse('Every day');
        for (int i = 1; i <= 7; i++) {
          expect(days.isActiveOn(i), true);
        }
      });

      test('weekends returns true only for Saturday and Sunday', () {
        final days = HappyHourDays.parse('Weekends');
        expect(days.isActiveOn(1), false); // Monday
        expect(days.isActiveOn(5), false); // Friday
        expect(days.isActiveOn(6), true); // Saturday
        expect(days.isActiveOn(7), true); // Sunday
      });
    });

    group('displayString', () {
      test('returns original string', () {
        final days = HappyHourDays.parse('Mon-Fri');
        expect(days.displayString, 'Mon-Fri');
      });
    });

    group('equality', () {
      test('equal days are equal', () {
        final days1 = HappyHourDays.parse('Mon-Fri');
        final days2 = HappyHourDays.parse('Weekdays');
        expect(days1, days2);
      });

      test('different days are not equal', () {
        final days1 = HappyHourDays.parse('Mon-Fri');
        final days2 = HappyHourDays.parse('Weekends');
        expect(days1, isNot(days2));
      });
    });
  });
}
