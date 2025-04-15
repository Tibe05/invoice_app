import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:invoice_app/presentation/components/app_button.dart';
import 'package:invoice_app/presentation/components/app_text.dart';
import 'package:invoice_app/presentation/viewmodels/add_client_viewmodel.dart';

import '../../core/constants/app_colors.dart';
import '../components/app_textfield.dart';

class AddClientScreen extends StatefulWidget {
  const AddClientScreen({super.key});

  @override
  State<AddClientScreen> createState() => _AddClientScreenState();
}

class _AddClientScreenState extends State<AddClientScreen> {
  TextEditingController clientNameController = TextEditingController();
  TextEditingController clientAddressController = TextEditingController();
  TextEditingController clientPhoneController = TextEditingController();
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
          AddClientViewModel().createClient(
            "1",
            clientNameController.text,
            clientAddressController.text,
            clientPhoneController.text,
            context,
          );
          //Navigator.pop(context);
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
                        text: "Ajouter un client",
                        weight: FontWeight.w500,
                        size: 28.sp,
                      ),
                      SizedBox(height: 5.h),
                      AppTextfield(
                        controller: clientNameController,
                        label: "Nom du client ou de l'entreprise",
                        hint: "ex: Orange CI",
                      ),
                      AppTextfield(
                        controller: clientAddressController,
                        label: "Adresse du client",
                        hint: "ex: Abidjan, Riviera Golf",
                      ),
                      AppTextfield(
                        controller: clientPhoneController,
                        label: "Numéro de téléphone du client",
                        hint: "ex: +225 0000-0000-00",
                      ),
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
}
