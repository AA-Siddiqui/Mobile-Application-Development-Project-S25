import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:project/controllers/teacher_home_controller.dart';
import 'package:project/pages/teacher_course_page.dart';
import 'package:skeletonizer/skeletonizer.dart';

class TeacherHomePage extends StatelessWidget {
  final teacherHomeController = Get.put(TeacherHomeController());

  TeacherHomePage({super.key});

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
            onPressed: () => Get.off(TeacherHomePage()),
            icon: Icon(Icons.refresh),
          ),
        ],
      ),
      body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Obx(
            () => Skeletonizer(
              enabled: teacherHomeController.isLoading,
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
                            text: teacherHomeController.name,
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
                        mainAxisSize: MainAxisSize.max,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Obx(() => Text(
                                    teacherHomeController.position,
                                    style:
                                        Get.theme.textTheme.bodyLarge?.copyWith(
                                      color: Get
                                          .theme.colorScheme.onPrimaryContainer,
                                    ),
                                  )),
                              Obx(() => Text(
                                    "Department of ${teacherHomeController.department}",
                                    style: Get.theme.textTheme.bodyMedium
                                        ?.copyWith(
                                      color: Get
                                          .theme.colorScheme.onPrimaryContainer,
                                    ),
                                  )),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 160,
                    child: Obx(() => Skeletonizer(
                          enabled: teacherHomeController.isLoading,
                          child: Obx(
                            () => teacherHomeController.classes.isNotEmpty
                                ? ListView.builder(
                                    scrollDirection: Axis.horizontal,
                                    itemCount:
                                        teacherHomeController.classes.length,
                                    itemBuilder: (context, index) {
                                      return GestureDetector(
                                        onTap: () => Get.to(
                                          () => TeacherCoursePage(
                                            teacherHomeController
                                                .classes[index],
                                          ),
                                          arguments: "lol",
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
                                                      teacherHomeController
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
                                                      teacherHomeController
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
                                                      teacherHomeController
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
