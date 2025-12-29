// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Icelandic (`is`).
class AppLocalizationsIs extends AppLocalizations {
  AppLocalizationsIs([String locale = 'is']) : super(locale);

  @override
  String get appTitle => 'Gleðistund';

  @override
  String get actionTryAgain => 'Reyna aftur';

  @override
  String get actionRetry => 'Reyna';

  @override
  String get actionShowAllBars => 'Sýna alla staði';

  @override
  String get filterAll => 'Allt';

  @override
  String get filterHappyHourNow => 'Gleðistund núna';

  @override
  String get sortDefault => 'Sjálfgefið';

  @override
  String get sortCheapestBeer => 'Ódýrast bjór';

  @override
  String get sortNearest => 'Næst';

  @override
  String get sortTopRated => 'Hæst metið';

  @override
  String get sortLabelPrice => 'Verð';

  @override
  String get sortLabelDistance => 'Fjarlægð';

  @override
  String get sortLabelRating => 'Einkunn';

  @override
  String get labelHappyHour => 'GLEÐISTUND';

  @override
  String get labelTwoForOne => '2-fyrir-1';

  @override
  String get labelTwoForOneAvailable => '2-fyrir-1 tilboð í boði!';

  @override
  String get labelHappyHourPrices => 'Gleðistundarverð';

  @override
  String get labelBeer => 'Bjór';

  @override
  String get labelWine => 'Vín';

  @override
  String get labelNotes => 'Athugasemdir';

  @override
  String get labelAbout => 'Um';

  @override
  String get labelContact => 'Hafa samband';

  @override
  String get msgOops => 'Úps!';

  @override
  String get msgNoHappyHoursNow => 'Engar gleðistundir núna';

  @override
  String get msgNoBarsFound => 'Engir staðir fundust';

  @override
  String get msgCheckBackLater => 'Athugaðu aftur síðar eða skoðaðu alla staði';

  @override
  String get msgPullToRefresh => 'Dragðu niður til að uppfæra';

  @override
  String get locationEnable => 'Virkja staðsetningu';

  @override
  String get locationEnabled => 'Staðsetning virk';

  @override
  String distanceMeters(int distance) {
    return '${distance}m';
  }

  @override
  String distanceKilometers(String distance) {
    return '${distance}km';
  }
}
