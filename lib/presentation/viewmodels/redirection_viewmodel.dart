import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../screens/home_screen.dart';
import '../screens/business_registration_screen.dart';

class RedirectionViewModel extends StatefulWidget {
  const RedirectionViewModel({super.key});

  @override
  _RedirectionViewModelState createState() => _RedirectionViewModelState();
}

class _RedirectionViewModelState extends State<RedirectionViewModel> {
  @override
  void initState() {
    super.initState();
    _checkBusinessRegistrationStatus();
  }

  Future<void> _checkBusinessRegistrationStatus() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final bool isBusinessRegistered = prefs.getBool('isBusinessRegistered') ?? false;

    if(mounted){
      if (isBusinessRegistered == true) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => HomeScreen()),
      );
    } else {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => BusinessRegistrationScreen()),
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