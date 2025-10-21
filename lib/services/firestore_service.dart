import 'package:brain_memo/presentation/user_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shared_preferences/shared_preferences.dart';

class FirestoreService {
  final _db = FirebaseFirestore.instance;

  // Future<bool> isPseudoTaken(String pseudo) async {
  //   final result =
  //       await _db.collection('users').where('pseudo', isEqualTo: pseudo).get();
  //   return result.docs.isNotEmpty;
  // }

  // Future<void> createUser(UserModel user) async {
  //   await _db.collection('users').doc(user.id).set(user.toMap());
  // }

  Future<void> updateBestScore(
      {required String userId, required int score}) async {
    final prefs = await SharedPreferences.getInstance();
    final userBestScore = prefs.getInt('bestScore') ?? 0;
    final userRef = _db.collection('users').doc(userId);

    if (score - 1 > userBestScore) {
      try {
        await prefs.setInt('bestScore', score - 1);
        // final doc = await userRef.get();
        // if (!doc.exists) return;

        // final currentScore = doc.data()!['bestScore'] ?? 0;
        // if (score > currentScore) {
        // }
        await userRef.update({
          'bestScore': score - 1,
          'scoreUpdatedAt': FieldValue.serverTimestamp(),
        });
        print("New high score set: ${score - 1}");
      } catch (e) {
        print("Error happened while updating score");
      }
    }
  }

  Stream<List<UserModel>> getTop10Scores() {
    return _db
        .collection('users')
        .orderBy('bestScore', descending: true)
        .limit(10)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => UserModel.fromMap(doc.id, doc.data()))
            .toList());
  }
  Stream<List<UserModel>> getTopScorer() {
    return _db
        .collection('users')
        .orderBy('bestScore', descending: true)
        .limit(10)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => UserModel.fromMap(doc.id, doc.data()))
            .toList());
  }
}
