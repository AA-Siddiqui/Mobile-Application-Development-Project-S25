import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:project/controllers/teacher_attendance_list_controller.dart';
import 'package:project/pages/teacher_attendance_page.dart';
import 'package:project/widgets/item_container.dart';
import 'package:skeletonizer/skeletonizer.dart';

class TeacherAttendanceListPage extends StatelessWidget {
  final Map<String, dynamic> data;
  late final stateController =
      Get.put(TeacherAttendanceListController(data["id"]));
  TeacherAttendanceListPage(this.data, {super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Colors.transparent,
        title: Text(
          "Class List",
          style: Get.textTheme.headlineSmall!.copyWith(
            color: Get.theme.colorScheme.primary,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(12),
        child: Obx(() => Skeletonizer(
              enabled: stateController.isLoading,
              child: stateController.schedules.isNotEmpty
                  ? ListView.builder(
                      itemCount: stateController.schedules.length,
                      itemBuilder: (context, index) {
                        final schedule = stateController.schedules[index];
                        return GestureDetector(
                          onTap: () {
                            Get.to(() => TeacherAttendancePage(schedule));
                          },
                          child: ItemContainer(
                            child: Row(
                              mainAxisSize: MainAxisSize.max,
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      schedule["date"],
                                      style: Get.textTheme.titleLarge!.copyWith(
                                        color: Get.theme.colorScheme.primary,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    Text(
                                      "${schedule["startTime"]} - ${schedule["endTime"]}",
                                      style: Get.textTheme.bodyMedium!.copyWith(
                                        color: Get.theme.colorScheme.secondary,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ],
                                ),
                                Icon(Icons.arrow_right)
                              ],
                            ),
                          ),
                        );
                      },
                    )
                  : Center(
                      child: Text(
                        "No Classes Scheduled",
                        style: Get.textTheme.bodyLarge!.copyWith(
                          color: Get.theme.colorScheme.secondary,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
            )),
      ),
    );
  }
}
