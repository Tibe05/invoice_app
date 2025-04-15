import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:invoice_app/presentation/components/app_button.dart';
import 'package:invoice_app/presentation/components/app_text.dart';
import 'package:invoice_app/presentation/viewmodels/business_registration_viewmodel.dart';

import '../../core/constants/app_colors.dart';

class LogoRegistrationScreen extends StatefulWidget {
  final String businessName;
  final String businessAddress;
  final String? businessPhone;
  final String? businessEmail;
  const LogoRegistrationScreen({
    super.key,
    required this.businessName,
    required this.businessAddress,
    this.businessPhone,
    this.businessEmail,
  });

  @override
  State<LogoRegistrationScreen> createState() => _LogoRegistrationScreenState();
}

class _LogoRegistrationScreenState extends State<LogoRegistrationScreen> {
  bool isLastPage = false;
  final pageController = PageController();
  TextEditingController businessLogoController = TextEditingController();
  TextEditingController managerSignatureController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.bgColor,
      bottomNavigationBar: AppButton(
        label: "Terminer",
        onTap: () {
          AddBusinessViewModel().createBusiness(
            widget.businessName,
            widget.businessAddress,
            widget.businessPhone!,
            widget.businessEmail!,
            businessLogoController.text,
            managerSignatureController.text,
            context,
          );
        },
      ),
      body: SingleChildScrollView(
        child: SafeArea(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 24.w),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              spacing: 25.h,
              mainAxisSize: MainAxisSize.min,
              children: [
                SizedBox(height: 28.h),
                AppText(
                  text: "Ajoutez votre logo et votre signature",
                  weight: FontWeight.w500,
                  size: 28.sp,
                ),
                Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  spacing: 5.h,
                  children: [
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 8.w),
                      child:
                          AppText(text: "Votre logo (Facultatif)", size: 14.sp),
                    ),
                    InkWell(
                      child: Container(
                        height: 228.h,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(18.r),
                        ),
                        child: Center(
                          child: Container(
                            margin: EdgeInsets.all(8.w),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(10.r),
                              border: Border.all(
                                style: BorderStyle.solid,
                                color: AppColor.bgColor,
                              ),
                            ),
                            child: Center(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(Icons.image_outlined),
                                  AppText(
                                      text: "Ajouter votre logo", size: 14.sp)
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  spacing: 5.h,
                  children: [
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 8.w),
                      child: AppText(
                          text: "Votre signature (Facultatif)", size: 14.sp),
                    ),
                    InkWell(
                      child: Container(
                        height: 128.h,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(18.r),
                        ),
                        child: Center(
                          child: Container(
                            margin: EdgeInsets.all(8.w),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(10.r),
                              border: Border.all(
                                style: BorderStyle.solid,
                                color: AppColor.bgColor,
                              ),
                            ),
                            child: Center(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(Icons.text_snippet_outlined),
                                  AppText(
                                      text: "Ajouter votre signature",
                                      size: 14.sp)
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
