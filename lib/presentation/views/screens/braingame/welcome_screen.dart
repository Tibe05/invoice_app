import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:invoice_app/presentation/components/app_text.dart';
import 'package:invoice_app/presentation/views/screens/braingame/mode_selection_screen.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

int level = 1; // Game level
String rightAnswer = ""; // Right answer to give

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF2B87D1),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
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
              text: AppLocalizations.of(context)!.title, //"Brain Memory",
              //text: "Brain Memory",
              weight: FontWeight.w600,
              size: 40.sp,
              color: Colors.white,
            ),
            SizedBox(height: 100.h),
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ModeSelectionScreen(),
                        ));
                  },
                  child: Container(
                    padding:
                        EdgeInsets.symmetric(horizontal: 36.w, vertical: 12.h),
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
                        size: 32.sp,
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
    );
  }
}
