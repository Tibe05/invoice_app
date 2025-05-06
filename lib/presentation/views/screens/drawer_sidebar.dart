import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:invoice_app/core/constants/app_colors.dart';
import 'package:invoice_app/main.dart';
import 'package:invoice_app/presentation/components/app_text.dart';
import 'package:invoice_app/presentation/viewmodels/auth_viewmodel.dart';
import 'package:provider/provider.dart';

class DrawerSidebar extends StatelessWidget {
  final String? userName;
  final String? userPhone;
  const DrawerSidebar({super.key, this.userName, this.userPhone});

  @override
  Widget build(BuildContext context) {
    final AuthViewModel authViewModel = Provider.of<AuthViewModel>(context);
    return Drawer(
      width: 350.w,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.zero,
      ),
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          if (MediaQuery.of(context).size.shortestSide > 600)
            SizedBox(height: 20.h),
          DrawerHeader(
            decoration: const BoxDecoration(
              color: Colors.white,
            ),
            child: Align(
              alignment: Alignment.centerLeft,
              child: InkWell(
                onTap: () {
                  Navigator.pushNamed(context, "/profile");
                },
                child: Container(
                  padding: EdgeInsets.only(
                    left: 23.w,
                    right: 15.w,
                    top: 10.h,
                    bottom: 10.h,
                  ),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(50.r),
                    color: const Color(0xFFFBF0D9),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    mainAxisSize: MainAxisSize.min,
                    spacing: 20.w,
                    children: [
                      Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          AppText(
                            text:
                                "Sandy", //userName TODO: AJOUTER LE NOM DE L'UTILISATEUR
                            size: 18.sp,
                            color: AppColor.textColor,
                            weight: FontWeight.w700,
                            family: "Inter",
                          ),
                          AppText(
                            text:
                                "+225 04 75 639 522", // userPhone TODO: AJOUTER LE NUMERO DE L'UTILISATEUR
                            size: 14.sp,
                            color: AppColor.btnColor,
                            weight: FontWeight.w400,
                            family: "Inter",
                          ),
                        ],
                      ),
                      // Container(
                      //   padding: EdgeInsets.all(10.w),
                      //   decoration: const BoxDecoration(
                      //     shape: BoxShape.circle,
                      //     color: Colors.white,
                      //   ),
                      //   child: SizedBox(
                      //     width: 23.w,
                      //     child: SvgPicture.asset(
                      //       "assets/icons/edit-icon-3.svg",
                      //       fit: BoxFit.contain,
                      //       width: 23.w,
                      //     ),
                      //   ),
                      // ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          if (MediaQuery.of(context).size.shortestSide > 600)
            SizedBox(height: 50.h),
          Padding(
            padding: EdgeInsets.only(left: 25.w, right: 50.w),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                ListTile(
                  leading: const Icon(Icons.home),
                  title: AppText(
                    text: "Accueil",
                    size: 16.sp,
                    weight: FontWeight.w400,
                    color: AppColor.textColor,
                  ),
                  onTap: () {
                    Navigator.pushNamed(context, "/home");
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.settings),
                  title: AppText(
                    text: "Paramètres",
                    size: 16.sp,
                    weight: FontWeight.w400,
                    color: AppColor.textColor,
                  ),
                  onTap: () {
                    Navigator.pushNamed(context, "/settings");
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.logout),
                  title: AppText(
                    text: "Déconnexion",
                    size: 16.sp,
                    weight: FontWeight.w400,
                    color: AppColor.textColor,
                  ),
                  onTap: () async {
                    // TODO : LOGOUT
                    await authViewModel.signOut();
                    // final SharedPreferences prefs =
                    //     await SharedPreferences.getInstance();
                    // await prefs.clear();
                    Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const MainApp()),
                        (route) => false);

                    Fluttertoast.showToast(
                      msg:
                          "Déconnexion", // TODO : AJOUTER LE NOM DE L'UTILISATEUR
                      toastLength: Toast.LENGTH_SHORT,
                      gravity: ToastGravity.CENTER,
                      timeInSecForIosWeb: 1,
                      backgroundColor: Colors.red,
                      textColor: Colors.white,
                      fontSize: 16.sp,
                    );
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.info),
                  title: AppText(
                    text: "À propos",
                    size: 16.sp,
                    weight: FontWeight.w400,
                    color: AppColor.textColor,
                  ),
                  onTap: () {
                    Navigator.pushNamed(context, "/about");
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
