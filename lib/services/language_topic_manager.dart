import 'dart:ui';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

class LanguageTopicManager {
  static const _keySubscribedLang = 'language_topic_subscribed';

  static Future<void> initLanguageTopic() async {
    final prefs = await SharedPreferences.getInstance();
    final alreadySubscribed = prefs.getBool(_keySubscribedLang) ?? false;

    if (alreadySubscribed) return; // 🔒 Already done

    final lang = PlatformDispatcher
        .instance.locale.languageCode; // e.g. 'en', 'fr', 'es'
    await FirebaseMessaging.instance.subscribeToTopic(lang);

    await prefs.setBool(_keySubscribedLang, true); // ✅ Remember it’s done
    print('✅ Subscribed to topic: $lang');
  }
}
