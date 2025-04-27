import 'package:supabase_flutter/supabase_flutter.dart';

class CourseService {
  static final CourseService _instance = CourseService._internal();
  factory CourseService() => _instance;
  CourseService._internal();

  SupabaseClient get _supabase => Supabase.instance.client;
  Session? get session => _supabase.auth.currentSession;
  User? get user => _supabase.auth.currentUser;

  Future<List<Map<String, dynamic>>> getCourseActivities(int classId) async {
    return await Supabase.instance.client
        .from("Assessment")
        .select("id, title, description, deadline, max, weight, type")
        .eq('classId', classId);
  }

  Future<List<Map<String, dynamic>>> getCourseAttendances(int classId) async {
    return await Supabase.instance.client
        .from("Attendance")
        .select("present, Schedule(startTime, classId)")
        .eq("Schedule.classId", classId);
  }
}
