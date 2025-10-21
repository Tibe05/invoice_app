import 'package:brain_memo/l10n/app_localizations.dart';
import 'package:brain_memo/presentation/viewmodels/auth_viewmodel.dart';
import 'package:brain_memo/presentation/viewmodels/home_viewmodel.dart';
import 'package:brain_memo/presentation/views/screens/braingame/welcome_screen.dart';
import 'package:brain_memo/services/posthog_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:posthog_flutter/posthog_flutter.dart';
import 'package:provider/provider.dart';
import 'firebase_options.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

Future<void> main() async {
  await dotenv.load();
  WidgetsFlutterBinding.ensureInitialized();
  // SystemChrome.setPreferredOrientations([
  //   DeviceOrientation.portraitUp,
  // ]);
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  await MobileAds.instance.initialize();
  await PosthogService().initialize();
  runApp(MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    final designSize = MediaQuery.of(context).size.width > 600
    ? const Size(834, 1194) // iPad Air size
    : const Size(375, 812); // Phone size
    return PostHogWidget(
      child: MultiProvider(
        providers: [
          ChangeNotifierProvider(
            create: (context) => AuthViewModel(),
          ),
          ChangeNotifierProvider(
            create: (context) => HomeViewModel(),
          ),
        ],
        child: PostHogWidget(
          child: ScreenUtilInit(
              designSize: designSize,
              minTextAdapt: true,
              splitScreenMode: true,
              builder: (_, child) {
                return MaterialApp(
                    debugShowCheckedModeBanner: false,
                    localizationsDelegates: const [
                      AppLocalizations.delegate,
                      GlobalMaterialLocalizations.delegate,
                      GlobalWidgetsLocalizations.delegate,
                      GlobalCupertinoLocalizations.delegate,
                    ],
                    supportedLocales: const [
                      Locale('en'), // and other locales you support
                      Locale('fr'),
                    ],
                    home:
                        WelcomeScreen() //RedirectionViewModel(fromLoginView: false,),
                    );
              }),
        ),
      ),
    );
  }
}
