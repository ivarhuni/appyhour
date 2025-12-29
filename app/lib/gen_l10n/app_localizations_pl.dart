// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Polish (`pl`).
class AppLocalizationsPl extends AppLocalizations {
  AppLocalizationsPl([String locale = 'pl']) : super(locale);

  @override
  String get appTitle => 'Happy Hour';

  @override
  String get actionTryAgain => 'Spróbuj ponownie';

  @override
  String get actionRetry => 'Ponów';

  @override
  String get actionShowAllBars => 'Pokaż wszystkie bary';

  @override
  String get filterAll => 'Wszystkie';

  @override
  String get filterHappyHourNow => 'Happy Hour teraz';

  @override
  String get sortDefault => 'Domyślne';

  @override
  String get sortCheapestBeer => 'Najtańsze piwo';

  @override
  String get sortNearest => 'Najbliższe';

  @override
  String get sortTopRated => 'Najlepiej oceniane';

  @override
  String get sortLabelPrice => 'Cena';

  @override
  String get sortLabelDistance => 'Odległość';

  @override
  String get sortLabelRating => 'Ocena';

  @override
  String get labelHappyHour => 'HAPPY HOUR';

  @override
  String get labelTwoForOne => '2 za 1';

  @override
  String get labelTwoForOneAvailable => 'Oferty 2 za 1 dostępne!';

  @override
  String get labelHappyHourPrices => 'Ceny Happy Hour';

  @override
  String get labelBeer => 'Piwo';

  @override
  String get labelWine => 'Wino';

  @override
  String get labelNotes => 'Uwagi';

  @override
  String get labelAbout => 'O nas';

  @override
  String get labelContact => 'Kontakt';

  @override
  String get msgOops => 'Ups!';

  @override
  String get msgNoHappyHoursNow => 'Brak happy hours w tej chwili';

  @override
  String get msgNoBarsFound => 'Nie znaleziono barów';

  @override
  String get msgCheckBackLater => 'Sprawdź później lub zobacz wszystkie bary';

  @override
  String get msgPullToRefresh => 'Pociągnij w dół, aby odświeżyć';

  @override
  String get locationEnable => 'Włącz lokalizację';

  @override
  String get locationEnabled => 'Lokalizacja włączona';

  @override
  String distanceMeters(int distance) {
    return '${distance}m';
  }

  @override
  String distanceKilometers(String distance) {
    return '${distance}km';
  }
}
