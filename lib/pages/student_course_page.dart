import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:project/controllers/student_course_controller.dart';
import 'package:project/widgets/student_course_activity_widget.dart';
import 'package:project/widgets/student_course_attendance_widget.dart';
import 'package:project/widgets/student_course_results_widget.dart';

class StudentCoursePage extends StatelessWidget {
  final Map<String, dynamic> data;
  StudentCoursePage(this.data, {super.key});

  final stateController = Get.put(StudentCourseController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Colors.transparent,
        title: Obx(
          () => Text(
            [
              "Summary",
              "Activities",
              "Attendance",
              "Results",
            ][stateController.pageIndex],
            style: Get.textTheme.headlineSmall!.copyWith(
              color: Get.theme.colorScheme.primary,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
      bottomNavigationBar: Obx(
        () => BottomNavigationBar(
          currentIndex: stateController.pageIndex,
          items: [
            BottomNavigationBarItem(
              icon: GestureDetector(
                onTap: () => stateController.changePage(0),
                child: Icon(Icons.home),
              ),
              label: "Summary",
            ),
            BottomNavigationBarItem(
              icon: GestureDetector(
                onTap: () => stateController.changePage(1),
                child: Icon(Icons.article),
              ),
              label: "Activity",
            ),
            BottomNavigationBarItem(
              icon: GestureDetector(
                onTap: () => stateController.changePage(2),
                child: Icon(Icons.person),
              ),
              label: "Attendance",
            ),
            BottomNavigationBarItem(
              icon: GestureDetector(
                onTap: () => stateController.changePage(3),
                child: Icon(Icons.grading),
              ),
              label: "Results",
            ),
          ],
        ),
      ),
      body: PageView(
        controller: stateController.pageController,
        children: [
          Column(
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
            ],
          ),
          StudentCourseActivityWidget(data),
          StudentCourseAttendanceWidget(data),
          StudentCourseResultWidget(data),
        ],
      ),
    );
  }
}
