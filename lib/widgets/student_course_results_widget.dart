import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:project/controllers/auth_controller.dart';
import 'package:project/controllers/student_course_result_controller.dart';
import 'package:skeletonizer/skeletonizer.dart';

class StudentCourseResultWidget extends StatelessWidget {
  final Map<String, dynamic> data;
  final stateController = Get.put(StudentCourseResultController());
  final authController = Get.find<AuthController>();
  StudentCourseResultWidget(this.data, {super.key}) {
    stateController.getCourseResults(
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
                  itemCount: stateController.courseResults.length,
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
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            stateController.courseResults[index]["title"],
                            style: Get.textTheme.bodyLarge!.copyWith(
                              color: Get.theme.colorScheme.primary,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Row(
                            spacing: 4,
                            children: [
                              Column(
                                children: [
                                  Text(
                                    (stateController.courseResults[index]
                                            ["marks"] as int)
                                        .toStringAsFixed(1),
                                    style: Get.textTheme.bodyMedium!.copyWith(
                                      color: Get.theme.colorScheme.primary,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  Container(
                                    color: Get.theme.colorScheme.primary,
                                    width: 10,
                                    height: 2,
                                  ),
                                  Text(
                                    (stateController.courseResults[index]["max"]
                                            as int)
                                        .toStringAsFixed(1),
                                    style: Get.textTheme.bodySmall!.copyWith(
                                      color: Get.theme.colorScheme.primary,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                              Text(
                                "weighted",
                                style: Get.textTheme.bodyLarge!.copyWith(
                                  color: Get.theme.colorScheme.primary,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Column(
                                children: [
                                  Text(
                                    (stateController.courseResults[index]
                                                ["marks"] /
                                            stateController.courseResults[index]
                                                ["max"] *
                                            stateController.courseResults[index]
                                                ["weight"] as double)
                                        .toStringAsFixed(1),
                                    style: Get.textTheme.bodyMedium!.copyWith(
                                      color: Get.theme.colorScheme.primary,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  Container(
                                    color: Get.theme.colorScheme.primary,
                                    width: 10,
                                    height: 2,
                                  ),
                                  Text(
                                    (stateController.courseResults[index]
                                            ["weight"] as int)
                                        .toStringAsFixed(1),
                                    style: Get.textTheme.bodySmall!.copyWith(
                                      color: Get.theme.colorScheme.primary,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                            ],
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
