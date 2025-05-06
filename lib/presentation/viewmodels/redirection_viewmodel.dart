import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:invoice_app/presentation/views/screens/auth_screen.dart';
import 'package:invoice_app/presentation/views/screens/business_registration_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../views/screens/home_screen.dart';

class RedirectionViewModel extends StatefulWidget {
  final bool fromLoginView;
  const RedirectionViewModel({super.key, required this.fromLoginView});

  @override
  _RedirectionViewModelState createState() => _RedirectionViewModelState();
}

class _RedirectionViewModelState extends State<RedirectionViewModel> {
  @override
  void initState() {
    super.initState();
    _checkBusinessRegistrationStatus(widget.fromLoginView);
  }

  Future<void> _checkBusinessRegistrationStatus(bool fromLoginView) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final bool isBusinessRegistered =
        prefs.getBool('isBusinessRegistered') ?? false;
    //Check if user is logged in on firebase
    final bool isLoggedIn = FirebaseAuth.instance.currentUser != null;
    if (!isLoggedIn) {
      if (mounted) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => AuthScreen()),
      );
      }
      return;
    }

    if (mounted) {
      if (isBusinessRegistered == true) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => HomeScreen()),
        );
      } else {
        Navigator.pushReplacement(
            context,
            MaterialPageRoute(
                builder: (context) => !fromLoginView ?
                    AuthScreen() : BusinessRegistrationScreen()),
            );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: CircularProgressIndicator(),
      ),
    );
  }
}
