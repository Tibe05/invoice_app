import 'dart:developer';

import 'package:brain_memo/presentation/score_model.dart';
import 'package:brain_memo/services/share_service.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomeViewModel extends ChangeNotifier {
  ScoreModel? highestScore;

  Future<void> fetchHighestScore() async {
    final prefs = await SharedPreferences.getInstance();
    final userId = prefs.getString('userId');
    final pseudo = prefs.getString('pseudo');

    if (userId == null || pseudo == null) return;

    final doc = await FirebaseFirestore.instance
        .collection('leaderboard')
        .doc(userId)
        .get();

    if (doc.exists) {
      highestScore = ScoreModel.fromMap(doc.data()!);
      notifyListeners();
    }
  }

  Future<void> shareApp(BuildContext context) async {
    try {
      await ShareService.shareApp(context);
    } catch (e) {
      log("Failed to share the link");
    }
  }
}
