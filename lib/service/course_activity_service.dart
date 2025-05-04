import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:project/utils/toast.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class CourseActivityService {
  static final CourseActivityService _instance =
      CourseActivityService._internal();
  factory CourseActivityService() => _instance;
  CourseActivityService._internal();

  SupabaseClient get _supabase => Supabase.instance.client;

  Future<List<Map<String, dynamic>>> getAssessmentDetails(
    int assessmentId,
    int studentId,
  ) async {
    return await _supabase
        .from("Submission")
        .select("id, marks, SubmissionFile(id, name, url)")
        .eq('assessmentId', assessmentId)
        .eq('studentId', studentId);
  }

  Future<List<Map<String, String>>> uploadSubmission(
    List<PlatformFile> files,
    int assessmentId,
    int studentId,
    int marks,
    int? submissionId,
  ) async {
    final sub = await _supabase
        .from("Submission")
        .upsert(submissionId == null
            ? {
                "assessmentId": assessmentId,
                "studentId": studentId,
                "marks": 0,
              }
            : {
                "id": submissionId,
                "assessmentId": assessmentId,
                "studentId": studentId,
                "marks": marks,
              })
        .select();

    List<Map<String, String>> uploadedFiles = [];
    for (final file in files) {
      final fileBytes = File(file.path!).readAsBytesSync();

      final response = await _supabase.storage.from('submissions').uploadBinary(
            'submissions/$assessmentId/$studentId/${file.name}',
            fileBytes,
            fileOptions: FileOptions(
              upsert: true,
            ),
          );

      if (response.isNotEmpty) {
        Toast.info(
            "Upload Successful", "File ${file.name} uploaded successfully!");
      } else {
        Toast.error("Upload error", response);
      }

      final uploadedFile = await _supabase.from("SubmissionFile").insert({
        "name": file.name,
        "url": _supabase.storage
            .from('submissions')
            .getPublicUrl("submissions/$assessmentId/$studentId/${file.name}"),
        "submissionId": sub[0]["id"],
      }).select();

      uploadedFiles.add({
        "id": uploadedFile[0]["id"],
        "name": file.name,
        "url": _supabase.storage
            .from('submissions')
            .getPublicUrl("submissions/$assessmentId/$studentId/${file.name}")
      });
    }
    return uploadedFiles;
  }

  Future<void> deleteSubmissionFile(int submissionFileId) async {
    await _supabase.from("SubmissionFile").delete().eq("id", submissionFileId);
  }

  Future<void> deleteAssessmentFile(int assessmentFileId) async {
    await _supabase.from("assessmentFile").delete().eq("id", assessmentFileId);
  }

  Future<bool> addAssessment(
    int? assessmentId,
    String title,
    String description,
    String type,
    DateTime? deadline,
    int max,
    int weight,
    int classId,
    List<PlatformFile> files,
  ) async {
    final assessmentResult = await _supabase
        .from("Assessment")
        .upsert(assessmentId != null
            ? {
                "id": assessmentId,
                "title": title,
                "description": description,
                "deadline": deadline!.toIso8601String(),
                "max": max,
                "weight": weight,
                "type": "Assignment",
                "classId": classId,
              }
            : {
                "title": title,
                "description": description,
                "deadline": deadline!.toIso8601String(),
                "max": max,
                "weight": weight,
                "type": "Assignment",
                "classId": classId,
              })
        .select("id");
    final newAssessmentId = assessmentResult[0]["id"];

    for (final file in files) {
      final fileBytes = File(file.path!).readAsBytesSync();

      final response = await _supabase.storage.from('submissions').uploadBinary(
            'assessments/$newAssessmentId/${file.name}',
            fileBytes,
            fileOptions: FileOptions(
              upsert: true,
            ),
          );

      if (response.isNotEmpty) {
        Toast.info(
            "Upload Successful", "File ${file.name} uploaded successfully!");
      } else {
        Toast.error("Upload error", response);
        return false;
      }

      await _supabase.from("AssessmentFile").insert({
        "name": file.name,
        "url": _supabase.storage
            .from('assessments')
            .getPublicUrl("assessments/$newAssessmentId/${file.name}"),
        "assessmentId": newAssessmentId,
      });
    }
    Toast.info("Success", "Assessment added successfully!");
    return true;
  }
}
