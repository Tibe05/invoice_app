import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:invoice_app/core/constants/app_colors.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AddItemViewModel {
  Future<void> createItem(
    String userId,
    String itemName,
    int itemPrice,
    BuildContext context,
  ) async {
    final FirebaseFirestore firestore = FirebaseFirestore.instance;
    final itemId = firestore.collection('ITEMS').doc().id;
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final businessId = prefs.getString('businessId');

    // Create a map to store Item data
    Map<String, dynamic> itemData = {
      'businessId': businessId,
      'itemId': itemId,
      'itemName': itemName,
      'itemPrice': itemPrice,
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

      // Save the Item data in the ItemS collection in Firestore
      await firestore.collection('ITEMS').doc(itemId).set(itemData);
      Navigator.of(context).pop();

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Item created successfully!')),
      );
    } catch (e) {
      // Handle any errors that occur during the operation
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to create Item: $e')),
      );
    } finally {
      // Dismiss the loading dialog
      Navigator.of(context).pop();
    }
  }

  Stream<List<Map<String, dynamic>>> getItemsByUserId() async*{
    final FirebaseFirestore firestore = FirebaseFirestore.instance;
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final businessId = prefs.getString('businessId');
    // Query the ItemS collection where userID matches the given userId
    yield* firestore
        .collection('ITEMS')
        .where('businessId', isEqualTo: businessId)
        .orderBy('timestamp', descending: true)
        .snapshots()
        .map((querySnapshot) => querySnapshot.docs
            .map((doc) => doc.data())
            .toList());
  }
}
