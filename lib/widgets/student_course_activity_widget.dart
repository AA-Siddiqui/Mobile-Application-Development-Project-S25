import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:project/controllers/student_course_activity_controller.dart';
import 'package:project/pages/student_course_activity_page.dart';
import 'package:skeletonizer/skeletonizer.dart';

class StudentCourseActivityWidget extends StatelessWidget {
  final Map<String, dynamic> data;
  final stateController = Get.put(StudentCourseActivityController());
  StudentCourseActivityWidget(this.data, {super.key}) {
    stateController.getCourseActivities(data["id"]);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: Obx(
            () => Skeletonizer(
              enabled: stateController.isLoading,
              child: ListView.builder(
                itemCount: stateController.courseActivities.length,
                itemBuilder: (context, index) {
                  return GestureDetector(
                    onTap: () => [
                      "Assignment",
                      "Project",
                    ].contains(stateController.courseActivities[index]["type"])
                        ? Get.to(
                            () => StudentCourseActivityPage(
                              stateController.courseActivities[index],
                            ),
                          )
                        : null,
                    child: Container(
                      margin: EdgeInsets.symmetric(
                        vertical: 4,
                        horizontal: 8,
                      ),
                      padding: EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Get.theme.colorScheme.primaryContainer,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.max,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                stateController.courseActivities[index]
                                    ["title"],
                                style: Get.textTheme.titleMedium!.copyWith(
                                  color: Get.theme.colorScheme.primary,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Text(
                                stateController.courseActivities[index]["type"],
                                style: Get.textTheme.titleSmall,
                              ),
                            ],
                          ),
                          Column(
                            children: [
                              Text(
                                () {
                                  final datetime = DateTime.parse(
                                      stateController.courseActivities[index]
                                          ["deadline"]);
                                  final hour = datetime.hour % 12;
                                  final min = datetime.minute
                                      .toString()
                                      .padLeft(2, "0");
                                  final apm = datetime.hour < 12 ? "AM" : "PM";
                                  return "$hour:$min $apm";
                                }(),
                                style: Get.textTheme.bodyMedium!.copyWith(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Text(
                                () {
                                  final datetime = DateTime.parse(
                                      stateController.courseActivities[index]
                                          ["deadline"]);
                                  final month = [
                                    "",
                                    "Jan",
                                    "Feb",
                                    "Mar",
                                    "Apr",
                                    "May",
                                    "Jun",
                                    "Jul",
                                    "Aug",
                                    "Sep",
                                    "Oct",
                                    "Nov",
                                    "Dec",
                                  ][datetime.month];
                                  final date = datetime.day;
                                  final year = datetime.year;
                                  return "$month $date, $year";
                                }(),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
        ),
      ],
    );
  }
}
