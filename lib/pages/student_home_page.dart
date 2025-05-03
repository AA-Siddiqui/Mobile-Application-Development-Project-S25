import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:project/controllers/auth_controller.dart';
import 'package:project/controllers/student_profile_controller.dart';
import 'package:project/controllers/student_home_controller.dart';
import 'package:project/controllers/student_results_controller.dart';
import 'package:project/pages/student_course_page.dart';
import 'package:project/widgets/student_drawer.dart';
import 'package:skeletonizer/skeletonizer.dart';

class StudentHomePage extends StatelessWidget {
  final AuthController authController = Get.find<AuthController>();
  final StudentProfileController profileController =
      Get.put<StudentProfileController>(StudentProfileController());
  final StudentHomeController studentHomeController =
      Get.put<StudentHomeController>(StudentHomeController());
  late final resultsController =
      Get.put(StudentResultsController(authController.roleId));

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
      drawer: StudentDrawer(),
      body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Obx(
            () => Skeletonizer(
              enabled: studentHomeController.isLoading,
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
                      padding:
                          EdgeInsets.symmetric(vertical: 8, horizontal: 12),
                      decoration: BoxDecoration(
                        color: Get.theme.colorScheme.primaryContainer,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        mainAxisSize: MainAxisSize.max,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Obx(() => Text(
                                    profileController.rollNo ?? "Roll No",
                                    style:
                                        Get.theme.textTheme.bodyLarge?.copyWith(
                                      color: Get
                                          .theme.colorScheme.onPrimaryContainer,
                                    ),
                                  )),
                              Obx(() => Text(
                                    "Department of ${profileController.department ?? "Department"}",
                                    style: Get.theme.textTheme.bodyMedium
                                        ?.copyWith(
                                      color: Get
                                          .theme.colorScheme.onPrimaryContainer,
                                    ),
                                  )),
                              Obx(() => Text(
                                    profileController.program ?? "Program",
                                    style:
                                        Get.theme.textTheme.bodySmall?.copyWith(
                                      color: Get
                                          .theme.colorScheme.onPrimaryContainer,
                                    ),
                                  )),
                            ],
                          ),
                          Obx(
                            () => Text(
                              resultsController.cgpa.toStringAsFixed(2),
                              style:
                                  Get.theme.textTheme.headlineLarge!.copyWith(
                                color: Get.theme.colorScheme.onPrimaryContainer,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 200,
                    child: Obx(() => Skeletonizer(
                          enabled: studentHomeController.isLoading,
                          child: Obx(
                            () => studentHomeController.classes.isNotEmpty
                                ? ListView.builder(
                                    scrollDirection: Axis.horizontal,
                                    itemCount:
                                        studentHomeController.classes.length,
                                    itemBuilder: (context, index) {
                                      return GestureDetector(
                                        onTap: () => Get.to(
                                          () => StudentCoursePage(
                                            studentHomeController
                                                .classes[index],
                                          ),
                                        ),
                                        child: Card(
                                          child: Container(
                                            width: 200,
                                            padding: EdgeInsets.all(8),
                                            color: Get.theme.colorScheme
                                                .primaryContainer,
                                            child: Column(
                                              mainAxisSize: MainAxisSize.max,
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Text(
                                                      studentHomeController
                                                              .classes[index]
                                                          ["courseName"],
                                                      style: TextStyle(
                                                        fontSize: 18,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        color: Get
                                                            .theme
                                                            .colorScheme
                                                            .onPrimaryContainer,
                                                      ),
                                                    ),
                                                    Text(
                                                      studentHomeController
                                                              .classes[index]
                                                          ["section"],
                                                      style: TextStyle(
                                                        color: Get
                                                            .theme
                                                            .colorScheme
                                                            .onPrimaryContainer,
                                                      ),
                                                    ),
                                                    Text(
                                                      studentHomeController
                                                              .classes[index]
                                                          ["term"],
                                                      style: TextStyle(
                                                        color: Get
                                                            .theme
                                                            .colorScheme
                                                            .onPrimaryContainer,
                                                      ),
                                                    )
                                                  ],
                                                ),
                                                Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.end,
                                                  children: [
                                                    Text(
                                                      "${(studentHomeController.classes[index]["attendedClasses"] / studentHomeController.classes[index]["totalClasses"] * 100).toStringAsFixed(1)}% Attended",
                                                      style: Get
                                                          .textTheme.bodyLarge!
                                                          .copyWith(
                                                        color: Get
                                                            .theme
                                                            .colorScheme
                                                            .primary,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                      ),
                                                    ),
                                                    Text(
                                                      "Taught by Mr. ${studentHomeController.classes[index]["teacherName"]}",
                                                      style: TextStyle(
                                                        color: Get
                                                            .theme
                                                            .colorScheme
                                                            .onPrimaryContainer,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      );
                                    })
                                : Center(
                                    child: Text(
                                      "You are not enrolled in any classes.",
                                    ),
                                  ),
                          ),
                        )),
                  ),
                ],
              ),
            ),
          )),
    );
  }
}
