import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:project/controllers/teacher_course_activity_controller.dart';
import 'package:project/utils/toast.dart';
import 'package:url_launcher/url_launcher.dart';

class TeacherActivityPage extends StatelessWidget {
  final int classId;
  final Map<String, dynamic>? data;
  late final int? assessmentId;
  TeacherActivityPage(this.classId, this.data, {super.key})
      : assessmentId = data?["id"] {
    if (data != null) {
      stateController.selectedType = data?["type"] ?? "Assignment";
      stateController.deadline = DateTime.parse(data?["deadline"]);
    }
  }

  late final titleController = TextEditingController(text: data?["title"]);
  late final descriptionController =
      TextEditingController(text: data?["description"]);
  late final deadlineController = TextEditingController(
      text: data != null
          ? "${formatDate(data?["deadline"])} - ${formatTime(data?["deadline"])}"
          : null);
  late final maxMarksController =
      TextEditingController(text: data?["max"].toString());
  late final weightageController =
      TextEditingController(text: data?["weight"].toString());
  late final typeController = TextEditingController(text: data?["type"]);

  final stateController = Get.put(TeacherCourseActivityController());

  String formatDate(String date) {
    DateTime parsedDateTime = DateTime.parse(date).toLocal();
    List<String> monthNames = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec'
    ];

