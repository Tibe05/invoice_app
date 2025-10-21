class UserModel {
  final String id;
  final String pseudo;
  final int bestScore;

  UserModel({
    required this.id,
    required this.pseudo,
    required this.bestScore,
  });

  Map<String, dynamic> toMap() {
    return {
      'pseudo': pseudo,
      'bestScore': bestScore,
    };
  }

  factory UserModel.fromMap(String id, Map<String, dynamic> map) {
    return UserModel(
      id: id,
      pseudo: map['pseudo'] ?? '',
      bestScore: map['bestScore'] ?? 0,
    );
  }
}
