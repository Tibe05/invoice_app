import 'package:brain_memo/l10n/app_localizations.dart';
import 'package:brain_memo/presentation/components/app_text.dart';
import 'package:brain_memo/presentation/viewmodels/share_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';

class ShareScreen extends StatelessWidget {
  final AppLocalizations loc;
  final int score;
  final String userAnswer;
  final String correctAnswer;
  const ShareScreen(
      {super.key,
      required this.loc,
      required this.score,
      required this.userAnswer,
      required this.correctAnswer});

  @override
  Widget build(BuildContext context) {
    final shareVM = ShareViewModel();
    //final loc = Applocalizations.of(context)!;
    return Stack(
      children: [
        Container(
          width: double.infinity,
          height: double.infinity,
          color: Color(0xFF2B87D1),
          child: Column(
            mainAxisSize: MainAxisSize.max,
            //mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(height: 135.h),
              Column(
                mainAxisSize: MainAxisSize.min,
                spacing: 8.h,
                children: [
                  SizedBox(
                      height: 50.h,
                      width: 50.h,
                      child:
                          SvgPicture.asset("assets/logo/logo-white-blue.svg")),
                  AppText(
                    text: "Brain Memo", //"rightAnswer.toUpperCase()",
                    alignment: TextAlign.center,
                    weight: FontWeight.w800,
                    size: 16.sp,
                    maxLine: 5,
                    color: Colors.white,
                  ),
                ],
              ),
              SizedBox(height: 16.h),
              Container(
                //width: 330.w,
                width: 800.w,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(54.r),
                ),
                padding: EdgeInsets.symmetric(vertical: 46.h, horizontal: 50.w),
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
                        fit: BoxFit.contain,
                      ),
                    ),
                    AppText(
                      text: loc.myScore,
                      alignment: TextAlign.center,
                      weight: FontWeight.w800,
                      size: 32.sp,
                      color: Color(0xFFFFC700),
                    ),
                    SizedBox(height: 14.h),
                    Container(
                      padding: EdgeInsets.symmetric(
                        vertical: 10.h,
                        horizontal: 24.w,
                      ),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(50.r),
                        color: Color(0xFFFFC700),
                      ),
                      child: AppText(
                        text: "${loc.level} $score",
                        alignment: TextAlign.center,
                        weight: FontWeight.w800,
                        size: 24.sp,
                        color: Colors.white,
                      ),
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
                      text: userAnswer
                          .toUpperCase(), //"_controller.text.toUpperCase()",
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
                      text: correctAnswer
                          .toUpperCase(), //"rightAnswer.toUpperCase()",
                      alignment: TextAlign.center,
                      weight: FontWeight.w800,
                      size: 32.sp,
                      maxLine: 5,
                      color: Color(0xFF2B87D1),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        // Align(
        //   alignment: Alignment.bottomCenter,
        //   child: Padding(
        //     padding: EdgeInsets.only(bottom: 42.h),
        //     child: Column(
        //       mainAxisSize: MainAxisSize.min,
        //       spacing: 12.h,
        //       children: [
        //         SizedBox(
        //             height: 50.h,
        //             width: 50.h,
        //             child: SvgPicture.asset("assets/logo/logo-white-blue.svg")),
        //         // AppText(
        //         //   text: "Brain Memo 123", //"rightAnswer.toUpperCase()",
        //         //   alignment: TextAlign.center,
        //         //   weight: FontWeight.w800,
        //         //   size: 14.sp,
        //         //   maxLine: 5,
        //         //   color: Colors.white,
        //         // ),
        //       ],
        //     ),
        //   ),
        // ),

        // Align(
        //   alignment: Alignment.topCenter,
        //   child: Padding(
        //     padding: EdgeInsets.only(top: 50.h),
        //     child: Column(
        //       mainAxisSize: MainAxisSize.min,
        //       spacing: 12.h,
        //       children: [
        //         SizedBox(
        //             height: 50.h,
        //             width: 50.h,
        //             child: SvgPicture.asset("assets/logo/logo-white-blue.svg")),
        //         AppText(
        //           text: "Brain Memo 123", //"rightAnswer.toUpperCase()",
        //           alignment: TextAlign.center,
        //           weight: FontWeight.w800,
        //           size: 24.sp,
        //           maxLine: 5,
        //           color: Colors.white,
        //         ),
        //       ],
        //     ),
        //   ),
        // )
      ],
    );
  }
}
