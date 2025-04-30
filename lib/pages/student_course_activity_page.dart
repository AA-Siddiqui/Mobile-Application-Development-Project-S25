import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:project/controllers/auth_controller.dart';
import 'package:project/controllers/student_course_activity_page_controller.dart';
import 'package:project/utils/toast.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:url_launcher/url_launcher.dart';

class StudentCourseActivityPage extends StatelessWidget {
  final Map<String, dynamic> data;
  final stateController = Get.put(StudentCourseActivityPageController());
  final authController = Get.find<AuthController>();
  StudentCourseActivityPage(this.data, {super.key}) {
    stateController.getDetails(
      data["id"],
      authController.roleId,
    );
  }

  Widget _buildTile(String title, String? value, [bool large = false]) {
    final widgets = [
      Text(
        title,
        style: TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 18,
          color: Get.theme.colorScheme.onPrimaryContainer,
        ),
      ),
      Text(
        value ?? title,
        style: TextStyle(
          fontSize: 16,
          color: Get.theme.colorScheme.onPrimaryContainer,
        ),
      ),
    ];
    return Container(
      padding: EdgeInsets.all(12),
      margin: EdgeInsets.symmetric(vertical: 4),
      decoration: BoxDecoration(
        color: Get.theme.colorScheme.primaryContainer,
        borderRadius: BorderRadius.circular(4),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: large
            ? [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: widgets,
                )
              ]
            : widgets,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          data["title"],
          style: Get.textTheme.headlineSmall!.copyWith(
            color: Get.theme.colorScheme.primary,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: Colors.transparent,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Column(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Padding(
                  //   padding: const EdgeInsets.symmetric(horizontal: 16),
                  //   child: Text(
                  //     data["title"],
                  //     style: Get.textTheme.headlineLarge!.copyWith(
                  //       color: Get.theme.colorScheme.primary,
                  //       fontWeight: FontWeight.bold,
                  //     ),
                  //   ),
                  // ),
                  _buildTile("Description", data["description"], true),
                  _buildTile("Type", data["type"]),
                  _buildTile("Deadline", () {
                    final datetime = DateTime.parse(data["deadline"]);
                    final month = [
                      "",
                      "Jan",
                      "Feb",
                      "Mar",
                      "Apr",
                      "May",
                      "Jun",
                      "Jul",
                      "Aug",
                      "Sep",
                      "Oct",
                      "Nov",
                      "Dec",
                    ][datetime.month];
                    final date = datetime.day;
                    final year = datetime.year;
                    final hour = datetime.hour % 12;
                    final min = datetime.minute.toString().padLeft(2, "0");
                    final apm = datetime.hour < 12 ? "AM" : "PM";
                    return "$month $date, $year - $hour:$min $apm";
                  }()),
                  _buildTile("Total", data["max"].toStringAsFixed(1)),
                  _buildTile("Weight", data["weight"].toStringAsFixed(1)),

                  if (DateTime.parse(data["deadline"])
                          .compareTo(DateTime.now()) <
                      0)
                    Obx(() => _buildTile(
                        "Marks", stateController.marks.toStringAsFixed(1))),
                  if (data["AssessmentFile"]?.isNotEmpty ?? false)
                    SizedBox(
                      height: 100,
                      child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          itemCount: data["AssessmentFile"].length,
                          itemBuilder: (context, index) {
                            final file = data["AssessmentFile"][index];
                            return Container(
                              padding: EdgeInsets.symmetric(
                                  vertical: 7.5, horizontal: 8),
                              margin:
                                  EdgeInsets.only(right: 8, bottom: 8, top: 8),
                              decoration: BoxDecoration(
                                color: Get.theme.colorScheme.primaryContainer,
                                borderRadius: BorderRadius.circular(4),
                              ),
                              child: Column(
                                children: [
                                  Text(
                                    file["name"],
                                    style: Get.textTheme.titleSmall!.copyWith(
                                      color: Get
                                          .theme.colorScheme.onPrimaryContainer,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  SizedBox(height: 4),
                                  ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: Get
                                          .theme.colorScheme.secondaryContainer,
                                    ),
                                    onPressed: () async {
                                      final Uri url = Uri.parse(
                                        file["url"],
                                      );

                                      if (!await launchUrl(url)) {
                                        throw Exception(
                                            'Could not launch $url');
                                      }
                                    },
                                    child: Text("Download"),
                                  ),
                                ],
                              ),
                            );
                          }),
                    )
                ],
              ),
              Column(
                children: [
                  if (stateController.uploadedFiles.isNotEmpty)
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        "Uploaded Files",
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  Obx(() {
                    if (stateController.uploadedFiles.isNotEmpty) {
                      return Skeletonizer(
                        enabled: stateController.isLoading,
                        child: SizedBox(
                          height: 100,
                          child: ListView.builder(
                              scrollDirection: Axis.horizontal,
                              itemCount: stateController.uploadedFiles.length,
                              itemBuilder: (context, index) {
                                return Container(
                                  padding: EdgeInsets.symmetric(
                                      vertical: 7.5, horizontal: 8),
                                  margin: EdgeInsets.only(
                                      right: 8, bottom: 8, top: 8),
                                  decoration: BoxDecoration(
                                    color:
                                        Get.theme.colorScheme.primaryContainer,
                                    borderRadius: BorderRadius.circular(4),
                                  ),
                                  child: Column(
                                    children: [
                                      Text(
                                        stateController.uploadedFiles[index]
                                            ["name"],
                                        style:
                                            Get.textTheme.titleSmall!.copyWith(
                                          color: Get.theme.colorScheme
                                              .onPrimaryContainer,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      SizedBox(height: 4),
                                      ElevatedButton(
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor: Get.theme.colorScheme
                                              .secondaryContainer,
                                        ),
                                        onPressed: () async {
                                          final Uri url = Uri.parse(
                                            stateController.uploadedFiles[index]
                                                ["url"],
                                          );

                                          if (!await launchUrl(url)) {
                                            throw Exception(
                                                'Could not launch $url');
                                          }
                                        },
                                        child: Text("Download"),
                                      ),
                                    ],
                                  ),
                                );
                              }),
                        ),
                      );
                    }
                    return Container();
                  }),
                  if (DateTime.parse(data["deadline"])
                          .compareTo(DateTime.now()) >
                      0)
                    GestureDetector(
                      onTap: () async {
                        // TODO: Throw this shit into appropriate files
                        final status = await Permission.storage.request();
                        final hasPermission = status.isGranted;

                        if (!hasPermission) {
                          Toast.error(
                            "Storage permission denied",
                            "Go to settings to allow permission to access storage",
                          );
                          return;
                        }

                        final result = await FilePicker.platform.pickFiles(
                          allowMultiple: true,
                        );

                        if (result == null) {
                          return;
                        }

                        final supabase = Supabase.instance.client;
                        final files = result.files;

                        final sub = await Supabase.instance.client
                            .from("Submission")
                            .upsert(stateController.submissionId == null
                                ? {
                                    "assessmentId": data["id"],
                                    "studentId": authController.roleId,
                                    "marks": 0,
                                  }
                                : {
                                    "id": stateController.submissionId,
                                    "assessmentId": data["id"],
                                    "studentId": authController.roleId,
                                    "marks": stateController.marks,
                                  })
                            .select();

                        for (final file in files) {
                          final fileBytes = File(file.path!).readAsBytesSync();

                          final response = await supabase.storage
                              .from('submissions')
                              .uploadBinary(
                                'submissions/${data["id"]}/${authController.roleId}/${file.name}',
                                fileBytes,
                                fileOptions: FileOptions(
                                  upsert: true,
                                ),
                              );

                          if (response.isNotEmpty) {
                            Toast.info("Upload Successful",
                                "File ${file.name} uploaded successfully!");
                          } else {
                            Toast.error("Upload error", response);
                          }

                          await Supabase.instance.client
                              .from("SubmissionFile")
                              .insert({
                            "name": file.name,
                            "url": Supabase.instance.client.storage
                                .from('submissions')
                                .getPublicUrl(
                                    "submissions/${data["id"]}/${authController.roleId}/${file.name}"),
                            "submissionId": sub[0]["id"],
                          });
                        }
                        stateController.getDetails(
                          data["id"],
                          authController.roleId,
                        );
                      },
                      child: _buildTile("Upload", "Tap here to upload file"),
                    ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
