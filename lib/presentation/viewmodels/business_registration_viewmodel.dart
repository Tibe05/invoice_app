import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:invoice_app/core/constants/app_colors.dart';
import 'package:invoice_app/presentation/views/screens/home_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AddBusinessViewModel {
  Future<void> createBusiness(
    String businessName,
    String businessAddress,
    String businessPhone,
    String businessEmail,
    String businessLogo,
    String managerSignature,
    BuildContext context,
  ) async {
    final FirebaseFirestore firestore = FirebaseFirestore.instance;
    final businessId = firestore.collection('USERS').doc().id;
    User? user = FirebaseAuth.instance.currentUser;
    // Create a map to store business data
    Map<String, dynamic> businessData = {
      //'businessId': businessId,
      'businessName': businessName,
      'businessAddress': businessAddress,
      'businessPhone': businessPhone,
      'businessEmail': businessEmail,
      'businessLogo': businessLogo,
      'managerSignature': managerSignature,
      'timestamp': FieldValue.serverTimestamp(),
    };

    try {
      // Show loading dialog
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return const Center(
            child: CircularProgressIndicator(
              color: AppColor.btnColor,
            ),
          );
        },
      );

      // Update the business data in the USERS collection in Firestore
      await firestore
          .collection('USERS')
          .doc(user!.uid)
          .update(businessData)
          .then((_) async {
        final SharedPreferences prefs = await SharedPreferences.getInstance();
        await prefs.setBool('isBusinessRegistered', true);
        await prefs.setString('businessId', businessId);
        await prefs.setString('businessName', businessName);
      });
      Navigator.of(context).pop();

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Business created successfully!')),
      );
    } catch (e) {
      // Handle any errors that occur during the operation
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to create business: $e')),
      );
    } finally {
      // Dismiss the loading dialog
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => HomeScreen(),
        ),
      );
    }
  }

  Future<List<Map<String, dynamic>>> getbusinesssByUserId(String userId) async {
    final FirebaseFirestore firestore = FirebaseFirestore.instance;

    // Query the businessS collection where userID matches the given userId
    QuerySnapshot querySnapshot = await firestore
        .collection('USERS')
        .orderBy('timestamp', descending: true)
        .get();

    // Map the query results to a list of business data
    return querySnapshot.docs
        .map((doc) => doc.data() as Map<String, dynamic>)
        .toList();
  }
}
