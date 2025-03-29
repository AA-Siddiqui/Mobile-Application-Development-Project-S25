import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:project/controllers/auth_controller.dart';
import 'package:project/pages/profile_page.dart';
import 'package:project/utils/toast.dart';

class StudentHomePage extends StatelessWidget {
  final AuthController authController = Get.find<AuthController>();
  StudentHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      drawer: Drawer(
        child: Column(
          mainAxisSize: MainAxisSize.max,
          children: [
            Expanded(
              child: ListView(
                children: [
                  DrawerHeader(child: Container()),
                  ListTile(
                    title: Text("Profile"),
                    onTap: () => Get.to(() => ProfilePage()),
                  )
                ],
              ),
            ),
            ListTile(title: Text("Made by someone")),
          ],
        ),
      ),
      body: PageView(
        children: [
          Column(
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
          Center(
            child: Column(
              children: [
                TextButton(
                  onPressed: () {
                    Toast.info(
                      "Info",
                      "Info message",
                    );
                  },
                  child: Text("SnackBar Info"),
                ),
                TextButton(
                  onPressed: () {
                    Toast.error(
                      "Error",
                      "Error message",
                    );
                  },
                  child: Text("SnackBar Error"),
                ),
                IconButton(
                  icon: const Icon(Icons.logout),
                  onPressed: authController.signOut,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
