import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:project/controllers/teacher_grading_controller.dart';
import 'package:project/widgets/item_container.dart';
import 'package:skeletonizer/skeletonizer.dart';

class TeacherGradingPage extends StatelessWidget {
  final int classId;
  final Map<String, dynamic> data;
  TeacherGradingPage(this.classId, this.data, {super.key});

  late final stateController = Get.put(TeacherGradingController(
    classId,
    data["id"],
  ));

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Colors.transparent,
        title: Text(
          "${data["title"]}",
          style: Get.textTheme.headlineSmall!.copyWith(
            color: Get.theme.colorScheme.primary,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: Obx(() {
        return Padding(
          padding: const EdgeInsets.all(12),
          child: Skeletonizer(
            enabled: stateController.isLoading,
            child: ListView.builder(
                itemCount: stateController.isLoading
                    ? 4
                    : stateController.gradeList.length,
                itemBuilder: (context, index) => stateController.isLoading
                    ? itemBuilder()
                    : itemBuilder(
                        stateController.gradeList[index]["studentId"],
                        stateController.gradeList[index]["name"],
                        stateController.gradeList[index]["rollNo"],
                        stateController.gradeList[index]["marks"],
                      )),
          ),
        );
      }),
    );
  }

  Widget itemBuilder([
    int id = -1,
    String name = "Lorem Ipsum Dolor",
    String rollNo = "Lorem Ipsum Dolor",
    int marks = 0,
  ]) =>
      ItemContainer(
        child: Row(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: Get.textTheme.titleLarge!.copyWith(
                    color: Get.theme.colorScheme.primary,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  rollNo,
                  style: Get.textTheme.bodyMedium!.copyWith(),
                ),
              ],
            ),
            SizedBox(
              width: Get.width * 0.2,
              child: TextField(
                controller: TextEditingController(
                  text: marks == 0 ? "" : marks.toString(),
                ),
                onChanged: (value) {
                  /// TODO: Implement code to update the marks in the database
                  /// This should be staggered 5 seconds after the user stops typing
                  /// or when the user presses enter.
                  /// or when the textfield loses focus.
                  /// and should be done using a debounce function.
                },
              ),
            ),
          ],
        ),
      );
}
