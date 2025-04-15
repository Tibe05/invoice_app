import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:invoice_app/core/constants/app_colors.dart';
import 'package:invoice_app/core/extensions/number_formatter.dart';
import 'package:invoice_app/presentation/components/app_button.dart';
import 'package:invoice_app/presentation/components/app_text.dart';
import 'package:invoice_app/presentation/components/options_picker_bottomsheet.dart';
import 'package:invoice_app/presentation/viewmodels/add_client_viewmodel.dart';
import 'package:invoice_app/presentation/viewmodels/add_item_viewmodel.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AddInvoiceViewModel extends ChangeNotifier {
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

  // Getters
  Map<String, String> get clientData => _clientData;
  List<Map<String, dynamic>> get items => _items;
  DateTime get issueDate => _issueDate;

  // Due date option
  DateTime? _dueDateOption;

  // Getter for due date option
  DateTime? get dueDateOption => _dueDateOption;

  // Setter for due date option
  void setDueDate(DateTime? dueDate) {
    _dueDateOption = dueDate;
    print("Due date set: $_dueDateOption");
    notifyListeners();
  }

  // Set new issue date
  void setIssueDate(DateTime date) {
    _issueDate = date;
    print("Issue date set: $_issueDate");
    notifyListeners();
  }

  // Setters
  void setClientData(Map<String, String> clientData) {
    _clientData = clientData;
    print("Client data set: $_clientData");
    notifyListeners();
  }

  // Methods for managing items
  void addItem(String name, int quantity, double price) {
    _items.add({
      'name': name,
      'quantity': quantity,
      'price': price,
    });
    notifyListeners();
  }

  void updateItem(int index, String name, int quantity, double price) {
    if (index >= 0 && index < _items.length) {
      _items[index] = {
        'name': name,
        'quantity': quantity,
        'price': price,
      };
      notifyListeners();
    }
  }

  void removeItem(int index) {
    if (index >= 0 && index < _items.length) {
      _items.removeAt(index);
      notifyListeners();
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
                        return InkWell(
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
                            InkWell(
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
                  onChanged: (value) {
                    // Handle description input
                    print("Description: $value");
                  },
                ),
              ],
            ),
            SizedBox(height: 20.h),
            //PRIX ET QUANTITÉ
            itemInformationRow(
              context,
              itemName: snapshot.data![index]['itemName'].toString(),
              quantity: 1,
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
                  1,
                  itemPrice.toDouble(),
                );
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
    required int quantity,
    required double price,
  }) {
    List<String> dueDateOpts = [
      "Pas de date d'échéance",
      "A la reception de la facture",
      "Dans 10 jours",
      "Dans 15 jours",
      "Dans 30 jours",
      "Dans 60 jours"
    ];
    String selectedDueDateOpt = "1";
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
              Flexible(
                flex: 2,
                child: TextField(
                  //TODO: ADD A CONTROLLER
                  controller: TextEditingController(text: selectedDueDateOpt),
                  keyboardType: TextInputType.number,
                  inputFormatters: [
                    FilteringTextInputFormatter.digitsOnly,
                  ],
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
                  onChanged: (value) {
                    selectedDueDateOpt = value;
                    print("Due date option changed: $selectedDueDateOpt");
                  },
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

  Stream<List<Map<String, dynamic>>> getInvoices() async* {
    final FirebaseFirestore firestore = FirebaseFirestore.instance;
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final businessId = prefs.getString('businessId');

    // Stream the CLIENTS collection where userID matches the given userId
    yield* firestore
        .collection('INVOICES')
        .where('businessId', isEqualTo: businessId)
        .orderBy('timestamp', descending: true)
        .snapshots()
        .map((querySnapshot) =>
            querySnapshot.docs.map((doc) => doc.data()).toList());
  }
}
