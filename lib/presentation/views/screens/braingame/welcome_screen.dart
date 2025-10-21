import 'package:brain_memo/core/constants/app_colors.dart';
import 'package:brain_memo/l10n/app_localizations.dart';
import 'package:brain_memo/presentation/components/app_text.dart';
import 'package:brain_memo/presentation/viewmodels/auth_viewmodel.dart';
import 'package:brain_memo/presentation/viewmodels/home_viewmodel.dart';
import 'package:brain_memo/presentation/views/screens/braingame/mode_selection_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:posthog_flutter/posthog_flutter.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

int level = 1; // Game level
String rightAnswer = ""; // Right answer to give

class WelcomeScreen extends StatefulWidget {
  const WelcomeScreen({super.key});

  @override
  State<WelcomeScreen> createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {
  TextEditingController userPseudoController = TextEditingController();
  String? _error;
  bool _dialogShown = false;

  @override
  void dispose() {
    userPseudoController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _checkAndShowPseudoDialog();
    });
  }

  Future<void> _checkAndShowPseudoDialog() async {
    final authVM = Provider.of<AuthViewModel>(context, listen: false);
    final hasPseudo = await authVM.hasPseudo();

    if (!hasPseudo && !_dialogShown) {
      _dialogShown = true;
      showPseudoPopUp(authVM);
    }
  }

  showPseudoPopUp(AuthViewModel authVM) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Orientation currentOrientation = MediaQuery.of(context).orientation;
      final authVM = Provider.of<AuthViewModel>(context, listen: false);
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
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
                      Dialog(
                        backgroundColor: Colors.transparent,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(68.r)),
                        child: StatefulBuilder(builder: (context, setState) {
                          return Container(
                            width: 330.w,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(68.r),
                            ),
                            padding: EdgeInsets.symmetric(
                                vertical: 46.h, horizontal: 24.w),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                AppText(
                                  text: loc.chooseYourPseudo,
                                  alignment: TextAlign.center,
                                  weight: FontWeight.w800,
                                  size: 32.sp,
                                  color:
                                      Color(0xFF2B87D1), // Color(0xFF282727),
                                ),
                                SizedBox(height: 24.h),
                                TextField(
                                  controller: userPseudoController,
                                  cursorColor: Color(0xFF2B87D1),
                                  decoration: InputDecoration(
                                    hintText: loc.enterPseudo,
                                    errorText: _error,
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(18.r),
                                    ),
                                    focusedBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(18.r),
                                      borderSide: BorderSide(
                                        color: Color(0xFF2B87D1),
                                      ),
                                    ),
                                  ),
                                ),
                                // AppTextfield(
                                //     label: "John Doe",
                                //     hint: 'Pseudo',
                                //     controller: userPseudoController),

                                SizedBox(height: 32.h),
                                GestureDetector(
                                  onTap: () async {
                                    HapticFeedback.lightImpact();
                                    final input =
                                        userPseudoController.text.trim();
                                    final pseudo = input.replaceAll(' ', '_');

                                    if (pseudo.isEmpty) return;
                                    showDialog(
                                      context: context,
                                      barrierDismissible: false,
                                      builder: (context) => Center(
                                          child: CircularProgressIndicator(
                                        color: Color(0xFF2B87D1),
                                      )),
                                    );
                                    // CircularProgressIndicator(
                                    //   color: Color(0xFF2B87D1),
                                    // );

                                    final error =
                                        await authVM.setPseudo(pseudo);
                                    await Posthog().alias(alias: pseudo);
                                    if (!context.mounted) {
                                      return;
                                    }

                                    if (error != null) {
                                      Navigator.pop(context);
                                      setState(() {
                                        _error = error;
                                        print(_error);
                                      });
                                    } else {
                                      Navigator.pop(context);
                                      Navigator.pop(context);
                                    }
                                  },
                                  child: Container(
                                    width: 204.w,
                                    padding: EdgeInsets.symmetric(
                                      horizontal: 36.w,
                                      vertical: 24.h,
                                    ),
                                    decoration: BoxDecoration(
                                      color: Color(0xFF2B87D1),
                                      borderRadius: BorderRadius.circular(50.r),
                                    ),
                                    child: Center(
                                      child: AppText(
                                        text: loc.save.toUpperCase(),
                                        weight: FontWeight.w600,
                                        size: 14.sp,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          );
                        }),
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    Orientation currentOrientation = MediaQuery.of(context).orientation;
    final loc = AppLocalizations.of(context)!;
    //showPseudoPopUp();
    return Scaffold(
      backgroundColor: Color(0xFF2B87D1),
      body: Stack(
        children: [
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                SizedBox(height: 70.h),
                SizedBox(
                  width: 189.w,
                  height: 176.h,
                  child: SvgPicture.asset(
                    'assets/logo/logo-braingame.svg',
                    width: 189.w,
                    height: 176.h,
                    fit: BoxFit.contain,
                  ),
                ),
                SizedBox(height: 17.h),
                AppText(
                  text: "Brain Memo", //"Brain Memory",
                  //text: "Brain Memory",
                  weight: FontWeight.w800,
                  size: 40.sp,
                  color: Colors.white,
                ),
                SizedBox(height: 50.h),

                //Best scorer
                FutureBuilder(
                    future: FirebaseFirestore.instance
                        .collection('users')
                        .orderBy('bestScore', descending: true)
                        .limit(1)
                        .get(),
                    builder: (context, asyncSnapshot) {
                      if (asyncSnapshot.connectionState ==
                          ConnectionState.waiting) {
                        return SizedBox(
                          //aaheight: 200.h,
                          child: Center(
                              child: Column(
                            spacing: 16.h,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              CircularProgressIndicator(
                                color: AppColor.bgColor,
                              ),
                              AppText(
                                text: loc.loadingBestScorer,
                                size: 14.sp,
                                weight: FontWeight.w600,
                                color: Colors.white,
                              )
                            ],
                          )),
                        );
                      }
                      if (asyncSnapshot.hasError) {
                        return SizedBox.shrink();
                      }

                      final docs = asyncSnapshot.data?.docs ?? [];
                      if (docs.isEmpty) {
                        return SizedBox.shrink();
                      }
                      final user = docs[0].data();
                      HapticFeedback.mediumImpact();
                      return TweenAnimationBuilder(
                          duration: Duration(milliseconds: 350),
                          tween: Tween<double>(begin: 0.0, end: 1.0),
                          curve: Curves.easeOut,
                          builder: (context, double value, child) {
                            return Transform.scale(
                              scale: value,
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  AppText(
                                    text: loc.worldBestScore,
                                    size: 18.sp,
                                    weight: FontWeight.w800,
                                    color: Colors.white,
                                  ),
                                  SizedBox(height: 16.h),
                                  Container(
                                    padding: EdgeInsets.symmetric(
                                      horizontal: 22.w,
                                      vertical: currentOrientation ==
                                              Orientation.landscape
                                          ? 32.h
                                          : 24.h,
                                    ),
                                    margin: EdgeInsets.symmetric(
                                      horizontal: 35.w,
                                      //vertical: 24.h,
                                    ),
                                    decoration: BoxDecoration(
                                        color: Color(0xFFEFF8FF),
                                        borderRadius:
                                            BorderRadius.circular(18.r)),
                                    child: Row(
                                      spacing: 16.w,
                                      children: [
                                        Expanded(
                                          child: AppText(
                                            text: "🥇 ${user['pseudo']}",
                                            size: 16.sp,
                                            weight: FontWeight.w500,
                                            color: Color(0xFF282727),
                                            maxLine: 1,
                                          ),
                                        ),
                                        //Spacer(),
                                        AppText(
                                          text:
                                              " ${AppLocalizations.of(context)!.level}  ${user['bestScore']}",
                                          size: 16.sp,
                                          weight: FontWeight.w600,
                                          color: Color(0xFF2B87D1),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            );
                          });
                    }),
                SizedBox(height: 62.h),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    GestureDetector(
                      onTap: () {
                        HapticFeedback.lightImpact();
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => ModeSelectionScreen(),
                            ));
                      },
                      child: Container(
                        padding: EdgeInsets.symmetric(
                            horizontal: 36.w, vertical: 12.h),
                        decoration: BoxDecoration(
                          color: Color(0xFFFFD154),
                          borderRadius: BorderRadius.circular(15.r),
                        ),
                        child: Center(
                          child: AppText(
                            text: AppLocalizations.of(context)!
                                .start
                                .toUpperCase(), //"Start",
                            weight: FontWeight.w600,
                            size: 28.sp,
                            color: Color(0xFF282727),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 16.h),
                //SEE TOP 10 SCORER
                InkWell(
                  onTap: () {
                    // Navigator.push(
                    //     context,
                    //     MaterialPageRoute(
                    //       builder: (context) => LeaderboardScreen(),
                    //     ));
                    //Navigator.pushReplacementNamed(context, '/leaderboard');
                    showModalBottomSheet(
                      useSafeArea: true,
                      context: context,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.vertical(
                          top: Radius.circular(40.r),
                        ),
                      ),
                      builder: (BuildContext builder) {
                        return Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: 32.w,
                            vertical: 20.h,
                          ),
                          decoration: BoxDecoration(
                            color: Color(0xFFFAF8F5),
                            borderRadius: BorderRadius.vertical(
                              top: Radius.circular(40.r),
                            ),
                          ),
                          child: SizedBox(
                            //height: 200.h,
                            width: double.infinity,
                            child: Column(
                              //spacing: 26.h,
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                // CircularProgressIndicator(
                                //   color: AppColor.primaryColor,
                                // ),
                                AppText(
                                  text: loc.worldRanking,
                                  size: 18.sp,
                                  weight: FontWeight.w700,
                                  color: Color(0xFFFFC700),
                                ),
                                SizedBox(height: 16.h),
                                Expanded(
                                  child: FutureBuilder(
                                      future: FirebaseFirestore.instance
                                          .collection('users')
                                          .orderBy('bestScore',
                                              descending: true)
                                          .limit(5)
                                          .get(),
                                      builder: (context, asyncSnapshot) {
                                        if (asyncSnapshot.connectionState ==
                                            ConnectionState.waiting) {
                                          return SizedBox(
                                            //aaheight: 200.h,
                                            child: Center(
                                                child: Column(
                                              spacing: 16.h,
                                              mainAxisSize: MainAxisSize.min,
                                              children: [
                                                CircularProgressIndicator(
                                                  color: Color(0xFF2B87D1),
                                                ),
                                                // AppText(
                                                //   text: loc.loadingBestScorer,
                                                //   size: 14.sp,
                                                //   weight: FontWeight.w600,
                                                //   color: Colors.white,
                                                // )
                                              ],
                                            )),
                                          );
                                        }
                                        if (asyncSnapshot.hasError) {
                                          return SizedBox.shrink();
                                        }

                                        final docs =
                                            asyncSnapshot.data?.docs ?? [];
                                        if (docs.isEmpty) {
                                          return SizedBox.shrink();
                                        }
                                        return ListView.builder(
                                          itemCount: docs.length,
                                          shrinkWrap: true,
                                          itemBuilder: (context, index) {
                                            final user = docs[index].data();
                                            return Container(
                                              padding: EdgeInsets.symmetric(
                                                horizontal: 22.w,
                                                vertical: 24.h,
                                              ),
                                              margin:
                                                  EdgeInsets.only(bottom: 12.h),
                                              decoration: BoxDecoration(
                                                color: Color(0xFFEFF8FF),
                                                borderRadius:
                                                    BorderRadius.circular(18.r),
                                              ),
                                              child: Row(
                                                spacing: 16.w,
                                                children: [
                                                  Expanded(
                                                    child: AppText(
                                                      text:
                                                          "#${index + 1} ${user['pseudo']}",
                                                      size: 16.sp,
                                                      weight: FontWeight.w500,
                                                      color: Color(0xFF282727),
                                                      maxLine: 1,
                                                    ),
                                                  ),
                                                  //Spacer(),
                                                  AppText(
                                                    text:
                                                        " ${AppLocalizations.of(context)!.level}  ${user['bestScore']}",
                                                    size: 16.sp,
                                                    weight: FontWeight.w600,
                                                    color: Color(0xFF2B87D1),
                                                  ),
                                                ],
                                              ),
                                            );
                                          },
                                        );
                                      }),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    );
                  },
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    spacing: 2.w,
                    children: [
                      AppText(
                        text: loc.seeTop10WorldRanking(5),
                        size: 14.sp,
                        weight: FontWeight.w600,
                        color: Colors.white,
                      ),
                      // Icon(
                      //   Icons.keyboard_arrow_up_rounded,
                      //   color: Colors.white,
                      //   fontWeight: FontWeight.w300,
                      // )
                    ],
                  ),
                ),
              ],
            ),
          ),
          Positioned(
            top: 80.h,
            right: 30.w,
            child: GestureDetector(
              onTapDown: (TapDownDetails details) async {
                HapticFeedback.mediumImpact();
                final vm = Provider.of<HomeViewModel>(context, listen: false);
                final RenderBox overlay =
                    Overlay.of(context).context.findRenderObject() as RenderBox;

                // Show the menu at the button’s tap position
                final result = await showMenu<int>(
                  context: context,
                  position: RelativeRect.fromRect(
                    details.globalPosition &
                        const Size(40, 40), // position of tap
                    Offset.zero & overlay.size, // entire screen
                  ),
                  items: [
                    PopupMenuItem<int>(
                      value: 1,
                      child: AppText(
                        text: loc.viewHighestScore,
                        alignment: TextAlign.center,
                        size: 13.sp,
                        //color: Color(0xFF2B87D1),
                      ),
                      //Text("🏆 View Highest Score"),
                    ),
                    PopupMenuItem<int>(
                      value: 2,
                      child: AppText(
                        text: loc.shareApp,
                        alignment: TextAlign.center,
                        size: 13.sp,
                        //color: Color(0xFF2B87D1),
                      ),
                      //Text("📤 Share the App"),
                    ),
                  ],
                );

                if (result == 1) {
                  final prefs = await SharedPreferences.getInstance();
                  final userBestScore = prefs.getInt('bestScore') ?? 0;
                  final String userPseudo =
                      prefs.getString('user_pseudo') ?? "";
                  if (!context.mounted) return;
                  showDialog(
                    context: context,
                    barrierDismissible: true,
                    builder: (BuildContext context) {
                      HapticFeedback.mediumImpact();
                      final loc = AppLocalizations.of(context)!;
                      return TweenAnimationBuilder(
                        duration: Duration(milliseconds: 350),
                        tween: Tween<double>(begin: 0.0, end: 1.0),
                        curve: Curves.easeOut,
                        builder: (context, double value, child) {
                          return Transform.scale(
                            scale: value,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Container(
                                  //width: 330.w,
                                  //width: 800.w,
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(54.r),
                                  ),
                                  padding: EdgeInsets.symmetric(
                                      vertical: 46.h, horizontal: 50.w),
                                  margin: EdgeInsets.symmetric(
                                    horizontal: 34.w,
                                  ),
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      SizedBox(
                                        height: 75.w,
                                        width: 75.w,
                                        child: SvgPicture.asset(
                                          "assets/icons/trophy-star.svg",
                                        ),
                                      ),
                                      SizedBox(height: 8.h),
                                      AppText(
                                        text: userBestScore > 0
                                            ? loc.yourHighestScore
                                            : loc.noScore,
                                        alignment: TextAlign.center,
                                        weight: FontWeight.w800,
                                        size: 32.sp,
                                        color: Color(0xFFFFC700),
                                      ),
                                      if (userBestScore > 0) ...[
                                        SizedBox(height: 14.h),
                                        Container(
                                          padding: EdgeInsets.symmetric(
                                            vertical: 10.h,
                                            horizontal: 24.w,
                                          ),
                                          decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(50.r),
                                            color: Color(0xFFFFC700),
                                          ),
                                          child: AppText(
                                            text: "${loc.level} $userBestScore",
                                            alignment: TextAlign.center,
                                            weight: FontWeight.w800,
                                            size: 24.sp,
                                            color: Colors.white,
                                          ),
                                        ),
                                        SizedBox(height: 14.h),
                                      ],
                                      if (userPseudo.isNotEmpty)
                                        AppText(
                                          text: "Pseudo: $userPseudo",
                                          alignment: TextAlign.center,
                                          weight: FontWeight.w700,
                                          size: 18.sp,
                                          color: Color(0xFF2B87D1),
                                        ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          );
                        },
                      );
                    },
                  );
                } else if (result == 2) {
                  if (!context.mounted) return;
                  showDialog(
                    context: context,
                    barrierDismissible: false,
                    builder: (context) => Center(
                        child: CircularProgressIndicator(
                      color: Colors.white,
                    )),
                  );
                  await vm.shareApp(context);
                  if (!context.mounted) return;
                  Navigator.pop(context);
                }
              },
              child: SizedBox(
                height: (MediaQuery.of(context).size.width > 600 &&
                        currentOrientation == Orientation.portrait)
                    ? 32.w
                    : 20.w,
                width: (MediaQuery.of(context).size.width > 600 &&
                        currentOrientation == Orientation.portrait)
                    ? 32.w
                    : 20.w,
                child: SvgPicture.asset(
                  "assets/icons/circle-ellipsis-vertical.svg",
                  // height: 20.w,
                  // width: 20.w,
                  fit: BoxFit.contain,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
