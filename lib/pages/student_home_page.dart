import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:project/controllers/auth_controller.dart';
import 'package:project/controllers/profile_controller.dart';
import 'package:project/controllers/student_home_controller.dart';
import 'package:project/pages/student_course_page.dart';
import 'package:project/widgets/my_drawer.dart';
import 'package:skeletonizer/skeletonizer.dart';

class StudentHomePage extends StatelessWidget {
  final AuthController authController = Get.find<AuthController>();
  final ProfileController profileController =
      Get.put<ProfileController>(ProfileController());
  final StudentHomeController studentHomeController =
      Get.put<StudentHomeController>(StudentHomeController());
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
      drawer: MyDrawer(),
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
              child: Obx(() => Skeletonizer(
                    enabled: studentHomeController.isLoading,
                    child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: studentHomeController.classes.length,
                        itemBuilder: (context, index) {
                          return GestureDetector(
                            onTap: () => Get.to(
                              () => StudentCoursePage(
                                studentHomeController.classes[index],
                              ),
                            ),
                            child: Card(
                              child: Container(
                                width: 200,
                                padding: EdgeInsets.all(8),
                                color: Get.theme.colorScheme.primaryContainer,
                                child: Column(
                                  mainAxisSize: MainAxisSize.max,
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          studentHomeController.classes[index]
                                              ["courseName"],
                                          style: TextStyle(
                                            fontSize: 18,
                                            fontWeight: FontWeight.bold,
                                            color: Get.theme.colorScheme
                                                .onPrimaryContainer,
                                          ),
                                        ),
                                        Text(
                                          studentHomeController.classes[index]
                                              ["section"],
                                          style: TextStyle(
                                            color: Get.theme.colorScheme
                                                .onPrimaryContainer,
                                          ),
                                        ),
                                        Text(
                                          studentHomeController.classes[index]
                                              ["term"],
                                          style: TextStyle(
                                            color: Get.theme.colorScheme
                                                .onPrimaryContainer,
                                          ),
                                        )
                                      ],
                                    ),
                                    Text(
                                      "Taught by Mr. ${studentHomeController.classes[index]["teacherName"]}",
                                      style: TextStyle(
                                        color: Get.theme.colorScheme
                                            .onPrimaryContainer,
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            ),
                          );
                        }),
                  )),
            ),
          ],
        ),
      ),
    );
  }
}
