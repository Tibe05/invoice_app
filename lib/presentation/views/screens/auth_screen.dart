import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:invoice_app/core/constants/app_colors.dart';
import 'package:invoice_app/presentation/components/app_button.dart';
import 'package:invoice_app/presentation/components/app_text.dart';
import 'package:invoice_app/presentation/components/app_textfield.dart';
import 'package:invoice_app/presentation/viewmodels/auth_viewmodel.dart';
import 'package:provider/provider.dart';

class AuthScreen extends StatefulWidget {
  const AuthScreen({super.key});

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  final TextEditingController emailController = TextEditingController();

  final TextEditingController passwordController = TextEditingController();
  final TextEditingController usernameController = TextEditingController();
  bool pageSwitcher =
      true; // This should be managed by a state management solution

  @override
  Widget build(BuildContext context) {
    final authViewModel = Provider.of<AuthViewModel>(context);
    return Scaffold(
        backgroundColor: AppColor.bgColor,
        body: LayoutBuilder(
          builder: (context, constraint) {
            return SingleChildScrollView(
              child: ConstrainedBox(
                constraints: BoxConstraints(minHeight: constraint.maxHeight),
                child: IntrinsicHeight(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Visibility(
                      visible: pageSwitcher,
                      replacement: signupView(authViewModel),
                      child: loginView(authViewModel),
                    ),
                  ),
                ),
              ),
            );
          },
        ));
  }

  Widget signupView(authViewModel) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        //mainAxisSize: MainAxisSize.min,
        children: [
          const Text(
            'Creer un compte',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 40.h),
          Form(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 18.w),
              child: Column(
                spacing: 20.h,
                children: [
                  AppTextfield(
                    label: "Votre nom",
                    hint: "John Doe",
                    controller: usernameController,
                  ),
                  AppTextfield(
                    label: "Email",
                    hint: "example@email.com",
                    controller: emailController,
                    keyboardType: TextInputType.emailAddress,
                    inputFormatters: [
                      FilteringTextInputFormatter.allow(
                        RegExp(r'[a-zA-Z0-9@.]'),
                      ),
                    ],
                  ),
                  AppTextfield(
                    label: "Mot de passe",
                    hint: "********",
                    controller: passwordController,
                    obscureText: true,
                  ),
                  // AppTextfield(
                  //   label: "Confirmer le mot de passe",
                  //   hint: "********",
                  //   controller: passwordController,
                  //   obscureText: true,
                  // ),
                ],
              ),
            ),
          ),
          SizedBox(height: 20.h),
          AppButton(
            label: "Créer un compte",
            onTap: () {
              authViewModel.createAccount(
                context,
                emailController.text,
                passwordController.text,
                usernameController.text,
              );
            },
          ),
          SizedBox(height: 5.h),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              AppText(
                text: "Vous avez déjà un compte ?  ",
                size: 13.sp,
              ),
              InkWell(
                onTap: () {
                  setState(() {
                    pageSwitcher = !pageSwitcher;
                  });
                },
                child: AppText(
                  text: "Connectez-vous",
                  size: 13.sp,
                  weight: FontWeight.bold,
                ),
              )
            ],
          ),
          SizedBox(height: 20.h),
          ElevatedButton.icon(
            onPressed: () {
              // TODO: Implement Google Sign-In logic
            },
            icon: const Icon(Icons.email),
            label: const Text('Continer avec Gmail'),
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 20),
            ),
          ),
        ],
      ),
    );
  }

  Widget loginView(authViewModel) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        //mainAxisSize: MainAxisSize.min,
        children: [
          const Text(
            'Welcome to Invoice App',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 40.h),
          Form(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 18.w),
              child: Column(
                spacing: 20.h,
                children: [
                  AppTextfield(
                    label: "Email",
                    hint: "example@email.com",
                    controller: emailController,
                    keyboardType: TextInputType.emailAddress,
                    textCapitalization: TextCapitalization.none,
                    inputFormatters: [
                      FilteringTextInputFormatter.allow(
                        RegExp(r'[a-zA-Z0-9@.]'),
                      ),
                    ],
                  ),
                  AppTextfield(
                    label: "Password",
                    hint: "********",
                    controller: passwordController,
                    obscureText: true,
                  ),
                ],
              ),
            ),
          ),
          SizedBox(height: 20.h),
          AppButton(
            label: "Se connecter",
            onTap: () {
              authViewModel.signIn(
                context,
                emailController.text,
                passwordController.text,
              );
            },
          ),
          SizedBox(height: 20.h),
          ElevatedButton.icon(
            onPressed: () {
              // TODO: Implement Google Sign-In logic
            },
            icon: const Icon(Icons.email),
            label: const Text('Sign in with Gmail'),
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 20),
            ),
          ),
          const SizedBox(height: 20),
          TextButton(
            onPressed: () {
              // TODO: Navigate to account creation screen
              setState(() {
                pageSwitcher = !pageSwitcher;
              });
            },
            child: const Text('Créer un compte'),
          ),
        ],
      ),
    );
  }
}
