import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:invoice_app/core/constants/app_colors.dart';
import 'package:invoice_app/presentation/components/app_text.dart';
import 'package:invoice_app/presentation/screens/add_client_screen.dart';
import 'package:invoice_app/presentation/viewmodels/add_client_viewmodel.dart';

class ClientTabScreen extends StatefulWidget {
  const ClientTabScreen({super.key});

  @override
  State<ClientTabScreen> createState() => _ClientTabScreenState();
}

class _ClientTabScreenState extends State<ClientTabScreen> {
  autoRefresher() async {
    await Future.delayed(const Duration(milliseconds: 300));
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    //autoRefresher();
    return Scaffold(
      backgroundColor: AppColor.bgColor,
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => AddClientScreen(),
            ),
          );
        },
        tooltip: 'Ajouter',
        backgroundColor: AppColor.textColor,
        foregroundColor: Colors.white,
        child: Icon(Icons.add),
      ),
      body: RefreshIndicator(
        color: AppColor.btnColor,
        onRefresh: () async {
          setState(() {});
        },
        child: StreamBuilder(
          stream: AddClientViewModel().getClientsByUserId(),
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
                  log("${snapshot.data![index]}");

                  return Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Slidable(
                        endActionPane: ActionPane(
                          motion: const DrawerMotion(), // Smooth sliding effect
                          children: [
                            SlidableAction(
                              onPressed: (context) => (),
                              backgroundColor: AppColor.btnColor,
                              foregroundColor: Colors.white,
                              icon: Icons.edit,
                              label: 'Edit',
                            ),
                            SlidableAction(
                              onPressed: (context) => (),
                              backgroundColor: Colors.red,
                              foregroundColor: Colors.white,
                              icon: Icons.delete,
                              label: 'Delete',
                            ),
                          ],
                        ),
                        child: ListTile(
                          title: AppText(
                            text: snapshot.data![index]['clientName'] ?? "",
                            size: 16.sp,
                          ),
                          subtitle: AppText(
                            text: snapshot.data![index]['clientAddress'] ?? "",
                            size: 14.sp,
                            color: AppColor.subText,
                          ),
                          trailing: AppText(
                            text: snapshot.data![index]['clientPhone'] ?? "",
                            size: 14.sp,
                            color: AppColor.subText,
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
                  text: "Liste des clients",
                  size: 18.sp,
                  weight: FontWeight.w400,
                ),
              );
            }
          },
        ),
      ),
    );
  }
}
