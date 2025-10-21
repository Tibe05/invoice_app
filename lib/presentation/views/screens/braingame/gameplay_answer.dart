import 'dart:developer';
import 'dart:io';

import 'package:brain_memo/l10n/app_localizations.dart';
import 'package:brain_memo/presentation/components/app_text.dart';
import 'package:brain_memo/presentation/viewmodels/share_viewmodel.dart';
import 'package:brain_memo/presentation/views/screens/braingame/gameplay_with_timer.dart';
import 'package:brain_memo/presentation/views/screens/braingame/mode_selection_screen.dart';
import 'package:brain_memo/presentation/views/screens/braingame/welcome_screen.dart';
import 'package:brain_memo/services/ads/ad_helper.dart';
import 'package:brain_memo/services/app_review_service.dart';
import 'package:brain_memo/services/firestore_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:posthog_flutter/posthog_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';

//const int level = 1; // Example level, can be dynamic

class GameplayAnswer extends StatefulWidget {
  final String mode;
  const GameplayAnswer({
    super.key,
    this.mode = "Number",
  });

  @override
  State<GameplayAnswer> createState() => _GameplayAnswerState();
}

class _GameplayAnswerState extends State<GameplayAnswer> {
  //textfield controller for the user input
  final TextEditingController _controller = TextEditingController();

  String? userPseudo;
  String? userId;

  BannerAd? _bannerAd;
  bool _isBannerAdReady = false;

  InterstitialAd? _interstitialAd;

  @override
  void initState() {
    getUserData();
    _loadBannerAd();
    loadInterstitialAd();
    super.initState();
  }

