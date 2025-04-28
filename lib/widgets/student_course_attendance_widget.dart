import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:project/controllers/auth_controller.dart';
import 'package:project/controllers/student_course_attendance_controller.dart';
import 'package:skeletonizer/skeletonizer.dart';

class StudentCourseAttendanceWidget extends StatelessWidget {
  final Map<String, dynamic> data;
  final stateController = Get.put(StudentCourseAttendanceController());
  final authController = Get.find<AuthController>();
  StudentCourseAttendanceWidget(this.data, {super.key}) {
    stateController.getCourseAttendances(
      data["id"],
      authController.roleId,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Padding(
        //   padding: const EdgeInsets.all(16),
        //   child: Text(
        //     "Attendance",
        //     style: Get.textTheme.headlineLarge!.copyWith(
        //       color: Get.theme.colorScheme.primary,
        //       fontWeight: FontWeight.bold,
        //     ),
        //   ),
        // ),
        Expanded(
          child: Obx(() => Skeletonizer(
                enabled: stateController.isLoading,
                child: ListView.builder(
                  itemCount: stateController.courseAttendances.length,
                  itemBuilder: (context, index) {
                    return Container(
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
                          Text(
                            () {
                              final datetime = DateTime.parse(stateController
                                  .courseAttendances[index]["startTime"]);
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
                            style: Get.textTheme.bodyLarge!.copyWith(
                              fontWeight: FontWeight.bold,
                              color: Get.theme.colorScheme.primary,
                            ),
                          ),
                          Checkbox(
                            onChanged: (value) {},
                            value: stateController.courseAttendances[index]
                                ["present"],
                          ),
                        ],
                      ),
                    );
                  },
                ),
              )),
        ),
      ],
    );
  }
}
