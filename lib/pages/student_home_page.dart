import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:project/controllers/auth_controller.dart';
import 'package:project/pages/profile_page.dart';

class StudentHomePage extends StatelessWidget {
  final AuthController authController = Get.find<AuthController>();
  StudentHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
            onPressed: () => Get.changeThemeMode(
                Get.theme.brightness == Brightness.light
                    ? ThemeMode.dark
                    : ThemeMode.light),
            icon: Icon(Icons.brightness_5_sharp),
          ),
          IconButton(
            onPressed: () => Get.off(StudentHomePage()),
            icon: Icon(Icons.refresh),
          ),
        ],
      ),
      drawer: Drawer(
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
                    title: Text("Profile"),
                    leading: Icon(Icons.person),
                    onTap: () => Get.to(() => ProfilePage()),
                  ),
                ],
              ),
            ),
            SafeArea(child: ListTile(title: Text("Made by someone"))),
          ],
        ),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
              padding: EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Get.theme.colorScheme.tertiaryContainer,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                mainAxisSize: MainAxisSize.max,
                children: [
                  Column(
                    children: List.generate(
                      3,
                      (index) => Text("Item $index"),
                    ),
                  ),
                  Column(
                    children: List.generate(
                      3,
                      (index) => Text("Item $index"),
                    ),
                  ),
                ],
              ),
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: 20,
              itemBuilder: (context, index) => ListTile(
                title: Text("Item $index"),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
