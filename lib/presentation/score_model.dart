class ScoreModel {
  final String userId;
  final String pseudo;
  final int bestScore;

  ScoreModel({
    required this.userId,
    required this.pseudo,
    required this.bestScore,
  });

  factory ScoreModel.fromMap(Map<String, dynamic> map) {
    return ScoreModel(
      userId: map['userId'] ?? '',
      pseudo: map['pseudo'] ?? '',
      bestScore: map['bestScore'] ?? 0,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'userId': userId,
      'pseudo': pseudo,
      'bestScore': bestScore,
    };
  }
}
