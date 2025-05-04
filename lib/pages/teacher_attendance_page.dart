import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:project/service/supabase_service.dart';
import 'package:project/widgets/item_container.dart';

class TeacherAttendancePage extends StatefulWidget {
  final Map<String, dynamic> data;
  const TeacherAttendancePage(this.data, {super.key});

  @override
  State<TeacherAttendancePage> createState() => _TeacherAttendancePageState();
}

class _TeacherAttendancePageState extends State<TeacherAttendancePage> {
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
      body: widget.data["attendance"] != null
          ? Padding(
              padding: const EdgeInsets.all(12),
              child: ListView.builder(
                itemCount: widget.data["attendance"].length,
                itemBuilder: (context, index) {
                  final attendance = widget.data["attendance"][index];
                  return GestureDetector(
                    onTap: () {
                      setState(() {
                        attendance["present"] = !attendance["present"];
                        SupabaseService.course.markAttendance(
                          attendance["id"],
                          widget.data["id"],
                          attendance["studentId"],
                          attendance["present"],
                        );
                      });
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
                                attendance["studentName"],
                                style: Get.textTheme.titleLarge!.copyWith(
                                  color: Get.theme.colorScheme.primary,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Text(
                                attendance["rollNo"],
                                style: Get.textTheme.bodyMedium!.copyWith(
                                  color: Get.theme.colorScheme.secondary,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                          () {
                            //isNotToday
                            final date = widget.data["date"];
                            final split = date.split(", ");
                            final year = split[1].trim();
                            final month = {
                              "Jan": 1,
                              "Feb": 2,
                              "Mar": 3,
                              "Apr": 4,
                              "May": 5,
                              "Jun": 6,
                              "Jul": 7,
                              "Aug": 8,
                              "Sep": 9,
                              "Oct": 10,
                              "Nov": 11,
                              "Dec": 12,
                            }[split[0].split(" ")[0].trim()];
                            final day = split[0].split(" ")[1].trim();

                            final today = DateTime.now();
                            final isToday = today.year.toString() == year &&
                                today.month.toString() ==
                                    (month ?? 0).toString() &&
                                today.day.toString() == day;
                            return !isToday;
                          }()
                              ? Icon(
                                  attendance["present"]
                                      ? Icons.check
                                      : Icons.close,
                                  color: attendance["present"]
                                      ? Colors.green
                                      : Colors.red,
                                )
                              : Checkbox(
                                  value: attendance["present"],
                                  onChanged: (bool? value) {}),
                        ],
                      ),
                    ),
                  );
                  // ListTile(
                  //   title: Text(attendance["studentName"]),
                  //   subtitle: Text("Roll No: ${attendance["rollNo"]}"),
                  //   trailing: Icon(
                  //     attendance["present"] ? Icons.check : Icons.close,
                  //     color: attendance["present"] ? Colors.green : Colors.red,
                  //   ),
                  // );
                },
              ),
            )
          : Center(
              child: Text(
                "No attendance data available",
                style: Get.textTheme.bodyLarge!.copyWith(
                  color: Get.theme.colorScheme.secondary,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
    );
  }
}
