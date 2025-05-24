import 'dart:io';

class AdHelper {
  static String? get bannerAdUnitId {
    if (Platform.isAndroid) {
      return 'ca-app-pub-3096583905494889/3902740466';
    } else if (Platform.isIOS) {
      return 'ca-app-pub-3096583905494889/3902740466 ';
    }

    return null;
  }
}