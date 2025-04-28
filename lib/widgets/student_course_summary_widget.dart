import 'package:flutter/material.dart';
import 'package:get/get.dart';

class StudentCourseSummaryWidget extends StatelessWidget {
  final Map<String, dynamic> data;
  const StudentCourseSummaryWidget(this.data, {super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          margin: EdgeInsets.symmetric(vertical: 8),
          padding: EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Get.theme.colorScheme.primaryContainer,
            borderRadius: BorderRadius.circular(8),
          ),
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

        /// TODO: Atendance
        /// Show total attendance and total classes
        /// Done by getting the unique schedule count then the total attendance count

        /// TODO: Results
        /// Show total marks and total weightage
      ],
    );
  }
}
