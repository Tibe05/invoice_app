import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:invoice_app/presentation/components/app_text.dart';
import 'package:invoice_app/presentation/screens/add_invoice_screen.dart';
import 'package:invoice_app/presentation/screens/tabs/client_tab_screen.dart';
import 'package:invoice_app/presentation/screens/tabs/invoice_tab_screen.dart';
import 'package:invoice_app/presentation/screens/tabs/item_tab_screen.dart';
import '../../core/constants/app_colors.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        backgroundColor: AppColor.bgColor,
        appBar: AppBar(
          forceMaterialTransparency: true,
          centerTitle: true,
          title: AppText(
            text: "Billy".toUpperCase(),
            weight: FontWeight.w700,
            size: 34.sp,
            color: AppColor.btnColor,
            family: "Roboto",
          ),
          leading: IconButton(
            icon: Icon(Icons.menu),
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text("Menu"),
                ),
              );
            },
          ),
          bottom: TabBar(
            indicatorColor: AppColor.textColor,
            labelColor: AppColor.textColor,
            unselectedLabelColor: Colors.grey,
            tabs: [
              Tab(text: "Factures"),
              Tab(text: "Clients"),
              Tab(text: "Produits"),
            ],
          ),
          actions: [
            IconButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => AddInvoiceScreen(),
                  ),
                );
              },
              icon: Icon(Icons.settings),
            ),
          ],
        ),
        body: TabBarView(
          children: [
            // Tab 1: Invoices
            InvoiceTabScreen(),
            // Center(
            //   child: AppText(
            //     text: "Liste des factures",
            //     size: 18.sp,
            //     weight: FontWeight.w400,
            //   ),
            // ),
            //invoiceTab(),
            // Tab 2: Clients
            ClientTabScreen(),
            // Tab 3: Items
            ItemTabScreen(),
            // Center(
            //   child: AppText(
            //     text: "Liste des produits ou services",
            //     size: 18.sp,
            //     weight: FontWeight.w400,
            //   ),
            // ),
          ],
        ),
      ),
    );
  }
}
