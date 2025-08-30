import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:intl/intl.dart';
import 'package:invoice_app/core/constants/app_colors.dart';
import 'package:invoice_app/core/extensions/number_formatter.dart';
import 'package:invoice_app/presentation/components/app_button.dart';
import 'package:invoice_app/presentation/viewmodels/add_invoice_viewmodel.dart';
import 'package:provider/provider.dart';

import '../../components/app_text.dart';
import '../../components/options_picker_bottomsheet.dart';

class AddInvoiceScreen extends StatefulWidget {
  const AddInvoiceScreen({super.key});

  @override
  State<AddInvoiceScreen> createState() => _AddInvoiceScreenState();
}

class _AddInvoiceScreenState extends State<AddInvoiceScreen> {
  List<String> currencies = ["FCFA", "USD", "EUR"];
  String selectedCurrency = "FCFA";
  List<String> dueDateOpts = [
    "Pas de date d'échéance",
    "A la reception de la facture",
    "Dans 10 jours",
    "Dans 15 jours",
    "Dans 30 jours",
    "Dans 60 jours"
  ];
  String selectedDueDateOpt = "--";
  //DateTime issueDate = DateTime.now();
  TextEditingController clientNameController = TextEditingController();
  TextEditingController clientAddressController = TextEditingController();
  TextEditingController clientPhoneController = TextEditingController();

  DateTime dueDate = DateTime.now();

