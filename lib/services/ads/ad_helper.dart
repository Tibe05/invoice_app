import 'dart:io';

class AdHelper {
  static String get bannerAdUnitId {
    if (Platform.isAndroid) {
      return 'ca-app-pub-9874317708507814/1912031863';
    } else if (Platform.isIOS) {
      return 'ca-app-pub-9874317708507814/3483106165';
    } else {
      throw UnsupportedError("Unsupported plateform");
    }
  }
  static String get interstitialAdUnitId {
    if (Platform.isAndroid) {
      return 'ca-app-pub-9874317708507814/6585774049';
    } else if (Platform.isIOS) {
      return 'ca-app-pub-9874317708507814/3033541847';
    } else {
      throw UnsupportedError("Unsupported plateform");
    }
  }
}
