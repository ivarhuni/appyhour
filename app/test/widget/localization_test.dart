import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:happyhour_app/gen_l10n/app_localizations.dart';

void main() {
  group('AppLocalizations', () {
    Widget buildTestWidget({required Locale locale, required Widget child}) {
      return MaterialApp(
        locale: locale,
        localizationsDelegates: const [
          AppLocalizations.delegate,
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        supportedLocales: const [
          Locale('en'),
          Locale('is'),
          Locale('pl'),
        ],
        home: child,
      );
    }

    testWidgets('English locale loads correctly', (tester) async {
      late AppLocalizations l10n;

      await tester.pumpWidget(
        buildTestWidget(
          locale: const Locale('en'),
          child: Builder(
            builder: (context) {
              l10n = AppLocalizations.of(context);
              return const SizedBox();
            },
          ),
        ),
      );

      expect(l10n.appTitle, 'Happy Hour');
      expect(l10n.filterAll, 'All');
      expect(l10n.filterHappyHourNow, 'Happy Hour Now');
      expect(l10n.msgOops, 'Oops!');
      expect(l10n.labelBeer, 'Beer');
      expect(l10n.labelWine, 'Wine');
    });

    testWidgets('Icelandic locale loads correctly', (tester) async {
      late AppLocalizations l10n;

      await tester.pumpWidget(
        buildTestWidget(
          locale: const Locale('is'),
          child: Builder(
            builder: (context) {
              l10n = AppLocalizations.of(context);
              return const SizedBox();
            },
          ),
        ),
      );

      expect(l10n.appTitle, 'Gleðistund');
      expect(l10n.filterAll, 'Allt');
      expect(l10n.filterHappyHourNow, 'Gleðistund núna');
      expect(l10n.msgOops, 'Úps!');
      expect(l10n.labelBeer, 'Bjór');
      expect(l10n.labelWine, 'Vín');
    });

    testWidgets('Polish locale loads correctly', (tester) async {
      late AppLocalizations l10n;

      await tester.pumpWidget(
        buildTestWidget(
          locale: const Locale('pl'),
          child: Builder(
            builder: (context) {
              l10n = AppLocalizations.of(context);
              return const SizedBox();
            },
          ),
        ),
      );

      expect(l10n.appTitle, 'Happy Hour');
      expect(l10n.filterAll, 'Wszystkie');
      expect(l10n.filterHappyHourNow, 'Happy Hour teraz');
      expect(l10n.msgOops, 'Ups!');
      expect(l10n.labelBeer, 'Piwo');
      expect(l10n.labelWine, 'Wino');
    });

    testWidgets('Unsupported locale falls back to English', (tester) async {
      late AppLocalizations l10n;

      await tester.pumpWidget(
        buildTestWidget(
          locale: const Locale('fr'), // French - not supported
          child: Builder(
            builder: (context) {
              l10n = AppLocalizations.of(context);
              return const SizedBox();
            },
          ),
        ),
      );

      // Should fall back to English
      expect(l10n.appTitle, 'Happy Hour');
      expect(l10n.filterAll, 'All');
    });

    testWidgets('Distance formatting works with placeholders', (tester) async {
      late AppLocalizations l10n;

      await tester.pumpWidget(
        buildTestWidget(
          locale: const Locale('en'),
          child: Builder(
            builder: (context) {
              l10n = AppLocalizations.of(context);
              return const SizedBox();
            },
          ),
        ),
      );

      expect(l10n.distanceMeters(500), '500m');
      expect(l10n.distanceKilometers('1.5'), '1.5km');
    });
  });
}
