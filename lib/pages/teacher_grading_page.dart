import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:project/controllers/teacher_grading_controller.dart';
import 'package:project/utils/toast.dart';
import 'package:project/widgets/debounced_text_field.dart';
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
        leading: BackButton(
          onPressed: () {
            if (stateController.requestCount == stateController.requestDone) {
              Get.back();
              return;
            }
            Get.dialog(AlertDialog(
              title: const Text("Unsaved Changes"),
              content: const Text(
                "You have unsaved changes. Please wait!",
              ),
              actions: [
                Obx(
                  () => stateController.requestCount !=
                          stateController.requestDone
                      ? CircularProgressIndicator(
                          value: stateController.requestCount == 1
                              ? null
                              : stateController.requestDone /
                                  stateController.requestCount,
                        )
                      : TextButton(
                          onPressed: () {},
                          child: () {
                            Future.delayed(Duration.zero, () {
                              Get.back();
                              Get.back();
                            });
                            return Text("OK");
                          }(),
                        ),
                ),
              ],
            ));
          },
        ),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        title: Text(
          "${data["title"]}",
          style: Get.textTheme.headlineSmall!.copyWith(
            color: Get.theme.colorScheme.primary,
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 12),
            child: Obx(
              () => stateController.requestCount == stateController.requestDone
                  ? Icon(Icons.check)
                  : CircularProgressIndicator(
                      value: stateController.requestCount == 1
                          ? null
                          : stateController.requestDone /
                              stateController.requestCount,
                    ),
            ),
          ),
        ],
      ),
      body: Obx(() {
        return Padding(
          padding: const EdgeInsets.all(12),
          child: Column(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              ItemContainer(
                child: Row(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Total Marks",
                      style: Get.textTheme.titleLarge!.copyWith(
                        color: Get.theme.colorScheme.primary,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      "${data["max"]}",
                      style: Get.textTheme.titleLarge!.copyWith(
                        color: Get.theme.colorScheme.primary,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: Skeletonizer(
                  enabled: stateController.isLoading,
                  child: ListView.builder(
                      itemCount: stateController.isLoading
                          ? 4
                          : stateController.gradeList.length,
                      itemBuilder: (context, index) => stateController.isLoading
                          ? itemBuilder(index)
                          : itemBuilder(
                              index,
                              stateController.gradeList[index]["studentId"],
                              stateController.gradeList[index]["name"],
                              stateController.gradeList[index]["rollNo"],
                              stateController.gradeList[index]["marks"],
                              stateController.gradeList[index]
                                  ["submissionMade"],
                            )),
                ),
              ),
            ],
          ),
        );
      }),
    );
  }

  Widget itemBuilder(
    int index, [
    int studentId = -1,
    String name = "Lorem Ipsum Dolor",
    String rollNo = "Lorem Ipsum Dolor",
    int marks = 0,
    bool submissionMade = false,
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
              child: DebouncedTextField(
                initialValue: marks == 0 ? "" : marks.toString(),
                action: (newMarks) async {
                  if (newMarks > data["max"]) {
                    Toast.error(
                      "Invalid",
                      "Assigned marks can't be greater than the maximum",
                    );
                    return;
                  }
                  stateController.requestCount++;
                  stateController.gradeList[index]["submissionId"] =
                      await stateController.updateMarks(
                    newMarks,
                    data["id"],
                    studentId,
                    stateController.gradeList[index]["submissionId"],
                  );
                  stateController.requestDone++;

                  if (stateController.requestCount ==
                      stateController.requestDone) {
                    stateController.requestCount = 0;
                    stateController.requestDone = 0;
                  }
                },
              ),
            ),
          ],
        ),
      );
}