    return "${monthNames[parsedDateTime.month - 1]} "
        "${parsedDateTime.day}, "
        "${parsedDateTime.year}";
  }

  String formatTime(String time) {
    DateTime parsedDateTime = DateTime.parse(time).toLocal();
    int hour = parsedDateTime.hour;
    int minute = parsedDateTime.minute;
    String period = hour >= 12 ? 'PM' : 'AM';

    // Convert to 12-hour format
    hour = hour % 12;
    hour = hour == 0 ? 12 : hour;

    return "${hour.toString().padLeft(2, '0')}:"
        "${minute.toString().padLeft(2, '0')} $period";
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Colors.transparent,
        title: Text(
          data == null ? "Add Assessment" : "Edit Assessment",
          style: Get.textTheme.headlineSmall!.copyWith(
            color: Get.theme.colorScheme.primary,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(12),
        child: Form(
          child: Column(
            children: [
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    spacing: 12,
                    children: [
                      TextFormField(
                        controller: titleController,
                        decoration: const InputDecoration(
                          labelText: "Title",
                          hintText: "Enter title",
                        ),
                      ),
                      TextFormField(
                        onTap: () {
                          Get.dialog(
                            AlertDialog(
                              title: Text('Select Type of Assessment'),
                              content: SizedBox(
                                width: double.maxFinite,
                                child: ListView(
                                  shrinkWrap: true,
                                  children: [
                                    "Assignment",
                                    "Quiz",
                                    "Presentation",
                                    "Project",
                                    "Viva",
                                    "Task",
                                  ]
                                      .map((e) => ListTile(
                                            title: Text(e),
                                            onTap: () {
                                              stateController.selectedType = e;
                                              typeController.text = e;
                                              Get.back();
                                            },
                                          ))
                                      .toList(),
                                ),
                              ),
                            ),
                          );
                        },
                        readOnly: true,
                        controller: typeController,
                        decoration: const InputDecoration(
                          labelText: "Type",
                          hintText: "Select type",
                        ),
                      ),
                      TextFormField(
                        controller: descriptionController,
                        decoration: const InputDecoration(
                          labelText: "Description",
                          hintText: "Enter description",
                        ),
                      ),
                      TextFormField(
                        controller: maxMarksController,
                        decoration: const InputDecoration(
                          labelText: "Max Marks",
                          hintText: "Enter max marks",
                        ),
                      ),
                      TextFormField(
                        controller: weightageController,
                        decoration: const InputDecoration(
                          labelText: "Weightage",
                          hintText: "Weightage",
                        ),
                      ),
                      TextFormField(
                        onTap: () async {
                          final datetime = await showDatePicker(
                            context: context,
                            firstDate: DateTime.now(),
                            lastDate: DateTime(2100),
                          ).then((date) {
                            if (date == null) return null;

                            return showTimePicker(
                              // ignore: use_build_context_synchronously
                              context: context,
                              initialTime:
                                  TimeOfDay.fromDateTime(DateTime.now()),
                            ).then((time) {
                              if (time == null) return null;

                              stateController.deadline = DateTime(
                                date.year,
                                date.month,
                                date.day,
                                time.hour,
                                time.minute,
                              );

                              return DateTime(
                                date.year,
                                date.month,
                                date.day,
                                time.hour,
                                time.minute,
                              );
                            });
                          });

                          if (datetime == null) return;

                          String formattedDate =
                              formatDate(datetime.toString());
                          String formattedTime =
                              formatTime(datetime.toString());

                          deadlineController.text =
                              "$formattedDate - $formattedTime";
                        },
                        readOnly: true,
                        controller: deadlineController,
                        decoration: const InputDecoration(
                          labelText: "Deadline",
                          hintText: "Enter deadline",
                        ),
                      ),
                      SizedBox(
                        height: 100,
                        child: Obx(() => ListView.builder(
                            scrollDirection: Axis.horizontal,
                            itemCount: (data?["AssessmentFile"].length ?? 0) +
                                (stateController.files.length) +
                                1,
                            itemBuilder: (context, index) {
                              if (index == 0) {
                                return GestureDetector(
                                  onTap: () async {
                                    final status =
                                        await Permission.storage.request();
                                    final hasPermission = status.isGranted;

                                    if (!hasPermission) {
                                      Toast.error(
                                        "Storage permission denied",
                                        "Go to settings to allow permission to access storage",
                                      );
                                      return;
                                    }

                                    final result =
                                        await FilePicker.platform.pickFiles(
                                      allowMultiple: true,
                                    );

                                    if (result == null) {
                                      return;
                                    }
                                    for (final file in result.files) {
                                      stateController.files.add(file);
                                    }
                                    stateController.files =
                                        stateController.files;
                                  },
                                  child: Container(
                                    margin: EdgeInsets.only(
                                        right: 8, bottom: 8, top: 8),
                                    padding: EdgeInsets.symmetric(
                                        vertical: 7.5, horizontal: 8),
                                    decoration: BoxDecoration(
                                      color: Get
                                          .theme.inputDecorationTheme.fillColor,
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    child: Icon(Icons.add),
                                  ),
                                );
                              }
                              late final Map<String, dynamic> file;
                              if (index < stateController.files.length + 1) {
                                final pf = stateController.files[index - 1];
                                file = {
                                  "name": pf.name,
                                  "url": pf.path,
                                  "local": true,
                                };
                              } else {
                                file = data!["AssessmentFile"]
                                    [index - stateController.files.length - 1];
                              }
                              return Stack(
                                alignment: Alignment.topRight,
                                children: [
                                  Container(
                                    padding: EdgeInsets.symmetric(
                                        vertical: 7.5, horizontal: 8),
                                    margin: EdgeInsets.only(
                                        right: 8, bottom: 8, top: 8),
                                    decoration: BoxDecoration(
                                      color: Get
                                          .theme.inputDecorationTheme.fillColor,
                                      borderRadius: BorderRadius.circular(4),
                                    ),
                                    child: Column(
                                      children: [
                                        Text(
                                          file["name"],
                                          style: Get.textTheme.titleSmall!
                                              .copyWith(
                                            color: Get.theme.colorScheme
                                                .onPrimaryContainer,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        SizedBox(height: 4),
                                        ElevatedButton(
                                          style: ElevatedButton.styleFrom(
                                            backgroundColor: Get.theme
                                                .colorScheme.secondaryContainer,
                                          ),
                                          onPressed: () async {
                                            final Uri url = Uri.parse(
                                              file["url"],
                                            );

                                            if (!await launchUrl(url)) {
                                              throw Exception(
                                                  'Could not launch ');
                                            }
                                          },
                                          child: Text("Download"),
                                        ),
                                      ],
                                    ),
                                  ),
                                  GestureDetector(
                                    onTap: () async {
                                      if (file['local']) {
                                        stateController.files.removeWhere(
                                          (localFile) =>
                                              file['name'] == localFile.name,
                                        );

                                        stateController.files = stateController
                                            .files
                                            .map((file) => file)
                                            .toList();

                                        return;
                                      }
                                      stateController.deleteAssessmentFile(
                                        file["id"],
                                      );

                                      data!["AssessmentFile"].removeAt(index -
                                          stateController.files.length -
                                          1);
                                    },
                                    child: Container(
                                      padding: EdgeInsets.all(4),
                                      decoration: BoxDecoration(
                                        color: Get.theme.colorScheme.onPrimary,
                                        borderRadius: BorderRadius.circular(4),
                                      ),
                                      child: Icon(
                                        Icons.delete,
                                        size: 18,
                                      ),
                                    ),
                                  ),
                                ],
                              );
                            })),
                      )
                    ],
                  ),
                ),
              ),
              GestureDetector(
                onTap: () async {
                  if (titleController.text.isEmpty) {
                    Toast.error("Title is required", "Enter title");
                    return;
                  }
                  if (descriptionController.text.isEmpty) {
                    Toast.error("Description is required", "Enter description");
                    return;
                  }
                  if (maxMarksController.text.isEmpty) {
                    Toast.error("Max marks is required", "Enter max marks");
                    return;
                  }
                  if (weightageController.text.isEmpty) {
                    Toast.error("Weightage is required", "Enter weightage");
                    return;
                  }
                  if (stateController.deadline == null) {
                    Toast.error("Deadline is required", "Select deadline");
                    return;
                  }
                  // if (["Project", "Assignment"]
                  //         .contains(stateController.selectedType) &&
                  //     (stateController.files.isEmpty &&
                  //         (data == null || data!["AssessmentFile"].isEmpty))) {
                  //   Toast.error("Files are required", "Select files");
                  //   return;
                  // }

                  await stateController.addAssessment(
                    assessmentId,
                    titleController.text,
                    descriptionController.text,
                    int.parse(maxMarksController.text),
                    int.parse(weightageController.text),
                    classId,
                  );
                  Get.until((route) => route.settings.arguments == 'lol');
                },
                child: Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: Get.theme.inputDecorationTheme.fillColor,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(12),
                    child: Center(
                      child: Text(
                        "Submit",
                        style: Get.textTheme.bodyLarge!.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
