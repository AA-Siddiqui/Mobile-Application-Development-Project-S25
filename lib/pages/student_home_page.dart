import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:project/controllers/auth_controller.dart';
import 'package:project/controllers/profile_controller.dart';
import 'package:project/pages/profile_page.dart';

class StudentHomePage extends StatelessWidget {
  final AuthController authController = Get.find<AuthController>();
  final ProfileController profileController =
      Get.put<ProfileController>(ProfileController());
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
                  ListTile(
                    title: Text("Logout"),
                    leading: Icon(Icons.exit_to_app),
                    onTap: authController.signOut,
                  ),
                ],
              ),
            ),
            SafeArea(child: ListTile(title: Text("Made by someone"))),
          ],
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Obx(
              () => Padding(
                padding: const EdgeInsets.symmetric(
                  vertical: 16,
                  horizontal: 8,
                ),
                child: Text.rich(
                  TextSpan(text: "Hello, ", children: [
                    TextSpan(
                      text: profileController.name ?? "User",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Get.theme.colorScheme.primary,
                      ),
                    ),
                  ]),
                  // "Hello, ${profileController.name}",
                  style: Get.textTheme.headlineLarge,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: Container(
                padding: EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Get.theme.colorScheme.primaryContainer,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(right: 16),
                      child: CircleAvatar(
                        radius: 32,
                        backgroundColor: Get.theme.colorScheme.primary,
                      ),
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Obx(() => Text(
                              profileController.rollNo ?? "Roll No",
                              style: Get.theme.textTheme.bodyLarge?.copyWith(
                                color: Get.theme.colorScheme.onPrimaryContainer,
                              ),
                            )),
                        Obx(() => Text(
                              "Department of ${profileController.department ?? "Department"}",
                              style: Get.theme.textTheme.bodyMedium?.copyWith(
                                color: Get.theme.colorScheme.onPrimaryContainer,
                              ),
                            )),
                        Obx(() => Text(
                              profileController.program ?? "Program",
                              style: Get.theme.textTheme.bodySmall?.copyWith(
                                color: Get.theme.colorScheme.onPrimaryContainer,
                              ),
                            )),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(
              height: 200,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: 20,
                // itemBuilder: (context, index) => ListTile(
                //   title: Text("Item $index"),
                // ),
                itemBuilder: (context, index) => Card(
                  child: Container(
                    width: 200,
                    height: 200,
                    color: Get.theme.colorScheme.primaryContainer,
                    child: Center(
                      child: Text(
                        "Item $index",
                        style: TextStyle(
                          fontSize: 24,
                          color: Get.theme.colorScheme.onPrimaryContainer,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
