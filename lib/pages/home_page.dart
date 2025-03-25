import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:project/controllers/auth_controller.dart';
import 'package:project/pages/profile_page.dart';

class HomePage extends StatelessWidget {
  final AuthController authController = Get.find<AuthController>();
  HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      drawer: Drawer(
        child: ListView(
          children: [
            ListTile(
              title: Text("Profile"),
              onTap: () => Get.to(ProfilePage()),
            )
          ],
        ),
      ),
      body: Center(
        child: IconButton(
          icon: const Icon(Icons.logout),
          onPressed: authController.signOut,
        ),
      ),
    );
  }
}
