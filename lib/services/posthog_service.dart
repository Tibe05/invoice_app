import 'package:flutter/material.dart';
import 'package:posthog_flutter/posthog_flutter.dart';


class PosthogService {

  PosthogService();

  Future<void> initialize() async {
    // init WidgetsFlutterBinding if not yet
  WidgetsFlutterBinding.ensureInitialized();
  final config = PostHogConfig('phc_XgHVgIgOSNC6YNh8yatNe6N8FHMPRuMWz9mldXqA7d3');
  config.host = 'https://us.i.posthog.com';
  config.debug = true;
  config.captureApplicationLifecycleEvents = true;
  // check https://posthog.com/docs/session-replay/installation?tab=Flutter
  // for more config and to learn about how we capture sessions on mobile
  // and what to expect
  config.sessionReplay = true;
  // choose whether to mask images or text
  config.sessionReplayConfig.maskAllTexts = false;
  config.sessionReplayConfig.maskAllImages = false;
  // Setup PostHog with the given Context and Config
  await Posthog().setup(config);
  }
}
