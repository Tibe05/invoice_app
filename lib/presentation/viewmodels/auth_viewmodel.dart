import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthViewModel extends ChangeNotifier {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  /// Saves pseudo to Firestore if available and returns null if success, or an error message if taken
  Future<String?> setPseudo(String pseudo) async {
    try {
      // Check if pseudo is already taken
      final query = await _firestore
          .collection('users')
          .where('pseudo', isEqualTo: pseudo)
          .limit(1)
          .get();

      if (query.docs.isNotEmpty) {
        return 'Pseudo already taken';
      }

      // Get current user id from auth (replace with your auth logic)
      final userId =
          "mockUserId"; // ← Replace with FirebaseAuth.instance.currentUser!.uid

      DocumentReference docRef = await _firestore.collection('users').add(
        {
          'pseudo': pseudo,
          'createdAt': FieldValue.serverTimestamp(),
        },
      );
      String docId = docRef.id;
      // Save locally
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('user_pseudo', pseudo);
      await prefs.setString('user_id', docId);
      await prefs.setBool('pseudo_set', true);

      return null; // Success
    } catch (e) {
      return 'Error setting pseudo';
    }
  }

  /// Check if pseudo is already set locally
  Future<bool> hasPseudo() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool('pseudo_set') ?? false;
  }

  Future<String?> getPseudo() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('user_pseudo');
  }
}