  @override
  Widget build(BuildContext context) {
    final addInvoiceViewModel = Provider.of<AddInvoiceViewModel>(context);
    return Scaffold(
      backgroundColor: AppColor.bgColor,
      appBar: AppBar(
        centerTitle: true,
        forceMaterialTransparency: true,
        // title: AppText(
        //   text: "Nouvelle facture",
        //   weight: FontWeight.w500,
        //   size: 20.sp,
        // ),
        leading: IconButton(
          icon: Icon(Icons.arrow_back_rounded),
          onPressed: () {
            Navigator.pop(context);
            addInvoiceViewModel.clearData();
          },
        ),
      ),
      bottomNavigationBar: Padding(
        padding:
            EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
        child: AppButton(
          label: "Créer une facture",
          onTap: () async {
            addInvoiceViewModel.setDueDate(dueDate, selectedDueDateOpt);
            addInvoiceViewModel.setCurrency(selectedCurrency);

            addInvoiceViewModel.createInvoice(
              context,
            );
            //Navigator.pop(context);
          },
        ),
      ),
      body: PopScope(
        canPop: true,
        onPopInvokedWithResult: (didPop, result) {
          if (didPop) {
            Future.delayed(const Duration(milliseconds: 300), () {
              addInvoiceViewModel.clearData();
            });
          }
        },
        child: SingleChildScrollView(
          child: SafeArea(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 24.w),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                spacing: 25.h,
                mainAxisSize: MainAxisSize.min,
                children: [
                  //SizedBox(height: 28.h),
                  Form(
                    child: Column(
                      spacing: 25.h,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        AppText(
                          text: "Nouvelle facture",
                          weight: FontWeight.w500,
                          size: 28.sp,
                        ),
                        SizedBox(height: 5.h),
                        //DATES
                        Column(
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
                                        text: "Date d'émission",
                                        weight: FontWeight.w500,
                                        size: 14.sp,
                                        alignment: TextAlign.start,
                                      ),
                                    ),
                                  ),
                                  VerticalDivider(
                                    color:
                                        const Color.fromARGB(36, 125, 132, 141),
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
                                        text: "Date d'échéance", //01 Avr 2025
                                        weight: FontWeight.w500,
                                        size: 14.sp,
                                        alignment: TextAlign.start,
                                      ),
                                    ),
                                  ),
                                  VerticalDivider(
                                    color:
                                        const Color.fromARGB(36, 125, 132, 141),
                                    thickness: 1.h,
                                    indent: 10.h,
                                    endIndent: 10.h,
                                  ),
                                  Flexible(
                                    flex: 2,
                                    child: SizedBox(
                                      width: double.infinity / 3,
                                      //color: Colors.blue,
                                      child: AppText(
                                        text: "N° de facture",
                                        weight: FontWeight.w500,
                                        size: 14.sp,
                                        alignment: TextAlign.end,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Container(
                              width: double.infinity,
                              height: 65.h,
                              decoration: BoxDecoration(
                                color: Colors.white,
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
                                    child: GestureDetector(
                                      onTap: () async {
                                        showModalBottomSheet(
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.vertical(
                                              top: Radius.circular(32.r),
                                            ),
                                          ),
                                          backgroundColor: Colors.white,
                                          context: context,
                                          builder: (BuildContext context) {
                                            return Column(
                                              mainAxisSize: MainAxisSize.min,
                                              children: [
                                                SizedBox(
                                                  height: 15.h,
                                                ),
                                                AppText(
                                                  text: "Date d'émission",
                                                  weight: FontWeight.w600,
                                                  size: 16.sp,
                                                  alignment: TextAlign.center,
                                                ),
                                                SizedBox(
                                                  height: 250.h,
                                                  child: CupertinoDatePicker(
                                                    initialDateTime:
                                                        addInvoiceViewModel
                                                            .issueDate,
                                                    mode:
                                                        CupertinoDatePickerMode
                                                            .date,
                                                    dateOrder:
                                                        DatePickerDateOrder.mdy,
                                                    onDateTimeChanged:
                                                        (DateTime newDate) {
                                                      addInvoiceViewModel
                                                          .setIssueDate(
                                                              newDate);
                                                    },
                                                  ),
                                                ),
                                              ],
                                            );
                                          },
                                        );
                                      },
                                      child: SizedBox(
                                        width: double.infinity / 3,
                                        //color: Colors.red,
                                        child: AppText(
                                          text:
                                              DateFormat('dd MMM yyyy', 'fr_FR')
                                                  .format(addInvoiceViewModel
                                                      .issueDate),
                                          weight: FontWeight.w500,
                                          size: 14.sp,
                                          alignment: TextAlign.start,
                                        ),
                                      ),
                                    ),
                                  ),
                                  VerticalDivider(
                                    color:
                                        const Color.fromARGB(36, 125, 132, 141),
                                    thickness: 1.h,
                                    indent: 10.h,
                                    endIndent: 10.h,
                                  ),
                                  Flexible(
                                    flex: 2,
                                    child: GestureDetector(
                                      onTap: () {
                                        showModalBottomSheet(
                                          context: context,
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.vertical(
                                              top: Radius.circular(32.r),
                                            ),
                                          ),
                                          backgroundColor: Colors.white,
                                          builder: (context) =>
                                              OptionsPickerBottomSheet(
                                            looping: true,
                                            additionalHeight: 70.h,
                                            title: "Date d'échéance",
                                            //title: "Choisir une date d'échéance",
                                            options: dueDateOpts,
                                            currentSelection:
                                                selectedDueDateOpt,
                                            onOptionSelected: (String date) {
                                              // Handle the selected date here
                                              setState(
                                                () {
                                                  selectedDueDateOpt = date;
                                                  if (date ==
                                                      "Pas de date d'échéance") {
                                                    dueDate = DateTime.now();
                                                    selectedDueDateOpt =
                                                        "Pas de date d'échéance";
                                                  } else if (date ==
                                                      "A la reception de la facture") {
                                                    dueDate =
                                                        addInvoiceViewModel
                                                            .issueDate;
                                                    selectedDueDateOpt =
                                                        "A la reception";
                                                  } else if (date ==
                                                      "Dans 10 jours") {
                                                    dueDate =
                                                        addInvoiceViewModel
                                                            .issueDate
                                                            .add(const Duration(
                                                                days: 10));
                                                    selectedDueDateOpt =
                                                        DateFormat(
                                                                'dd MMM yyyy',
                                                                'fr_FR')
                                                            .format(dueDate);
                                                  } else if (date ==
                                                      "Dans 15 jours") {
                                                    dueDate =
                                                        addInvoiceViewModel
                                                            .issueDate
                                                            .add(const Duration(
                                                                days: 15));
                                                    selectedDueDateOpt =
                                                        DateFormat(
                                                                'dd MMM yyyy',
                                                                'fr_FR')
                                                            .format(dueDate);
                                                  } else if (date ==
                                                      "Dans 30 jours") {
                                                    dueDate =
                                                        addInvoiceViewModel
                                                            .issueDate
                                                            .add(const Duration(
                                                                days: 30));
                                                    selectedDueDateOpt =
                                                        DateFormat(
                                                                'dd MMM yyyy',
                                                                'fr_FR')
                                                            .format(dueDate);
                                                  } else if (date ==
                                                      "Dans 60 jours") {
                                                    dueDate =
                                                        addInvoiceViewModel
                                                            .issueDate
                                                            .add(const Duration(
                                                                days: 60));
                                                    selectedDueDateOpt =
                                                        DateFormat(
                                                                'dd MMM yyyy',
                                                                'fr_FR')
                                                            .format(dueDate);
                                                  }
                                                },
                                              );
                                            },
                                          ),
                                        );
                                      },
                                      child: SizedBox(
                                        width: double.infinity / 3,
                                        //color: Colors.green,
                                        child: AppText(
                                          text:
                                              selectedDueDateOpt, //01 Avr 2025
                                          weight: FontWeight.w500,
                                          size: 14.sp,
                                          alignment: TextAlign.start,
                                        ),
                                      ),
                                    ),
                                  ),
                                  VerticalDivider(
                                    color:
                                        const Color.fromARGB(36, 125, 132, 141),
                                    thickness: 1.h,
                                    indent: 10.h,
                                    endIndent: 10.h,
                                  ),
                                  Flexible(
                                    flex: 2,
                                    child: SizedBox(
                                      width: double.infinity / 3,
                                      //color: Colors.blue,
                                      child: AppText(
                                        //INVOICE NUMBER
                                        text: "0001",
                                        weight: FontWeight.w500,
                                        size: 14.sp,
                                        alignment: TextAlign.end,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        //CLIENT
                        Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          spacing: 5.h,
                          children: [
                            //Label
                            Padding(
                              padding: EdgeInsets.symmetric(
                                horizontal: 14.w,
                              ),
                              child: AppText(
                                text: "Client",
                                weight: FontWeight.w500,
                                size: 14.sp,
                                alignment: TextAlign.start,
                              ),
                            ),
                            //InputField
                            GestureDetector(
                              onTap: () async {
                                addInvoiceViewModel.selectClient(context);
                              },
                              child: Container(
                                width: double.infinity,
                                height: 65.h,
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(16.r),
                                ),
                                padding: EdgeInsets.symmetric(
                                  horizontal: 14.w,
                                  vertical: 10.h,
                                ),
                                child: addInvoiceViewModel.clientData.isEmpty
                                    ? Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        spacing: 5.h,
                                        children: [
                                          Icon(
                                            Icons.add_circle,
                                            color: AppColor.btnColor,
                                          ),
                                          AppText(
                                            text: "Ajouter un client",
                                            weight: FontWeight.w600,
                                            size: 14.sp,
                                            alignment: TextAlign.start,
                                          ),
                                        ],
                                      )
                                    : Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        spacing: 5.h,
                                        children: [
                                          AppText(
                                            text: addInvoiceViewModel
                                                    .clientData['clientName'] ??
                                                "",
                                            weight: FontWeight.w500,
                                            size: 16.sp,
                                            alignment: TextAlign.start,
                                          ),
                                          AppText(
                                            text:
                                                addInvoiceViewModel.clientData[
                                                        'clientPhone'] ??
                                                    "",
                                            weight: FontWeight.w400,
                                            size: 14.sp,
                                            alignment: TextAlign.start,
                                          ),
                                        ],
                                      ),
                              ),
                            ),
                          ],
                        ),
                        //ITEMS
                        Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          spacing: 5.h,
                          children: [
                            //Label
                            Padding(
                              padding: EdgeInsets.symmetric(
                                horizontal: 14.w,
                              ),
                              child: AppText(
                                text: "Produits / Services",
                                weight: FontWeight.w500,
                                size: 14.sp,
                                alignment: TextAlign.start,
                              ),
                            ),
                            //InputField
                            Container(
                              width: double.infinity,
                              //height: 65.h,
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(16.r),
                              ),
                              padding: EdgeInsets.symmetric(
                                horizontal: 14.w,
                                vertical: 18.h,
                              ),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  if (addInvoiceViewModel.items.isNotEmpty) ...{
                                    ListView.builder(
                                      shrinkWrap: true,
                                      padding: EdgeInsets.only(bottom: 10.h),
                                      physics:
                                          const NeverScrollableScrollPhysics(),
                                      itemCount:
                                          addInvoiceViewModel.items.length,
                                      itemBuilder: (context, index) {
                                        int itemPrice = addInvoiceViewModel
                                                .items[index]['itemPrice'] ??
                                            0;
                                        return GestureDetector(
                                          child: Slidable(
                                            endActionPane: ActionPane(
                                              motion:
                                                  const DrawerMotion(), // Smooth sliding effect
                                              children: [
                                                SlidableAction(
                                                  onPressed: (context) => {
                                                    addInvoiceViewModel
                                                        .removeItem(index),
                                                  },
                                                  backgroundColor: Colors.red,
                                                  foregroundColor: Colors.white,
                                                  icon: Icons.delete,
                                                  label: 'Delete',
                                                ),
                                              ],
                                            ),
                                            child: Row(
                                              mainAxisSize: MainAxisSize.min,
                                              children: [
                                                AppText(
                                                  text:
                                                      "x${addInvoiceViewModel.items[index]['itemQuantity']}",
                                                  weight: FontWeight.w500,
                                                  size: 16.sp,
                                                  alignment: TextAlign.start,
                                                ),
                                                Flexible(
                                                  child: Container(
                                                    width: double.infinity,
                                                    //height: 65.h,
                                                    decoration: BoxDecoration(
                                                        //color: Colors.red,
                                                        ),
                                                    padding:
                                                        EdgeInsets.symmetric(
                                                      horizontal: 14.w,
                                                      vertical: 10.h,
                                                    ),
                                                    child: Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .spaceBetween,
                                                      // mainAxisSize:
                                                      //     MainAxisSize.min,
                                                      spacing: 5.h,
                                                      children: [
                                                        AppText(
                                                          text:
                                                              " ${addInvoiceViewModel.items[index]['itemName']}",
                                                          weight:
                                                              FontWeight.w500,
                                                          size: 16.sp,
                                                          alignment:
                                                              TextAlign.start,
                                                        ),
                                                        AppText(
                                                          text:
                                                              "${itemPrice.toDotSeparated()} $selectedCurrency",
                                                          //text: addInvoiceViewModel.items[index]['itemPrice'],
                                                          weight:
                                                              FontWeight.w400,
                                                          size: 14.sp,
                                                          alignment:
                                                              TextAlign.start,
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        );
                                      },
                                    ),
                                    Divider(
                                      color: const Color.fromARGB(
                                          36, 125, 132, 141),
                                      thickness: 1.h,
                                      indent: 10.h,
                                      endIndent: 10.h,
                                    ),
                                    SizedBox(
                                      height: 5.h,
                                    ),
                                  },
                                  GestureDetector(
                                    onTap: () async {
                                      addInvoiceViewModel.selectItem(context);
                                    },
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      spacing: 5.h,
                                      children: [
                                        Icon(
                                          Icons.add_circle,
                                          color: AppColor.btnColor,
                                        ),
                                        AppText(
                                          text: "Ajouter un produit / service",
                                          weight: FontWeight.w600,
                                          size: 14.sp,
                                          alignment: TextAlign.start,
                                        ),
                                      ],
                                    ),
                                  )
                                ],
                              ),
                            ),
                          ],
                        ),

                        //TAXE - SOUS TOTAL HT
                        Column(
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
                                        text: "TVA",
                                        weight: FontWeight.w500,
                                        size: 14.sp,
                                        alignment: TextAlign.start,
                                      ),
                                    ),
                                  ),
                                  VerticalDivider(
                                    color:
                                        const Color.fromARGB(36, 125, 132, 141),
                                    thickness: 1.h,
                                    indent: 10.h,
                                    endIndent: 10.h,
                                  ),
                                  Flexible(
                                    flex: 5,
                                    child: SizedBox(
                                      width: double.infinity,
                                      //color: Colors.green,
                                      child: AppText(
                                        text: "Sous-total HT", //01 Avr 2025
                                        weight: FontWeight.w500,
                                        size: 14.sp,
                                        alignment: TextAlign.start,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Container(
                              width: double.infinity,
                              height: 65.h,
                              decoration: BoxDecoration(
                                color: Colors.white,
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
                                    child: GestureDetector(
                                      onTap: () {
                                        showModalBottomSheet(
                                          context: context,
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.vertical(
                                              top: Radius.circular(32.r),
                                            ),
                                          ),
                                          backgroundColor: Colors.white,
                                          builder: (context) {
                                            return OptionsPickerBottomSheet(
                                              additionalHeight: 50.h,
                                              title: "Choisir la TVA",
                                              options: List.generate(
                                                101,
                                                (index) => "$index",
                                              ),
                                              currentSelection: "0%",
                                              onOptionSelected: (String value) {
                                                addInvoiceViewModel.setTvaValue(
                                                    int.parse(value));
                                              },
                                            );
                                          },
                                        );
                                      },
                                      child: SizedBox(
                                        width: double.infinity / 3,
                                        child: AppText(
                                          text:
                                              "${addInvoiceViewModel.tvaValue}%", // TVA VALUE
                                          weight: FontWeight.w500,
                                          size: 14.sp,
                                          alignment: TextAlign.start,
                                        ),
                                      ),
                                    ),
                                  ),
                                  VerticalDivider(
                                    color:
                                        const Color.fromARGB(36, 125, 132, 141),
                                    thickness: 1.h,
                                    indent: 10.h,
                                    endIndent: 10.h,
                                  ),
                                  Flexible(
                                    flex: 5,
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      //mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Container(
                                          //width: double.infinity,
                                          //color: Colors.green,
                                          child: AppText(
                                            text: addInvoiceViewModel.totalHT ==
                                                    0
                                                ? "--"
                                                : (addInvoiceViewModel.totalHT)
                                                    .toDotSeparated(), //500.000
                                            weight: FontWeight.w500,
                                            size: 14.sp,
                                            alignment: TextAlign.start,
                                          ),
                                        ),
                                        GestureDetector(
                                          onTap: () {
                                            showModalBottomSheet(
                                              context: context,
                                              builder: (context) =>
                                                  OptionsPickerBottomSheet(
                                                title: "Choisir une devise",
                                                options: currencies,
                                                currentSelection:
                                                    selectedCurrency,
                                                onOptionSelected:
                                                    (String currency) {
                                                  setState(() {
                                                    selectedCurrency = currency;
                                                  });
                                                },
                                              ),
                                            );
                                          },
                                          child: SizedBox(
                                            child: Row(
                                              mainAxisSize: MainAxisSize.min,
                                              children: [
                                                AppText(
                                                  text: selectedCurrency, //FCFA
                                                  weight: FontWeight.w500,
                                                  size: 14.sp,
                                                  alignment: TextAlign.start,
                                                  color: AppColor.subText,
                                                ),
                                                Icon(
                                                  Icons
                                                      .keyboard_arrow_down_rounded,
                                                  color: AppColor.subText,
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        //TOTAL TTC
                        Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          spacing: 5.h,
                          children: [
                            Padding(
                              padding: EdgeInsets.symmetric(
                                horizontal: 14.w,
                              ),
                              child: AppText(
                                text: "Total TTC",
                                weight: FontWeight.w500,
                                size: 14.sp,
                                alignment: TextAlign.start,
                              ),
                            ),
                            Container(
                              width: double.infinity,
                              height: 65.h,
                              decoration: BoxDecoration(
                                color: const Color.fromARGB(255, 214, 214, 214),
                                borderRadius: BorderRadius.circular(16.r),
                              ),
                              padding: EdgeInsets.symmetric(
                                horizontal: 14.w,
                                vertical: 10.h,
                              ),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                //mainAxisSize: MainAxisSize.min,
                                children: [
                                  AppText(
                                    text: "TOTAL", //01 Avr 2025
                                    weight: FontWeight.w700,
                                    size: 14.sp,
                                    alignment: TextAlign.start,
                                  ),
                                  Flexible(
                                    flex: 8,
                                    child: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      spacing: 5.w,
                                      children: [
                                        Flexible(
                                          child: AppText(
                                            text: addInvoiceViewModel
                                                        .totalTTC ==
                                                    0
                                                ? "--"
                                                : (addInvoiceViewModel.totalTTC)
                                                    .toDotSeparated(), //TOTAL TTC
                                            weight: FontWeight.w700,
                                            size: 16.sp,
                                            alignment: TextAlign.start,
                                          ),
                                        ),
                                        Flexible(
                                          child: GestureDetector(
                                            onTap: () {
                                              showModalBottomSheet(
                                                context: context,
                                                builder: (context) =>
                                                    OptionsPickerBottomSheet(
                                                  title: "Choisir une devise",
                                                  options: currencies,
                                                  currentSelection:
                                                      selectedCurrency,
                                                  onOptionSelected:
                                                      (String currency) {
                                                    setState(() {
                                                      selectedCurrency =
                                                          currency;
                                                    });
                                                  },
                                                ),
                                              );
                                            },
                                            child: SizedBox(
                                              child: Row(
                                                mainAxisSize: MainAxisSize.min,
                                                children: [
                                                  AppText(
                                                    text:
                                                        selectedCurrency, //01 Avr 2025
                                                    weight: FontWeight.w500,
                                                    size: 14.sp,
                                                    alignment: TextAlign.start,
                                                    color: AppColor.subText,
                                                  ),
                                                  Icon(
                                                    Icons
                                                        .keyboard_arrow_down_rounded,
                                                    color: AppColor.subText,
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        // AppTextfield(
                        //   controller: clientPhoneController,
                        //   label: "Numéro de téléphone du client",
                        //   hint: "ex: +225 0000-0000-00",
                        // ),
                      ],
                    ),
                  ),
                  SizedBox(height: 8.h),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
