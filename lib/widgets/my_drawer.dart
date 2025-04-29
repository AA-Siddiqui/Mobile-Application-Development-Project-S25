import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:project/controllers/auth_controller.dart';
import 'package:project/pages/profile_page.dart';
import 'package:project/pages/student_home_page.dart';
import 'package:project/pages/student_invoice_page.dart';

class MyDrawer extends StatelessWidget {
  MyDrawer({super.key});

  final authController = Get.find<AuthController>();

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        mainAxisSize: MainAxisSize.max,
        children: [
          Expanded(
            child: ListView(
              children: [
                DrawerHeader(
                  child: Align(
                    alignment: Alignment.center,
                    child: Text(
                      "UMS",
                      style: TextStyle(
                        fontSize: 72,
                        color: Get.theme.colorScheme.primary,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                ListTile(
                  title: Text("Home"),
                  leading: Icon(Icons.home),
                  onTap: () => Get.offAll(StudentHomePage()),
                ),
                ListTile(
                  title: Text("Profile"),
                  leading: Icon(Icons.person),
                  onTap: () => Get.to(() => ProfilePage()),
                ),
                ListTile(
                  title: Text("Results"),
                  leading: Icon(Icons.grading),
                  onTap: () => Get.to(() => Placeholder()),
                ),
                ListTile(
                  title: Text("Invoices"),
                  leading: Icon(Icons.article),
                  onTap: () => Get.to(() => StudentInvoicePage()),
                ),
              ],
            ),
          ),
          SafeArea(
            child: ListTile(
              title: Text("Logout"),
              leading: Icon(Icons.exit_to_app),
              onTap: authController.signOut,
            ),
          ),
        ],
      ),
    );
  }
}
