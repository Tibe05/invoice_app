// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for French (`fr`).
class AppLocalizationsFr extends AppLocalizations {
  AppLocalizationsFr([String locale = 'fr']) : super(locale);

  @override
  String get title => 'Jeu de mémoire';

  @override
  String get start => 'Commencer';

  @override
  String get chooseMode => 'Choisir le mode';

  @override
  String get letters => 'Lettres';

  @override
  String get numbers => 'Nombres';

  @override
  String get level => 'Niveau';

  @override
  String get gameOver => 'Jeu terminé';

  @override
  String get yourAnswer => 'Ta réponse';

  @override
  String get correctAnswer => 'La bonne réponse';

  @override
  String get playAgain => 'Rejouer';

  @override
  String get go => 'C\'est parti';

  @override
  String get whatWasLetter => 'Quelle était la lettre ?';

  @override
  String get whatWasLetters => 'Quelles étaient les lettres ?';

  @override
  String get whatWasNumber => 'Quel était le chiffre ?';

  @override
  String get whatWasNumbers => 'Quels étaient le nombre ?';

  @override
  String get send => 'Valider';

  @override
  String get myScore => 'Mon score';

  @override
  String get shareScrore => 'Partager le score';

  @override
  String get share => 'Partager';

  @override
  String get chooseYourPseudo => 'Choisis ton pseudo';

  @override
  String get enterPseudo => 'Entre ton pseudo';

  @override
  String get loadingBestScorer => 'Chargement du meilleur score';

  @override
  String get worldBestScore => '⭐️ Meilleur score mondial';

  @override
  String get worldRanking => '⭐️ Classement mondial';

  @override
  String get viewHighestScore => 'Mon meilleur score';

  @override
  String get shareApp => 'Partager l’application';

  @override
  String get yourHighestScore => 'Ton meilleur score';

  @override
  String get noScore => 'Aucun score';

  @override
  String seeTop10WorldRanking(Object quantity) {
    return 'Voir le Top $quantity mondial';
  }

  @override
  String shareScoreMsg(Object score) {
    return 'Je viens d\'atteindre le niveau $score dans Brain Memo 123 🧠🔥 ! Penses-tu pouvoir me battre ?';
  }

  @override
  String get downloadHere => 'Télécharge ici:';

  @override
  String get youLostAt => 'Tu as perdu au';

  @override
  String get save => 'Enregistrer';
}
