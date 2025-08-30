import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:invoice_app/core/constants/app_colors.dart';
import 'package:invoice_app/core/extensions/dialog_extensions.dart';
import 'package:invoice_app/core/extensions/number_formatter.dart';
import 'package:invoice_app/presentation/components/app_button.dart';
import 'package:invoice_app/presentation/components/app_text.dart';
import 'package:invoice_app/presentation/viewmodels/add_client_viewmodel.dart';
import 'package:invoice_app/presentation/viewmodels/add_item_viewmodel.dart';
import 'package:invoice_app/presentation/views/screens/home_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AddInvoiceViewModel extends ChangeNotifier {
  //Create a TextEditingController for the item quantity typed
  TextEditingController itemQuantityController =
      TextEditingController(text: '1');

  //Create a TextEditingController for the Item Description
  final TextEditingController itemDescriptionController =
      TextEditingController();
  // Client data
  Map<String, String> _clientData = {
    // 'clientId': '',
    // 'clientName': '',
    // 'clientAddress': '',
    // 'clientPhone': '',
  };

  // Items data
  final List<Map<String, dynamic>> _items = [];

  // Issue date
  DateTime _issueDate = DateTime.now();

  //TVA VALUE
  int _tvaValue = 0;
  int get tvaValue => _tvaValue;
  void setTvaValue(int value) {
    _tvaValue = value;
    log("TVA Value set: $_tvaValue");
    notifyListeners();
  }

  //TOTAL HORS TAXE
  int _totalHT = 0;
  int get totalHT => _totalHT;
  set totalHT(int value) {
    _totalHT = value;
    log("Total HT set: $_totalHT");
    notifyListeners();
  }

  //TOTAL TTC = TOTAL HT * TVA
  int get totalTTC => _totalHT + (_totalHT * _tvaValue / 100).toInt();

  // set totalTTC(int value) {
  //   _totalHT = value;
  //   log("Total TTC set: $_totalHT");
  //   notifyListeners();
  // }

  // Getters
  Map<String, String> get clientData => _clientData;
  List<Map<String, dynamic>> get items => _items;
  DateTime get issueDate => _issueDate;

  // Due date option
  Map<String, dynamic>? _dueDateOption;
  // Getter for due date option
  Map<String, dynamic>? get dueDateOption => _dueDateOption;

  // Currency
  String _currency = "FCFA"; // Default currency
  String get currency => _currency;

  void setCurrency(String selectedCurrency) {
    _currency = selectedCurrency;
    log("Currency set: $_currency");
    notifyListeners();
  }

  // Setter for due date option
  void setDueDate(DateTime? dueDate, String dateString) {
    _dueDateOption = {
      'date': dueDate,
      'meaning': dateString,
    };
    log("Due date set: $_dueDateOption");
    notifyListeners();
  }

  // Set new issue date
  void setIssueDate(DateTime date) {
    _issueDate = date;
    log("Issue date set: $_issueDate");
    notifyListeners();
  }

  // Setters
  void setClientData(Map<String, String> clientData) {
    _clientData = clientData;
    log("Client data set: $_clientData");
    notifyListeners();
  }

  // Methods for managing items
  void addItem(String name, int quantity, int price, {String? description}) {
    // Check if the item already exists in the list
    for (var item in _items) {
      if (item['itemName'] == name) {
        // If it exists, update the quantity and price
        item['itemQuantity'] += quantity;
        item['itemPrice'] = price; // Update the price if needed
        item['itemDescription'] =
            description; // Update the description if needed
        log("Item already exists, updated: $item");
        notifyListeners();
        return;
      }
    }
    // If it doesn't exist, add a new item
    _items.add({
      'itemName': name,
      'itemQuantity': quantity,
      'itemPrice': price,
      'itemDescription': description, // Optional description field
    });
    log("Selected item list (${_items.length} items): $_items");
    notifyListeners();
  }

  // Update an item in the list
  void updateItem(int index, String name, int quantity, int price) {
    if (index >= 0 && index < _items.length) {
      _items[index] = {
        'itemName': name,
        'itemQuantity': quantity,
        'itemPrice': price,
      };
      log("Selected item list after update (${_items.length} items): $_items");
      notifyListeners();
    }
  }

  // Remove an item from the list
  void removeItem(int index) {
    if (index >= 0 && index < _items.length) {
      _items.removeAt(index);
      log("Selected item list after deletion (${_items.length} items): $_items");
      notifyListeners();
    }
  }

  //INITIALIZE INVOICE DATA FOR PDF
  Map<String, dynamic> _invoiceDataPDF = {};
  Map<String, dynamic> get invoiceDataPDF => _invoiceDataPDF;

  //INVOICE
  void createInvoice(BuildContext context) async {
    try {
      context.showLoadingDialog();
      final FirebaseFirestore firestore = FirebaseFirestore.instance;
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      User? user = FirebaseAuth.instance.currentUser;
      final invoiceId = firestore.collection('INVOICES').doc().id;

      // Define invoice number
      final invoiceNumber = prefs.getString('invoiceNumber') ?? '0001';
      final newInvoiceNumber =
          (int.parse(invoiceNumber) + 1).toString().padLeft(4, '0');
      prefs.setString('invoiceNumber', newInvoiceNumber);

      // Create the invoice data
      Map<String, dynamic> invoiceData = {
        'invoiceNumber': newInvoiceNumber,
        'invoiceId': invoiceId,
        //'userName': ,
        'clientData': _clientData,
        'items': _items,
        'issueDate': _issueDate,
        'dueDate': _dueDateOption,
        'tvaValue': _tvaValue,
        'totalHT': _totalHT,
        'totalTTC': totalTTC,
        'currency': _currency,
        'businessId': user?.uid,
        'timestamp': FieldValue.serverTimestamp(),
      };

      // Save the invoice data to the PDF data map
      _invoiceDataPDF = {
        'invoiceNumber': newInvoiceNumber,
        'clientName': _clientData['clientName'] ?? "",
        'clientAddress': _clientData['clientAddress'] ?? "",
        'clientPhone': _clientData['clientPhone'] ?? "",
        'items': _items,
        'issueDate': _issueDate.toString(),
        'dueDate': _dueDateOption?["meaning"] ?? "",
        'tvaValue': _tvaValue.toString(),
        'totalHT': _totalHT.toString(),
        'currency': _currency,
        'totalTTC': totalTTC.toString(),
      };

      // Add the invoice to Firestore
      await firestore.collection('INVOICES').doc(invoiceId).set(invoiceData);
      log("Invoice N°$newInvoiceNumber created: $invoiceData");
      //Log the invoice pdf data
      log("Invoice PDF data: $_invoiceDataPDF");
      context.dismissDialog();
      // Show a success message
      Fluttertoast.showToast(
        msg: "Facture N°$newInvoiceNumber créée avec succès",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
        timeInSecForIosWeb: 1,
        backgroundColor: AppColor.btnColor,
        textColor: Colors.white,
        fontSize: 14.sp,
      );
      //Clear data
      clearData();
      // Navigate to the home screen or any other screen
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (context) =>
              const HomeScreen(), // Replace with your home screen
        ),
      );
    } catch (e, stackTrace) {
      context.dismissDialog();
      Fluttertoast.showToast(
        msg: "$e",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.red,
        textColor: Colors.white,
        fontSize: 16.sp,
      );
      // Handle any errors that occur during the invoice creation process
      log("Error creating invoice: $e", stackTrace: stackTrace);
    }
  }

  // Clear all data
  void clearData() {
    _clientData = {
      // 'clientId': '',
      // 'clientName': '',
      // 'clientAddress': '',
      // 'clientPhone': '',
    };
    _items.clear();
    _issueDate = DateTime.now();
    _tvaValue = 0;
    _totalHT = 0;

    notifyListeners();
  }

  Future<Map<String, String>?> selectClient(BuildContext context) async {
    return await showModalBottomSheet<Map<String, String>>(
      context: context,
      isScrollControlled: true,
      builder: (context) {
        return DraggableScrollableSheet(
          expand: false,
          builder: (context, scrollController) {
            return Container(
              padding: EdgeInsets.all(16.w),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.vertical(top: Radius.circular(32.r)),
              ),
              child: StreamBuilder(
                stream: AddClientViewModel().getClientsByUserId(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(
                      child: CircularProgressIndicator(
                        color: AppColor.btnColor,
                      ),
                    );
                  } else if (snapshot.hasError) {
                    return Center(child: Text('Error: ${snapshot.error}'));
                  } else if (snapshot.hasData && snapshot.data!.isNotEmpty) {
                    return ListView.builder(
                      itemCount: snapshot.data!.length,
                      itemBuilder: (context, index) {
                        return GestureDetector(
                          onTap: () {
                            Map<String, String> clientData = {
                              'clientId': snapshot.data![index]['clientId'],
                              'clientName': snapshot.data![index]['clientName'],
                              'clientAddress': snapshot.data![index]
                                  ['clientAddress'],
                              'clientPhone': snapshot.data![index]
                                  ['clientPhone'],
                            };
                            //setClientData(clientData);
                            _clientData = clientData;
                            notifyListeners();
                            print("Client data set: $_clientData");
                            // Close the bottom sheet and return the selected client data
                            // Navigator.pop(context, clientData);
                            Navigator.pop(context);
                          },
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              ListTile(
                                title: AppText(
                                  text:
                                      snapshot.data![index]['clientName'] ?? "",
                                  size: 16.sp,
                                ),
                                subtitle: AppText(
                                  text: snapshot.data![index]
                                          ['clientAddress'] ??
                                      "",
                                  size: 14.sp,
                                  color: AppColor.subText,
                                ),
                                trailing: AppText(
                                  text: snapshot.data![index]['clientPhone'] ??
                                      "",
                                  size: 14.sp,
                                  color: AppColor.subText,
                                ),
                              ),
                              if (index != snapshot.data!.length - 1)
                                Divider(
                                  color:
                                      const Color.fromARGB(36, 125, 132, 141),
                                  height: 1.h,
                                  thickness: 1.h,
                                  indent: 10.w,
                                  endIndent: 10.w,
                                ),
                            ],
                          ),
                        );
                      },
                    );
                  } else {
                    return Center(
                      child: AppText(
                        text: "Auncun client trouvé",
                        size: 18.sp,
                        weight: FontWeight.w400,
                      ),
                    );
                  }
                },
              ),
            );
          },
        );
      },
    );
  }

  Future<Map<String, String>?> selectItem(BuildContext context) async {
    return await showModalBottomSheet<Map<String, String>>(
      context: context,
      isScrollControlled: true,
      builder: (context) {
        return DraggableScrollableSheet(
          expand: false,
          builder: (context, scrollController) {
            return Container(
              padding: EdgeInsets.all(16.w),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.vertical(top: Radius.circular(32.r)),
              ),
              child: StreamBuilder(
                stream: AddItemViewModel().getItemsByUserId(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(
                        child: CircularProgressIndicator(
                      color: AppColor.btnColor,
                    ));
                  } else if (snapshot.hasError) {
                    return Center(child: Text('Error: ${snapshot.error}'));
                  } else if (snapshot.hasData && snapshot.data!.isNotEmpty) {
                    return ListView.builder(
                      itemCount: snapshot.data!.length,
                      itemBuilder: (context, index) {
                        int itemPrice = snapshot.data![index]['itemPrice'] ?? 0;
                        return Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            GestureDetector(
                              onTap: () async {
                                showModalBottomSheet(
                                    context: context,
                                    isScrollControlled: true,
                                    //Ensures the keyboard
                                    //doesn't override the bottom sheet
                                    builder: (context) {
                                      return Padding(
                                        padding: EdgeInsets.only(
                                          bottom: MediaQuery.of(context)
                                              .viewInsets
                                              .bottom,
                                        ),
                                        child: itemDetailsContent(
                                          context,
                                          index: index,
                                          itemPrice: itemPrice.toDouble(),
                                          snapshot: snapshot,
                                        ),
                                      );
                                    });
                              },
                              child: ListTile(
                                title: AppText(
                                  text: snapshot.data![index]['itemName'] ?? "",
                                  size: 16.sp,
                                ),
                                trailing: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  spacing: 5.w,
                                  children: [
                                    AppText(
                                      text: " ${itemPrice.toDotSeparated()}",
                                      size: 14.sp,
                                      color: AppColor.subText,
                                    ),
                                    AppText(
                                      text: "FCFA",
                                      size: 14.sp,
                                      color: AppColor.subText,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            if (index != snapshot.data!.length - 1)
                              Divider(
                                color: const Color.fromARGB(36, 125, 132, 141),
                                height: 1.h,
                                thickness: 1.h,
                                indent: 10.w,
                                endIndent: 10.w,
                              ),
                          ],
                        );
                      },
                    );
                  } else {
                    return Center(
                      child: AppText(
                        text: "Liste des produits ou services",
                        size: 18.sp,
                        weight: FontWeight.w400,
                      ),
                    );
                  }
                },
              ),
            );
          },
        );
      },
    );
  }

  Widget itemDetailsContent(
    BuildContext context, {
    required int index,
    required double itemPrice,
    required AsyncSnapshot<List<Map<String, dynamic>>> snapshot,
  }) {
    return SingleChildScrollView(
      child: Container(
        width: double.infinity,
        //height: 520.h,
        padding: EdgeInsets.all(16.w),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(
            top: Radius.circular(32.r),
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(height: 8.h),
            Container(
              width: double.infinity,
              decoration: BoxDecoration(
                color: AppColor.bgColor,
                borderRadius: BorderRadius.circular(16.r),
              ),
              padding: EdgeInsets.symmetric(
                horizontal: 14.w,
                vertical: 10.h,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  AppText(
                    text: "${snapshot.data![index]['itemName']}",
                    weight: FontWeight.w600,
                    size: 16.sp,
                  ),
                ],
              ),
            ),
            SizedBox(height: 25.h),
            //DESCRIPTION
            Column(
              spacing: 5.h,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: 8.w,
                  ),
                  child: AppText(
                    text: "Description (facultatif)",
                    weight: FontWeight.w500,
                    size: 14.sp,
                  ),
                ),
                TextFormField(
                  //TODO: ADD A CONTROLLER
                  controller: itemDescriptionController,

                  style: GoogleFonts.getFont(
                    "Urbanist",
                    fontSize: 14.sp,
                    color: AppColor.textColor,
                  ),
                  cursorColor: const Color.fromARGB(117, 0, 0, 0),
                  textCapitalization: TextCapitalization.sentences,
                  keyboardType: TextInputType.multiline,
                  maxLines: null,
                  decoration: InputDecoration(
                    hintText: "Ajouter une description...\n",
                    //"ex: Séance de coaching : accompagnement personnalisé, définition d'objectifs, suivi.\n",
                    hintStyle: GoogleFonts.getFont(
                      "Urbanist",
                      fontSize: 14.sp,
                      color: AppColor.subText,
                    ),
                    filled: true,
                    fillColor: AppColor.lineStroke,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(16.r),
                      borderSide: BorderSide.none,
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(18.r),
                      borderSide: BorderSide(
                        color: const Color.fromARGB(117, 0, 0, 0),
                      ),
                    ),
                  ),
                  // onChanged: (value) {
                  //   // Handle description input
                  //   print("Description: $value");
                  // },
                ),
              ],
            ),
            SizedBox(height: 20.h),
            //PRIX ET QUANTITÉ
            itemInformationRow(
              context,
              itemName: snapshot.data![index]['itemName'].toString(),
              // quantity: itemQuantityController.text.isNotEmpty
              //     ? int.parse(itemQuantityController.text)
              //     : 1,
              price: itemPrice.toDouble(),
            ),
            SizedBox(height: 40.h),
            AppButton(
              label: "Ajouter",
              addMargin: false,
              onTap: () {
                // Add the item to the invoice
                addItem(
                  snapshot.data![index]['itemName'],
                  itemQuantityController.text.isNotEmpty
                      ? int.parse(itemQuantityController.text)
                      : 1,
                  itemPrice.toInt(),
                  description: itemDescriptionController.text,
                  // description: snapshot.data![index]['itemDescription'],
                );
                //Update the total HT
                totalHT += itemPrice.toInt() *
                    (itemQuantityController.text.isNotEmpty
                        ? int.parse(itemQuantityController.text)
                        : 1);

                // Reset the quantity to the default value

                Future.delayed(const Duration(milliseconds: 300), () {
                  // Clear the text field after adding the item
                  itemQuantityController.text = '1';
                  itemDescriptionController.text = '';
                });
                // Close the bottom sheet
                Navigator.pop(context);

                Navigator.pop(context);
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget itemInformationRow(
    BuildContext context, {
    required String itemName,
    //required int quantity,
    required double price,
  }) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      spacing: 5.h,
      children: [
        Padding(
          padding: EdgeInsets.symmetric(
            horizontal: 14.w,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Flexible(
                flex: 2,
                child: SizedBox(
                  width: double.infinity / 3,
                  //color: Colors.red,
                  child: AppText(
                    text: "Prix",
                    weight: FontWeight.w500,
                    size: 14.sp,
                    alignment: TextAlign.start,
                  ),
                ),
              ),
              VerticalDivider(
                color: const Color.fromARGB(36, 125, 132, 141),
                thickness: 1.h,
                indent: 10.h,
                endIndent: 10.h,
              ),
              Flexible(
                flex: 2,
                child: SizedBox(
                  width: double.infinity / 3,
                  //color: Colors.green,
                  child: AppText(
                    text: "Quantité", //Quantité
                    weight: FontWeight.w500,
                    size: 14.sp,
                    alignment: TextAlign.start,
                  ),
                ),
              ),
              // VerticalDivider(
              //   color: const Color.fromARGB(36, 125, 132, 141),
              //   thickness: 1.h,
              //   indent: 10.h,
              //   endIndent: 10.h,
              // ),
              // Flexible(
              //   flex: 2,
              //   child: SizedBox(
              //     width: double.infinity / 3,
              //     //color: Colors.blue,
              //     child: AppText(
              //       text: "Unité",
              //       weight: FontWeight.w500,
              //       size: 14.sp,
              //       alignment: TextAlign.end,
              //     ),
              //   ),
              // ),
            ],
          ),
        ),
        Container(
          width: double.infinity,
          height: 65.h,
          decoration: BoxDecoration(
            color: AppColor.lineStroke,
            borderRadius: BorderRadius.circular(16.r),
          ),
          padding: EdgeInsets.symmetric(
            horizontal: 14.w,
            vertical: 10.h,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              //PRIX
              Flexible(
                flex: 2,
                child: SizedBox(
                  width: double.infinity / 3,
                  //color: Colors.red,
                  child: AppText(
                    text: "${price.toDotSeparated()} FCFA",
                    weight: FontWeight.w500,
                    size: 14.sp,
                    alignment: TextAlign.start,
                  ),
                ),
              ),
              VerticalDivider(
                color: const Color.fromARGB(36, 125, 132, 141),
                thickness: 1.h,
                indent: 10.h,
                endIndent: 10.h,
              ),
              //QUANTITÉ
              Flexible(
                flex: 2,
                child: TextField(
                  //TODO: ADD A CONTROLLER
                  controller: itemQuantityController,
                  keyboardType: TextInputType.number,
                  inputFormatters: [
                    FilteringTextInputFormatter.digitsOnly,
                    TextInputFormatter.withFunction((oldValue, newValue) {
                      if (newValue.text.isNotEmpty &&
                          int.tryParse(newValue.text) != null) {
                        int quantity = int.parse(newValue.text);
                        if (quantity <= 0) {
                          return oldValue;
                        }
                      }
                      return newValue;
                    }),
                  ],
                  // inputFormatters: [
                  //   FilteringTextInputFormatter.digitsOnly,
                  // ],
                  style: GoogleFonts.getFont(
                    "Urbanist",
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w500,
                    color: AppColor.textColor,
                  ),
                  decoration: InputDecoration(
                    isDense: true,
                    contentPadding: EdgeInsets.zero,
                    border: InputBorder.none,
                  ),
                  // onChanged: (value) {
                  //   selectedDueDateOpt = value;
                  //   print("Due date option changed: $selectedDueDateOpt");
                  // },
                ),
              ),

              // VerticalDivider(
              //   color: const Color.fromARGB(36, 125, 132, 141),
              //   thickness: 1.h,
              //   indent: 10.h,
              //   endIndent: 10.h,
              // ),
              // Flexible(
              //   flex: 2,
              //   child: SizedBox(
              //     width: double.infinity / 3,
              //     //color: Colors.blue,
              //     child: AppText(
              //       text: "001",
              //       weight: FontWeight.w500,
              //       size: 14.sp,
              //       alignment: TextAlign.end,
              //     ),
              //   ),
              // ),
            ],
          ),
        ),
        //AppText(text: "${price.toDotSeparated()} FCFA ", size: size)
      ],
    );
  }

  // Stream to get the list of invoices for the current user
  Stream<List<Map<String, dynamic>>> getInvoices() async* {
    final FirebaseFirestore firestore = FirebaseFirestore.instance;
    //final SharedPreferences prefs = await SharedPreferences.getInstance();
    //final businessId = prefs.getString('businessId');
    User? user = FirebaseAuth.instance.currentUser;

    // Stream the CLIENTS collection where userID matches the given userId
    yield* firestore
        .collection('INVOICES')
        .where('businessId', isEqualTo: user?.uid)
        .orderBy('timestamp', descending: true)
        .snapshots()
        .map((querySnapshot) =>
            querySnapshot.docs.map((doc) => doc.data()).toList());
  }
}
