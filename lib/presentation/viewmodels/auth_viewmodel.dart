import 'dart:developer';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:invoice_app/core/extensions/dialog_extensions.dart';
import 'package:invoice_app/presentation/viewmodels/redirection_viewmodel.dart';
import 'package:invoice_app/presentation/views/screens/auth_screen.dart';
import 'package:invoice_app/presentation/views/screens/business_registration_screen.dart';
import 'package:vibration/vibration.dart';

class AuthViewModel extends ChangeNotifier {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> createAccount(
    BuildContext context,
    String email,
    String password,
    String username,
  ) async {
    if (email.isEmpty || password.isEmpty || username.isEmpty) {
      log('Error: All fields must be filled');
      Fluttertoast.showToast(
        msg: "Tous les champs doivent être remplis",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.red,
        textColor: Colors.white,
        fontSize: 16.sp,
      );
      return;
    }

    try {
      context.showLoadingDialog();

      UserCredential userCredential =
          await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      User? user = userCredential.user;

      if (user != null) {
        await _firestore.collection('USERS').doc(user.uid).set({
          'id': user.uid,
          'email': email,
          'username': username,
          'createdAt': DateTime.now(),
        });
        log('Account created successfully for $email');
        context.dismissDialog();
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(
            builder: (context) =>
                const BusinessRegistrationScreen(), // Replace with your home screen
          ),
        );
      }
    } catch (e) {
      log('Error creating account: $e');
      context.dismissDialog();
      // Handle specific error codes if needed
      if (e is FirebaseAuthException) {
        if (e.code == 'weak-password') {
          Fluttertoast.showToast(
            msg: "Le mot de passe est trop faible",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.CENTER,
            timeInSecForIosWeb: 1,
            backgroundColor: Colors.red,
            textColor: Colors.white,
            fontSize: 16.sp,
          );
        } else if (e.code == 'email-already-in-use') {
          Fluttertoast.showToast(
            msg: "L'email est déjà utilisé",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.CENTER,
            timeInSecForIosWeb: 1,
            backgroundColor: Colors.red,
            textColor: Colors.white,
            fontSize: 16.sp,
          );
        }
      }
      // Handle other errors
      // For example, network issues, invalid email format, etc.
      else if (e is SocketException) {
        //MAKE A PHONE VIBRATION ALONG WITH THE TOAST MESSAGE
        if (await Vibration.hasVibrator() ?? false) {
          Vibration.vibrate(duration: 500);
        }
        Fluttertoast.showToast(
          msg:
              "Problème de connexion réseau. Veuillez vérifier votre connexion.",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 16.sp,
        );
      } else {
        Fluttertoast.showToast(
          msg: "Une erreur s'est produite. Veuillez réessayer.",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 16.sp,
        );
      }
    }
  }

  //SIGN IN
  // This method is used to sign in the user with email and password
  Future<void> signIn(
    BuildContext context,
    String email,
    String password,
  ) async {
    if (email.isEmpty || password.isEmpty) {
      log('Error: All fields must be filled');
      Fluttertoast.showToast(
        msg: "Tous les champs doivent être remplis",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.red,
        textColor: Colors.white,
        fontSize: 16.sp,
      );
      return;
    }

    try {
      context.showLoadingDialog();
      await _auth.signInWithEmailAndPassword(email: email, password: password);
      log('Sign-in successful for $email');
      context.dismissDialog();
      log('User is logged in: ${_auth.currentUser?.email}');

      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (context) => RedirectionViewModel(
            fromLoginView: true,
          ), // Replace with your home screen
        ),
      );
    } catch (e) {
      log('Error signing in: $e');
      context.dismissDialog();
      if (e is FirebaseAuthException) {
        if (e.code == 'user-not-found') {
          Fluttertoast.showToast(
            msg: "Utilisateur non trouvé",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.CENTER,
            timeInSecForIosWeb: 1,
            backgroundColor: Colors.red,
            textColor: Colors.white,
            fontSize: 16.sp,
          );
        } else if (e.code == 'wrong-password') {
          Fluttertoast.showToast(
            msg: "Mot de passe incorrect",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.CENTER,
            timeInSecForIosWeb: 1,
            backgroundColor: Colors.red,
            textColor: Colors.white,
            fontSize: 16.sp,
          );
        } else if (e.code == 'invalid-credential') {
          //MAKE A PHONE VIBRATION ALONG WITH THE TOAST MESSAGE
          if (await Vibration.hasVibrator() ?? false) {
            Vibration.vibrate(duration: 500);
          }
          Fluttertoast.showToast(
            msg: "Identifiants invalides",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.CENTER,
            timeInSecForIosWeb: 1,
            backgroundColor: Colors.red,
            textColor: Colors.white,
            fontSize: 16.sp,
          );
        } else {
          Fluttertoast.showToast(
            msg: "Une erreur s'est produite. Veuillez réessayer.",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.CENTER,
            timeInSecForIosWeb: 1,
            backgroundColor: Colors.red,
            textColor: Colors.white,
            fontSize: 16.sp,
          );
        }
      } else if (e is SocketException) {
        Fluttertoast.showToast(
          msg:
              "Problème de connexion réseau. Veuillez vérifier votre connexion.",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 16.sp,
        );
      } else {
        Fluttertoast.showToast(
          msg: "Une erreur s'est produite. Veuillez réessayer.",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 16.sp,
        );
      }
    }
  }

  //SIGN IN WITH GOOGLE
  // This method is used to sign in the user with Google account
  Future<void> signInWithGoogle() async {
    try {
      final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
      final GoogleSignInAuthentication? googleAuth =
          await googleUser?.authentication;

      if (googleAuth != null) {
        final credential = GoogleAuthProvider.credential(
          accessToken: googleAuth.accessToken,
          idToken: googleAuth.idToken,
        );

        await _auth.signInWithCredential(credential);
        log('Google sign-in successful');
      } else {
        log('Google sign-in aborted by user');
      }
    } catch (e) {
      log('Error signing in with Google: $e');
    }
  }

  //SIGN OUT
  Future<void> signOut() async {
    try {
      await _auth.signOut();
      log('Sign-out successful');
    } catch (e) {
      log('Error signing out: $e');
    }
  }

  //DELETE ACCOUNT
  // This method is used to delete the user account
  Future<void> deleteAccount(BuildContext context) async {
    try {
      User? user = _auth.currentUser;
      if (user != null) {
        await user.delete();
        log('Account deleted successfully for ${user.email}');
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(
            builder: (context) =>
                const AuthScreen(), // Replace with your auth screen
          ),
        );
      }
    } catch (e) {
      log('Error deleting account: $e');
    }
  }
}
