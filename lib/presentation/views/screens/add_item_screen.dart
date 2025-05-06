
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:invoice_app/core/constants/app_colors.dart';
import 'package:invoice_app/core/extensions/dot_separator_formatter.dart';
import 'package:invoice_app/presentation/components/app_button.dart';
import 'package:invoice_app/presentation/components/app_text.dart';
import 'package:invoice_app/presentation/components/app_textfield.dart';
import 'package:invoice_app/presentation/viewmodels/add_item_viewmodel.dart';

class AddItemScreen extends StatefulWidget {
  const AddItemScreen({super.key});

  @override
  State<AddItemScreen> createState() => _AddItemScreenState();
}

class _AddItemScreenState extends State<AddItemScreen> {
  TextEditingController itemNameController = TextEditingController();
  TextEditingController itemPriceController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.bgColor,
      appBar: AppBar(
        forceMaterialTransparency: true,
      ),
      bottomNavigationBar: AppButton(
        label: "Enregistrer",
        onTap: () {
          AddItemViewModel().createItem(
            "1",
            itemNameController.text,
            int.tryParse(itemPriceController.text.replaceAll('.', '')) ?? 0,
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
                Form(
                  child: Column(
                    spacing: 25.h,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      AppText(
                        text: "Ajouter un produit ou service",
                        weight: FontWeight.w500,
                        size: 28.sp,
                      ),
                      SizedBox(height: 5.h),
                      AppTextfield(
                          controller: itemNameController,
                          label: "Nom du produit/service",
                          hint: "ex: Conception de logo",
                          keyboardType: TextInputType.text,
                          textCapitalization: TextCapitalization.sentences),
                      AppTextfield(
                        controller: itemPriceController,
                        keyboardType: TextInputType.number,
                        inputFormatters: [DotSeparatorFormatter()],
                        label: "Prix unitaire",
                        hint: "ex: 50.000 FCFA",
                      ),
                      //unitPrice()
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget unitPrice() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      spacing: 5.h,
      children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 8.w),
          child: AppText(text: "Prix unitaire", size: 14.sp),
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
                      text: "Prix :",
                      size: 15.sp,
                      weight: FontWeight.w500,
                    ),
                    Flexible(
                      child: TextFormField(
                        controller: itemPriceController,
                        keyboardType: TextInputType.phone,
                        decoration: InputDecoration(
                          hintText: "1000 FCFA",
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
                      text: "Quantité :",
                      size: 15.sp,
                      weight: FontWeight.w500,
                    ),
                    Flexible(
                      child: TextFormField(
                        controller: itemNameController,
                        keyboardType: TextInputType.emailAddress,
                        decoration: InputDecoration(
                          hintText: "1",
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
