import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:project/pages/teacher_activity_list_page.dart';
import 'package:project/pages/teacher_attendance_list_page.dart';
import 'package:project/widgets/item_container.dart';

class TeacherCoursePage extends StatelessWidget {
  final Map<String, dynamic> data;
  const TeacherCoursePage(this.data, {super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Colors.transparent,
        title: Text(
          (data["courseName"] as String)
              .split('')
              .where((c) => c.contains(RegExp(r'[A-Z9\(\)]')))
              .join(),
          style: Get.textTheme.headlineSmall!.copyWith(
            color: Get.theme.colorScheme.primary,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          mainAxisSize: MainAxisSize.max,
          children: <Map<String, dynamic>>[
            {
              "text": "Mark Attendance",
              "action": () => Get.to(() => TeacherAttendanceListPage(data)),
            },
            {
              "text": "Manage Assessment",
              "action": () => Get.to(() => TeacherActivityListPage(data)),
            },
            {
              "text": "Grade",
              "action": () {},
            },
          ]
              .map(
                (content) => Expanded(
                  child: GestureDetector(
                    onTap: content["action"],
                    child: ItemContainer(
                      child: Center(
                        child: Text(
                          content["text"],
                          style: Get.textTheme.bodyLarge!.copyWith(
                            fontWeight: FontWeight.bold,
                            color: Get.theme.colorScheme.onPrimaryContainer,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              )
              .toList(),
        ),
        // Column(
        //   mainAxisSize: MainAxisSize.max,
        //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
        //   children: <Map<String, dynamic>>[
        //     {
        //       "text": "Mark Attendance",
        //       "action": () {},
        //     },
        //     {
        //       "text": "Upload Assessment",
        //       "action": () {},
        //     },
        //     {
        //       "text": "Grade",
        //       "action": () {},
        //     },
        //   ]
        //       .map(
        //         (content) => GestureDetector(
        //           onTap: content["action"],
        //           child: ItemContainer(
        //             child: Center(
        //               child: Text(
        //                 content["text"],
        //                 style: Get.textTheme.bodyLarge!.copyWith(
        //                   fontWeight: FontWeight.bold,
        //                   color: Get.theme.colorScheme.onPrimaryContainer,
        //                 ),
        //               ),
        //             ),
        //           ),
        //         ),
        //       )
        //       .toList(),
        // ),
      ),
    );
  }
}
