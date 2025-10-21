import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_fr.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
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

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
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
    Locale('fr')
  ];

  /// No description provided for @title.
  ///
  /// In en, this message translates to:
  /// **'Brain Memory'**
  String get title;

  /// No description provided for @start.
  ///
  /// In en, this message translates to:
  /// **'Start'**
  String get start;

  /// No description provided for @chooseMode.
  ///
  /// In en, this message translates to:
  /// **'Choose mode'**
  String get chooseMode;

  /// No description provided for @letters.
  ///
  /// In en, this message translates to:
  /// **'Letters'**
  String get letters;

  /// No description provided for @numbers.
  ///
  /// In en, this message translates to:
  /// **'Numbers'**
  String get numbers;

  /// No description provided for @level.
  ///
  /// In en, this message translates to:
  /// **'Level'**
  String get level;

  /// No description provided for @gameOver.
  ///
  /// In en, this message translates to:
  /// **'Game Over'**
  String get gameOver;

  /// No description provided for @yourAnswer.
  ///
  /// In en, this message translates to:
  /// **'Your answer'**
  String get yourAnswer;

  /// No description provided for @correctAnswer.
  ///
  /// In en, this message translates to:
  /// **'Correct answer'**
  String get correctAnswer;

  /// No description provided for @playAgain.
  ///
  /// In en, this message translates to:
  /// **'Play again'**
  String get playAgain;

  /// No description provided for @go.
  ///
  /// In en, this message translates to:
  /// **'Go'**
  String get go;

  /// No description provided for @whatWasLetter.
  ///
  /// In en, this message translates to:
  /// **'What was the letter ?'**
  String get whatWasLetter;

  /// No description provided for @whatWasLetters.
  ///
  /// In en, this message translates to:
  /// **'What were the letters ?'**
  String get whatWasLetters;

  /// No description provided for @whatWasNumber.
  ///
  /// In en, this message translates to:
  /// **'What was the number ?'**
  String get whatWasNumber;

  /// No description provided for @whatWasNumbers.
  ///
  /// In en, this message translates to:
  /// **'What were the numbers ?'**
  String get whatWasNumbers;

  /// No description provided for @send.
  ///
  /// In en, this message translates to:
  /// **'Send'**
  String get send;

  /// No description provided for @myScore.
  ///
  /// In en, this message translates to:
  /// **'My Score'**
  String get myScore;

  /// No description provided for @shareScrore.
  ///
  /// In en, this message translates to:
  /// **'Share score'**
  String get shareScrore;

  /// No description provided for @share.
  ///
  /// In en, this message translates to:
  /// **'Share'**
  String get share;

  /// No description provided for @chooseYourPseudo.
  ///
  /// In en, this message translates to:
  /// **'Choose your pseudo'**
  String get chooseYourPseudo;

  /// No description provided for @enterPseudo.
  ///
  /// In en, this message translates to:
  /// **'Enter pseudo'**
  String get enterPseudo;

  /// No description provided for @loadingBestScorer.
  ///
  /// In en, this message translates to:
  /// **'Loading the best scorer'**
  String get loadingBestScorer;

  /// No description provided for @worldBestScore.
  ///
  /// In en, this message translates to:
  /// **'⭐️ World Best Score'**
  String get worldBestScore;

  /// No description provided for @worldRanking.
  ///
  /// In en, this message translates to:
  /// **'⭐️ World Ranking'**
  String get worldRanking;

  /// No description provided for @viewHighestScore.
  ///
  /// In en, this message translates to:
  /// **'My Highest Score'**
  String get viewHighestScore;

  /// No description provided for @shareApp.
  ///
  /// In en, this message translates to:
  /// **'Share the App'**
  String get shareApp;

  /// No description provided for @yourHighestScore.
  ///
  /// In en, this message translates to:
  /// **'Your Highest Score'**
  String get yourHighestScore;

  /// No description provided for @noScore.
  ///
  /// In en, this message translates to:
  /// **'No score'**
  String get noScore;

  /// No description provided for @seeTop10WorldRanking.
  ///
  /// In en, this message translates to:
  /// **'See Top {quantity} World ranking'**
  String seeTop10WorldRanking(Object quantity);

  /// No description provided for @shareScoreMsg.
  ///
  /// In en, this message translates to:
  /// **'I just scored {score} in Brain Memo 123 🧠🔥! Think you can beat me?'**
  String shareScoreMsg(Object score);

  /// No description provided for @downloadHere.
  ///
  /// In en, this message translates to:
  /// **'Download here:'**
  String get downloadHere;

  /// No description provided for @youLostAt.
  ///
  /// In en, this message translates to:
  /// **'You lost at'**
  String get youLostAt;

  /// No description provided for @save.
  ///
  /// In en, this message translates to:
  /// **'Save'**
  String get save;
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
      <String>['en', 'fr'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
    case 'fr':
      return AppLocalizationsFr();
  }

  throw FlutterError(
      'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
      'an issue with the localizations generation tool. Please file an issue '
      'on GitHub with a reproducible sample app and the gen-l10n configuration '
      'that was used.');
}