  Future<String?> getUserData() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      userPseudo = prefs.getString('user_pseudo');
      userId = prefs.getString('user_id');
    });
    return null;
  }

  //Function to process the answer
  void processAnswer() {
    Orientation currentOrientation = MediaQuery.of(context).orientation;
    final bool isTabletLandscape = MediaQuery.of(context).size.width > 600 &&
        currentOrientation == Orientation.landscape;
    if (_controller.text.isNotEmpty) {
      HapticFeedback.lightImpact();
      // Show a message or handle empty input
      if (_controller.text.toLowerCase() == rightAnswer.toLowerCase()) {
        // Handle number input
        print("User entered the right answer: ${_controller.text}");
        // Increment level or show success message
        level++;
        log("Level: $level");
        // Navigate to the next screen or show success message
        FocusScope.of(context).unfocus();
        Future.delayed(Duration(milliseconds: 250), () {
          if (mounted) {
            // Reset the controller for the next input
            _controller.clear();
            Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) => GameplayWithTimer(
                    mode: widget.mode,
                    level: level,
                  ),
                ));
          }
        });
      } else {
        //Save best score
        FirestoreService().updateBestScore(userId: userId!, score: level);

        //App Review
        ReviewService().onGameCompleted(level);

        // Handle letter input
        showDialog(
          context: context,
          barrierDismissible: false,
          builder: (BuildContext context) {
            final shareVM = ShareViewModel();
            final loc = AppLocalizations.of(context)!;
            return TweenAnimationBuilder(
              duration: Duration(milliseconds: 350),
              tween: Tween<double>(begin: 0.0, end: 1.0),
              curve: Curves.easeOut,
              builder: (context, double value, child) {
                return Transform.scale(
                  scale: value,
                  child: PopScope(
                    canPop: false,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          //width: 330.w,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(
                                isTabletLandscape ? 100.r : 68.r),
                          ),
                          padding: EdgeInsets.symmetric(
                            vertical: isTabletLandscape ? 100.h : 46.h,
                            horizontal: isTabletLandscape ? 100.w : 50.w,
                          ),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              AppText(
                                text: loc.gameOver.toUpperCase(),
                                alignment: TextAlign.center,
                                weight: FontWeight.w800,
                                size: 36.sp,
                                color: Color(0xFF282727),
                              ),
                              SizedBox(height: 10.h),
                              AppText(
                                text: loc.youLostAt,
                                alignment: TextAlign.center,
                                weight: FontWeight.w700,
                                size: 24.sp,
                                color: Color(0xFF282727),
                              ),
                              SizedBox(height: 2.h),
                              AppText(
                                text: "${loc.level} $level",
                                alignment: TextAlign.center,
                                weight: FontWeight.w700,
                                size: 32.sp,
                                color: Color(0xFFFF5257),
                              ),
                              SizedBox(height: 14.h),
                              AppText(
                                text: "${loc.yourAnswer} :",
                                alignment: TextAlign.center,
                                weight: FontWeight.w800,
                                size: 20.sp,
                                color: Color(0xFFaeadad),
                              ),
                              AppText(
                                text: _controller.text.toUpperCase(),
                                alignment: TextAlign.center,
                                weight: FontWeight.w800,
                                size: 32.sp,
                                maxLine: 5,
                                color: Color(0xFFaeadad),
                              ),
                              SizedBox(height: 14.h),
                              AppText(
                                text: "${loc.correctAnswer} :",
                                alignment: TextAlign.center,
                                weight: FontWeight.w800,
                                size: 20.sp,
                                color: Color(0xFF2B87D1),
                              ),
                              AppText(
                                text: rightAnswer.toUpperCase(),
                                alignment: TextAlign.center,
                                weight: FontWeight.w800,
                                size: 32.sp,
                                maxLine: 5,
                                color: Color(0xFF2B87D1),
                              ),
                              SizedBox(height: 32.h),
                              Column(
                                spacing: 10.h,
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  GestureDetector(
                                    onTap: () {
                                      HapticFeedback.lightImpact();
                                      level = 1;
                                      Navigator.pushAndRemoveUntil(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                ModeSelectionScreen()),
                                        (route) => false,
                                      );
                                      showInterstitialAd();
                                      // Future.delayed(
                                      //     const Duration(milliseconds: 300),
                                      //     () {
                                      // });
                                      //showInterstitialAd();
                                    },
                                    child: Container(
                                      width: 204.w,
                                      padding: EdgeInsets.symmetric(
                                        horizontal: 36.w,
                                        vertical: 24.h,
                                      ),
                                      decoration: BoxDecoration(
                                        color: Color(0xFF2B87D1),
                                        borderRadius:
                                            BorderRadius.circular(50.r),
                                      ),
                                      child: Center(
                                        child: AppText(
                                          text: loc.playAgain.toUpperCase(),
                                          weight: FontWeight.w600,
                                          size: 14.sp,
                                          color: Colors.white,
                                          alignment: TextAlign.center,
                                        ),
                                      ),
                                    ),
                                  ),
                                  GestureDetector(
                                    onTap: () async {
                                      HapticFeedback.lightImpact();
                                      Posthog().capture(
                                        eventName: "shareScore",
                                      );
                                      showDialog(
                                        context: context,
                                        barrierDismissible: false,
                                        builder: (context) => Center(
                                            child: CircularProgressIndicator(
                                          color: Color(0xFF2B87D1),
                                        )),
                                      );
                                      await shareVM.shareScore(
                                          message: ShareScoreHelper(
                                                  context, loc, level - 1)
                                              .shareScoreMsg,
                                          score: level - 1,
                                          loc: loc,
                                          userAnswer: _controller.text,
                                          correctAnswer: rightAnswer);
                                      setState(() {
                                        Navigator.pop(context);
                                      });
                                    },
                                    child: Container(
                                      width: 204.w,
                                      padding: EdgeInsets.symmetric(
                                        horizontal: 36.w,
                                        vertical: 24.h,
                                      ),
                                      decoration: BoxDecoration(
                                        color: Colors.white,
                                        border: Border.all(
                                            color: Color(0xFF2B87D1),
                                            width: 1.5.w),
                                        borderRadius:
                                            BorderRadius.circular(50.r),
                                      ),
                                      child: Center(
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          spacing: 10.w,
                                          children: [
                                            SizedBox(
                                              height: 18.w,
                                              width: 18.w,
                                              child: SvgPicture.asset(
                                                "assets/icons/share-icon.svg",
                                                fit: BoxFit.contain,
                                              ),
                                            ),
                                            AppText(
                                              text: loc.share.toUpperCase(),
                                              weight: FontWeight.w600,
                                              size: 14.sp,
                                              color: Color(0xFF2B87D1),
                                              alignment: TextAlign.center,
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            );
          },
        );
        print("User entered the wrong answer: ${_controller.text}");
      }
    } else {
      HapticFeedback.vibrate();
    }
  }

  void _loadBannerAd() {
    _bannerAd = BannerAd(
      adUnitId: AdHelper.bannerAdUnitId,
      request: const AdRequest(),
      size: AdSize.banner,
      listener: BannerAdListener(
        onAdLoaded: (_) {
          setState(() => _isBannerAdReady = true);
        },
        onAdFailedToLoad: (ad, err) {
          print('Banner failed to load: $err');
          ad.dispose();
        },
      ),
    )..load();
  }

  void loadInterstitialAd() {
    InterstitialAd.load(
      adUnitId: AdHelper.interstitialAdUnitId, // test ID
      request: const AdRequest(),
      adLoadCallback: InterstitialAdLoadCallback(
        onAdLoaded: (ad) {
          ad.fullScreenContentCallback = FullScreenContentCallback(
            onAdDismissedFullScreenContent: (ad) {
              ad.dispose();
              _interstitialAd = null;

              print("Interstitial ad dismissed");
            },
            onAdWillDismissFullScreenContent: (ad) {
              ad.dispose();
            },
            onAdFailedToShowFullScreenContent: (ad, error) {
              ad.dispose();
              _interstitialAd = null;
              print("Failed to show interstitial ad: $error");
            },
          );
          setState(() {
            _interstitialAd = ad;
          });
        },
        onAdFailedToLoad: (err) {
          print('Failed to load interstitial ad: $err');
          _interstitialAd = null;
        },
      ),
    );
  }

  void showInterstitialAd() {
    if (_interstitialAd != null) {
      _interstitialAd?.show();
      //
      //_interstitialAd = null;
    } else {
      print('Ad not ready yet');
    }
  }

  @override
  void dispose() {
    _bannerAd?.dispose();
    //_interstitialAd?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    log("Correct answer: $rightAnswer");
    final loc = AppLocalizations.of(context)!;
    final shareVM = ShareViewModel();
    final locale = Localizations.localeOf(context).languageCode;
    final numberQuestion = level > 1 ? loc.whatWasNumbers : loc.whatWasNumber;
    final letterQuestion = level > 1 ? loc.whatWasLetters : loc.whatWasLetter;

    return Scaffold(
      backgroundColor: Color(0xFF2B87D1),
      //resizeToAvoidBottomInset: false,
      body: Center(
        child: Stack(
          children: [
            Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  AppText(
                    text: widget.mode == "number"
                        ? numberQuestion
                        : letterQuestion,
                    weight: FontWeight.w800,
                    size: 40.sp,
                    maxLine: 3,
                    color: Colors.white,
                    alignment: TextAlign.center,
                  ),
                  // TextField for user input
                  Container(
                    width: 280.w,
                    padding:
                        EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
                    child: Center(
                      child: IntrinsicWidth(
                        child: TextField(
                          textCapitalization: TextCapitalization.characters,
                          controller: _controller,
                          autofocus: true,
                          keyboardType: widget.mode == "number"
                              ? TextInputType.number
                              : TextInputType.text,
                          inputFormatters: widget.mode == "number"
                              ? [FilteringTextInputFormatter.digitsOnly]
                              : [
                                  FilteringTextInputFormatter.allow(
                                      RegExp('[a-zA-Z]'))
                                ],
                          style: TextStyle(
                            fontSize: _controller.text.length > 5
                                ? 54.sp
                                : _controller.text.length > 8
                                    ? 44
                                    : _controller.text.length > 15
                                        ? 28.sp
                                        : 64.sp,
                            color: Colors.white,
                            fontWeight: FontWeight.w800,
                            decoration: TextDecoration.none,
                          ),
                          onSubmitted: (value) {
                            if (value.isNotEmpty) {
                              log("User submitted: $value");
                              processAnswer();
                            }
                          },
                          onChanged: (value) {
                            if (widget.mode != "number") {
                              _controller.value = _controller.value.copyWith(
                                text: value.toUpperCase(),
                                selection: TextSelection.collapsed(
                                    offset: value.length),
                              );
                            }
                            setState(
                                () {}); // Trigger rebuild to update font size
                          },
                          textAlign: TextAlign.center,
                          decoration: InputDecoration(
                            hintText: widget.mode == "number" ? "0" : "A",
                            hintStyle: TextStyle(
                              fontSize: 64.sp,
                              color: Colors.white.withAlpha(128),
                              fontWeight: FontWeight.w800,
                            ),
                            border: UnderlineInputBorder(
                              borderSide: BorderSide(color: Colors.white),
                            ),
                            enabledBorder: UnderlineInputBorder(
                              borderSide: BorderSide(color: Colors.white),
                            ),
                            focusedBorder: UnderlineInputBorder(
                              borderSide:
                                  BorderSide(color: Colors.white, width: 2),
                            ),
                            constraints: BoxConstraints(
                              minWidth: 50.w,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 51.h),
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      GestureDetector(
                        onTap: () {
                          processAnswer();
                        },
                        child: Container(
                          width: 265.w,
                          padding: EdgeInsets.symmetric(
                              horizontal: 36.w, vertical: 12.h),
                          decoration: BoxDecoration(
                            color: Color(0xFFFFD154),
                            borderRadius: BorderRadius.circular(50.r),
                          ),
                          child: Center(
                            child: AppText(
                              text: loc.send.toUpperCase(),
                              weight: FontWeight.w600,
                              size: 28.sp,
                              color: Color(0xFF282727),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: IgnorePointer(
                ignoring: false,
                child: Padding(
                  padding: EdgeInsets.only(top: 60.h),
                  child: _isBannerAdReady
                      ? SizedBox(
                          width: _bannerAd!.size.width.toDouble(),
                          height: _bannerAd!.size.height.toDouble(),
                          child: AdWidget(ad: _bannerAd!),
                        )
                      : SizedBox.shrink(),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class ShareScoreHelper {
  final BuildContext contextM;
  final AppLocalizations loc;
  final int score;

  ShareScoreHelper(
    this.contextM,
    this.loc,
    this.score,
  );
  String get shareScoreMsg {
    if (Platform.isIOS) {
      return "${loc.shareScoreMsg(score)}\n${loc.downloadHere}: https://apps.apple.com/us/app/brain-memo-123/id6753922058";
    } else {
      return "${loc.shareScoreMsg(score)}\n${loc.downloadHere}: https://play.google.com/store/apps/details?id=com.tibe.brainmemo&hl=en";
    }
  }
}
