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
        .select("id, marks, SubmissionFile(name, url)")
        .eq('assessmentId', assessmentId)
        .eq('studentId', studentId);
  }
}
