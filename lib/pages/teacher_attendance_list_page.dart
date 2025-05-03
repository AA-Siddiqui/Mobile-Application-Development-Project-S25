import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:project/controllers/teacher_attendance_list_controller.dart';
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
          "Attendance List",
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
              child: ListView.builder(
                itemCount: stateController.schedules.length,
                itemBuilder: (context, index) {
                  final schedule = stateController.schedules[index];
                  return GestureDetector(
                    onTap: () {
                      /// TODO: WORK HERE
                      /// Block if not in the same date
                      // Get.to(() => TeacherAttendancePage(data));

                      // for (var f in stateController.schedules) {
                      //   for (var e in f["attendance"]) {
                      //     print(e["studentId"]);
                      //     print(e["studentName"]);
                      //     print(e["rollNo"]);
                      //     print(e["present"]);
                      //   }
                      // }
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
                      // ListTile(
                      //   title: Text(schedule["date"]),
                      //   subtitle: Text(
                      //       "${schedule["startTime"]} - ${schedule["endTime"]}"),
                      //   trailing: Icon(Icons.arrow_right),
                      //   onTap: () {
                      //     // Handle attendance marking
                      //   },
                      // ),
                    ),
                  );
                },
              ),
            )),
      ),
    );
  }
}
