import 'package:supabase_flutter/supabase_flutter.dart';

class CourseService {
  static final CourseService _instance = CourseService._internal();
  factory CourseService() => _instance;
  CourseService._internal();

  SupabaseClient get _supabase => Supabase.instance.client;
  Session? get session => _supabase.auth.currentSession;
  User? get user => _supabase.auth.currentUser;

  Future<List<Map<String, dynamic>>> getCourseActivities(int classId) async {
    return await _supabase
        .from("Assessment")
        .select("id, title, description, deadline, max, weight, type")
        .eq('classId', classId);
  }

  Future<List<Map<String, dynamic>>> getCourseAttendances(
    int classId,
    int studentId,
  ) async {
    return await _supabase
        .from("Attendance")
        .select("present, studentId, Schedule(startTime, classId)")
        .eq("Schedule.classId", classId)
        .filter("studentId", "eq", studentId);
  }

  Future<List<Map<String, dynamic>>> getCourseResults(
    int classId,
    int studentId,
  ) async {
    return _supabase
        .from("Assessment")
        .select("id, title, max, weight, type, Submission(marks)")
        .eq("classId", classId)
        .filter("Submission.studentId", "eq", studentId);
  }
}
