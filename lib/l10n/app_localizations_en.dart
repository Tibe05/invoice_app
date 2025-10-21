// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get title => 'Brain Memory';

  @override
  String get start => 'Start';

  @override
  String get chooseMode => 'Choose mode';

  @override
  String get letters => 'Letters';

  @override
  String get numbers => 'Numbers';

  @override
  String get level => 'Level';

  @override
  String get gameOver => 'Game Over';

  @override
  String get yourAnswer => 'Your answer';

  @override
  String get correctAnswer => 'Correct answer';

  @override
  String get playAgain => 'Play again';

  @override
  String get go => 'Go';

  @override
  String get whatWasLetter => 'What was the letter ?';

  @override
  String get whatWasLetters => 'What were the letters ?';

  @override
  String get whatWasNumber => 'What was the number ?';

  @override
  String get whatWasNumbers => 'What were the numbers ?';

  @override
  String get send => 'Send';

  @override
  String get myScore => 'My Score';

  @override
  String get shareScrore => 'Share score';

  @override
  String get share => 'Share';

  @override
  String get chooseYourPseudo => 'Choose your pseudo';

  @override
  String get enterPseudo => 'Enter pseudo';

  @override
  String get loadingBestScorer => 'Loading the best scorer';

  @override
  String get worldBestScore => '⭐️ World Best Score';

  @override
  String get worldRanking => '⭐️ World Ranking';

  @override
  String get viewHighestScore => 'My Highest Score';

  @override
  String get shareApp => 'Share the App';

  @override
  String get yourHighestScore => 'Your Highest Score';

  @override
  String get noScore => 'No score';

  @override
  String seeTop10WorldRanking(Object quantity) {
    return 'See Top $quantity World ranking';
  }

  @override
  String shareScoreMsg(Object score) {
    return 'I just scored $score in Brain Memo 123 🧠🔥! Think you can beat me?';
  }

  @override
  String get downloadHere => 'Download here:';

  @override
  String get youLostAt => 'You lost at';

  @override
  String get save => 'Save';
}
