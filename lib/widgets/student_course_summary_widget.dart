import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:project/controllers/auth_controller.dart';
import 'package:project/controllers/student_course_controller.dart';
import 'package:project/controllers/student_course_summary_controller.dart';
import 'package:project/widgets/item_container.dart';
import 'package:skeletonizer/skeletonizer.dart';

class StudentCourseSummaryWidget extends StatelessWidget {
  final authController = Get.find<AuthController>();
  final stateController = Get.put(StudentCourseSummaryController());
  final pageController = Get.find<StudentCourseController>();
  final Map<String, dynamic> data;
  StudentCourseSummaryWidget(this.data, {super.key}) {
    stateController.init(data["id"], authController.roleId);
  }

  List<Widget> insertSeparatorsInPlace(List<Widget> widgets, Widget separator) {
    for (int i = widgets.length - 1; i > 0; i--) {
      widgets.insert(i, separator);
    }
    return widgets;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ItemContainer(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                data["courseName"],
                style: Get.textTheme.titleLarge!.copyWith(
                  color: Get.theme.colorScheme.primary,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                data["teacherName"],
                style: Get.textTheme.titleMedium!.copyWith(
                  color: Get.theme.colorScheme.secondary,
                ),
              ),
              Text(
                data["section"],
                style: Get.textTheme.titleSmall,
              ),
              Text(
                data["term"],
                style: Get.textTheme.titleSmall,
              ),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Align(
            alignment: Alignment.centerLeft,
            child: Text(
              "Attendance",
              style: Get.textTheme.headlineMedium!.copyWith(
                color: Get.theme.colorScheme.primary,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
        Obx(
          () => Skeletonizer(
            enabled: stateController.isLoading,
            child: GestureDetector(
              onTap: () {
                pageController.changePage(2);
              },
              child: ItemContainer(
                marginX: 4,
                child: Row(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: insertSeparatorsInPlace(
                    [
                      Column(
                        children: [
                          Text(
                            "${stateController.totalClasses}",
                            style: Get.textTheme.bodyLarge!.copyWith(
                              color: Get.theme.colorScheme.primary,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            "Classes Held",
                            style: Get.textTheme.bodyLarge!.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(
                            stateController.attendedClasses.toString(),
                            style: Get.textTheme.bodyLarge!.copyWith(
                              color: Get.theme.colorScheme.primary,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            "Attended",
                            style: Get.textTheme.bodyLarge!.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(
                            "${(stateController.attendedClasses / stateController.totalClasses * 100).toStringAsFixed(1)}%",
                            style: Get.textTheme.bodyLarge!.copyWith(
                              color: Get.theme.colorScheme.primary,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            "Attended",
                            style: Get.textTheme.bodyLarge!.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ],
                    Container(
                      color: Get.theme.colorScheme.primary,
                      height: 40,
                      width: 1.5,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Align(
            alignment: Alignment.centerLeft,
            child: Text(
              "Results",
              style: Get.textTheme.headlineMedium!.copyWith(
                color: Get.theme.colorScheme.primary,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
        Obx(
          () => Skeletonizer(
            enabled: stateController.isLoading,
            child: GestureDetector(
              onTap: () {
                pageController.changePage(3);
              },
              child: ItemContainer(
                marginX: 4,
                child: Row(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  spacing: 8,
                  children: [
                    Column(
                      children: [
                        Text(
                          stateController.obtainedWeightedMarks
                              .toStringAsFixed(1),
                          style: Get.textTheme.bodyLarge!.copyWith(
                            color: Get.theme.colorScheme.primary,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          "marks",
                          style: Get.textTheme.bodyLarge!.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    Text("out of"),
                    Column(
                      children: [
                        Text(
                          stateController.totalWeightedMarks.toStringAsFixed(1),
                          style: Get.textTheme.bodyLarge!.copyWith(
                            color: Get.theme.colorScheme.primary,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          "marks",
                          style: Get.textTheme.bodyLarge!.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
