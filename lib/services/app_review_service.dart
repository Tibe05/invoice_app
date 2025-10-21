import 'dart:developer';

import 'package:in_app_review/in_app_review.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ReviewService {
  static const _keyReviewShown = 'hasRequestedReview';
  final InAppReview _review = InAppReview.instance;

  Future<void> maybeRequestReview() async {
    final prefs = await SharedPreferences.getInstance();
    final hasShown = prefs.getBool(_keyReviewShown) ?? false;

    if (!hasShown && await _review.isAvailable()) {
      try {
        await _review.requestReview();
        await prefs.setBool(_keyReviewShown, true);
      } catch (e) {
        log("Failed to execute function maybeRequestReview()");
      }
    }
  }

  final InAppReview inAppReview = InAppReview.instance;

  Future<void> requestAppReview() async {
    try {
      if (await inAppReview.isAvailable()) {
        await inAppReview.requestReview();
      } else {
        // fallback: open app store page manually
        await inAppReview.openStoreListing(
          appStoreId: '6753922058', // e.g. '1234567890'
        );
      }
    } catch (e) {
      log("Failed to execute function requestAppReview()");
    }
  }

  void onGameCompleted(int score) {
    if (score >= 8) {
      ReviewService().maybeRequestReview();
    }
  }
}
