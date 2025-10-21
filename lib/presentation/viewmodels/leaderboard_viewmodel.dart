import 'package:brain_memo/presentation/user_model.dart';
import 'package:brain_memo/services/firestore_service.dart';
import 'package:flutter/foundation.dart';

class LeaderboardViewModel extends ChangeNotifier {
  final _firestoreService = FirestoreService();

  Stream<List<UserModel>> get topUsers => _firestoreService.getTop10Scores();
}
