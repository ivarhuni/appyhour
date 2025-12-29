// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appTitle => 'Happy Hour';

  @override
  String get actionTryAgain => 'Try Again';

  @override
  String get actionRetry => 'Retry';

  @override
  String get actionShowAllBars => 'Show all bars';

  @override
  String get filterAll => 'All';

  @override
  String get filterHappyHourNow => 'Happy Hour Now';

  @override
  String get sortDefault => 'Default';

  @override
  String get sortCheapestBeer => 'Cheapest Beer';

  @override
  String get sortNearest => 'Nearest';

  @override
  String get sortTopRated => 'Top Rated';

  @override
  String get sortLabelPrice => 'Price';

  @override
  String get sortLabelDistance => 'Distance';

  @override
  String get sortLabelRating => 'Rating';

  @override
  String get labelHappyHour => 'HAPPY HOUR';

  @override
  String get labelTwoForOne => '2-for-1';

  @override
  String get labelTwoForOneAvailable => '2-for-1 deals available!';

  @override
  String get labelHappyHourPrices => 'Happy Hour Prices';

  @override
  String get labelBeer => 'Beer';

  @override
  String get labelWine => 'Wine';

  @override
  String get labelNotes => 'Notes';

  @override
  String get labelAbout => 'About';

  @override
  String get labelContact => 'Contact';

  @override
  String get msgOops => 'Oops!';

  @override
  String get msgNoHappyHoursNow => 'No happy hours right now';

  @override
  String get msgNoBarsFound => 'No bars found';

  @override
  String get msgCheckBackLater => 'Check back later or view all bars';

  @override
  String get msgPullToRefresh => 'Pull down to refresh';

  @override
  String get locationEnable => 'Enable location';

  @override
  String get locationEnabled => 'Location enabled';

  @override
  String distanceMeters(int distance) {
    return '${distance}m';
  }

  @override
  String distanceKilometers(String distance) {
    return '${distance}km';
  }
}
