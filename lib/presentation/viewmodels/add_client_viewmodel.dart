import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:invoice_app/core/constants/app_colors.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AddClientViewModel {
  Future<void> createClient(String userId, String clientName,
      String clientAddress, String clientPhone, BuildContext context) async {
    final FirebaseFirestore firestore = FirebaseFirestore.instance;
    final clientId = firestore.collection('CLIENTS').doc().id;
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final businessId = prefs.getString('businessId');

    // Create a map to store client data
    Map<String, dynamic> clientData = {
      'businessId': businessId,
      'clientId': clientId,
      'clientName': clientName,
      'clientAddress': clientAddress,
      'clientPhone': clientPhone,
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

      // Save the client data in the CLIENTS collection in Firestore
      await firestore.collection('CLIENTS').doc(clientId).set(clientData);
      Navigator.of(context).pop();

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Client created successfully!')),
      );
    } catch (e) {
      // Handle any errors that occur during the operation
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to create client: $e')),
      );
    } finally {
      // Dismiss the loading dialog
      Navigator.of(context).pop();
    }
  }

  Stream<List<Map<String, dynamic>>> getClientsByUserId() async* {
    final FirebaseFirestore firestore = FirebaseFirestore.instance;
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final businessId = prefs.getString('businessId');

    // Stream the CLIENTS collection where userID matches the given userId
    yield* firestore
        .collection('CLIENTS')
        .where('businessId', isEqualTo: businessId)
        .orderBy('timestamp', descending: true)
        .snapshots()
        .map((querySnapshot) => querySnapshot.docs
            .map((doc) => doc.data())
            .toList());
  }
}
