import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_is.dart';
import 'app_localizations_pl.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'gen_l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations)!;
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('is'),
    Locale('pl'),
  ];

  /// Main app title shown in app bar
  ///
  /// In en, this message translates to:
  /// **'Happy Hour'**
  String get appTitle;

  /// Button text for retry actions
  ///
  /// In en, this message translates to:
  /// **'Try Again'**
  String get actionTryAgain;

  /// Short retry button text
  ///
  /// In en, this message translates to:
  /// **'Retry'**
  String get actionRetry;

  /// Link to clear filter and show all bars
  ///
  /// In en, this message translates to:
  /// **'Show all bars'**
  String get actionShowAllBars;

  /// Filter chip to show all bars
  ///
  /// In en, this message translates to:
  /// **'All'**
  String get filterAll;

  /// Filter chip to show only active happy hours
  ///
  /// In en, this message translates to:
  /// **'Happy Hour Now'**
  String get filterHappyHourNow;

  /// Default server order sorting
  ///
  /// In en, this message translates to:
  /// **'Default'**
  String get sortDefault;

  /// Sort by cheapest beer price
  ///
  /// In en, this message translates to:
  /// **'Cheapest Beer'**
  String get sortCheapestBeer;

  /// Sort by distance from user
  ///
  /// In en, this message translates to:
  /// **'Nearest'**
  String get sortNearest;

  /// Sort by rating
  ///
  /// In en, this message translates to:
  /// **'Top Rated'**
  String get sortTopRated;

  /// Short label for price sort
  ///
  /// In en, this message translates to:
  /// **'Price'**
  String get sortLabelPrice;

  /// Short label for distance sort
  ///
  /// In en, this message translates to:
  /// **'Distance'**
  String get sortLabelDistance;

  /// Short label for rating sort
  ///
  /// In en, this message translates to:
  /// **'Rating'**
  String get sortLabelRating;

  /// Happy hour status badge
  ///
  /// In en, this message translates to:
  /// **'HAPPY HOUR'**
  String get labelHappyHour;

  /// Two for one deal badge
  ///
  /// In en, this message translates to:
  /// **'2-for-1'**
  String get labelTwoForOne;

  /// Banner text for 2-for-1 deals
  ///
  /// In en, this message translates to:
  /// **'2-for-1 deals available!'**
  String get labelTwoForOneAvailable;

  /// Section header for prices
  ///
  /// In en, this message translates to:
  /// **'Happy Hour Prices'**
  String get labelHappyHourPrices;

  /// Beer drink type
  ///
  /// In en, this message translates to:
  /// **'Beer'**
  String get labelBeer;

  /// Wine drink type
  ///
  /// In en, this message translates to:
  /// **'Wine'**
  String get labelWine;

  /// Notes section header
  ///
  /// In en, this message translates to:
  /// **'Notes'**
  String get labelNotes;

  /// About section header
  ///
  /// In en, this message translates to:
  /// **'About'**
  String get labelAbout;

  /// Contact section header
  ///
  /// In en, this message translates to:
  /// **'Contact'**
  String get labelContact;

  /// Error state title
  ///
  /// In en, this message translates to:
  /// **'Oops!'**
  String get msgOops;

  /// Empty state when filtering for active happy hours
  ///
  /// In en, this message translates to:
  /// **'No happy hours right now'**
  String get msgNoHappyHoursNow;

  /// General empty state
  ///
  /// In en, this message translates to:
  /// **'No bars found'**
  String get msgNoBarsFound;

  /// Suggestion text in empty state
  ///
  /// In en, this message translates to:
  /// **'Check back later or view all bars'**
  String get msgCheckBackLater;

  /// Refresh hint text
  ///
  /// In en, this message translates to:
  /// **'Pull down to refresh'**
  String get msgPullToRefresh;

  /// Tooltip for location permission button
  ///
  /// In en, this message translates to:
  /// **'Enable location'**
  String get locationEnable;

  /// Tooltip when location is active
  ///
  /// In en, this message translates to:
  /// **'Location enabled'**
  String get locationEnabled;

  /// Distance formatted in meters
  ///
  /// In en, this message translates to:
  /// **'{distance}m'**
  String distanceMeters(int distance);

  /// Distance formatted in kilometers
  ///
  /// In en, this message translates to:
  /// **'{distance}km'**
  String distanceKilometers(String distance);
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['en', 'is', 'pl'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
    case 'is':
      return AppLocalizationsIs();
    case 'pl':
      return AppLocalizationsPl();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
