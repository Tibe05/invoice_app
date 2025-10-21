import 'dart:io';
import 'package:share_plus/share_plus.dart';
import 'package:flutter/material.dart';

class ShareService {
  static Future<void> shareApp(BuildContext context) async {
    // Detect device language
    final locale = Localizations.localeOf(context).languageCode;

    String message;

    if (locale == 'fr') {
      if(Platform.isIOS){
        message =
          "🧠 Teste ta mémoire avec Brain Memo ! Découvre si tu peux battre mon record 💪 Télécharge maintenant sur l'App Store : https://apps.apple.com/us/app/brain-memo-123/id6753922058";
      }else{
        message =
          "🧠 Teste ta mémoire avec Brain Memo ! Découvre si tu peux battre mon record 💪 Télécharge maintenant sur PayStore : https://play.google.com/store/apps/details?id=com.tibe.brainmemo&hl=en";
      }
      
    } else {
      if(Platform.isIOS){
        message =
          "🧠 Test your memory with Brain Memo! See if you can beat my score 💪 Download now on the App Store: https://apps.apple.com/us/app/brain-memo-123/id6753922058";
      }else{
        message =
          "🧠 Test your memory with Brain Memo! See if you can beat my score 💪 Download now on PlayStore: https://play.google.com/store/apps/details?id=com.tibe.brainmemo&hl=en";
      }
      
    }
    await SharePlus.instance
        .share(ShareParams(text: message, subject: "Brain Memo"));
  }
}
