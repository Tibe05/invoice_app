import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:invoice_app/presentation/components/app_button.dart';
import 'package:invoice_app/presentation/components/app_text.dart';
import 'package:invoice_app/presentation/components/app_textfield.dart';
import 'package:invoice_app/presentation/screens/logo_registration_screen.dart';

import '../../core/constants/app_colors.dart';

class BusinessRegistrationScreen extends StatefulWidget {
  const BusinessRegistrationScreen({super.key});

  @override
  State<BusinessRegistrationScreen> createState() =>
      _BusinessRegistrationScreenState();
}

class _BusinessRegistrationScreenState
    extends State<BusinessRegistrationScreen> {
  bool isLastPage = false;
  final pageController = PageController();
  TextEditingController businessNameController = TextEditingController();
  TextEditingController businessAddressController = TextEditingController();
  TextEditingController businessPhoneController = TextEditingController();
  TextEditingController businessEmailController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.bgColor,
      bottomNavigationBar: AppButton(
        label: "Continuer",
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => LogoRegistrationScreen(
                businessAddress: businessAddressController.text,
                businessName: businessNameController.text,
                businessEmail: businessEmailController.text,
                businessPhone: businessPhoneController.text,
              ),
            ),
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
                Form(
                  child: Column(
                    spacing: 25.h,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      AppText(
                        text: "Parlez-nous de votre entreprise",
                        weight: FontWeight.w500,
                        size: 28.sp,
                      ),
                      SizedBox(height: 5.h),
                      AppTextfield(
                        controller: businessNameController,
                        label: "Nom de l'entreprise ou votre nom",
                        hint: "ex: John Doe",
                      ),
                      AppTextfield(
                        controller: businessAddressController,
                        label: "Adresse de l'entreprise",
                        hint: "ex: Abidjan, Cocody Angré",
                      ),
                    ],
                  ),
                ),
                contactPart()
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget contactPart() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      spacing: 5.h,
      children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 8.w),
          child: AppText(text: "Contacts", size: 14.sp),
        ),
        Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20.r),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 12.w),
                child: Row(
                  children: [
                    AppText(
                      text: "Téléphone :",
                      size: 15.sp,
                      weight: FontWeight.w500,
                    ),
                    Flexible(
                      child: TextFormField(
                        controller: businessPhoneController,
                        keyboardType: TextInputType.phone,
                        decoration: InputDecoration(
                          hintText: "Facultatif",
                          hintStyle: TextStyle(color: AppColor.subText),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(16.r),
                            borderSide: BorderSide.none,
                          ),
                        ),
                      ),
                    )
                  ],
                ),
              ),
              Divider(
                height: 0,
                color: AppColor.bgColor,
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 12.w),
                child: Row(
                  children: [
                    AppText(
                      text: "Email :",
                      size: 15.sp,
                      weight: FontWeight.w500,
                    ),
                    Flexible(
                      child: TextFormField(
                        controller: businessEmailController,
                        keyboardType: TextInputType.emailAddress,
                        decoration: InputDecoration(
                          hintText: "Facultatif",
                          hintStyle: TextStyle(color: AppColor.subText),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(16.r),
                            borderSide: BorderSide.none,
                          ),
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
