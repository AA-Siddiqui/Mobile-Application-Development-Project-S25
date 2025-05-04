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
        .select(
            "id, title, description, deadline, max, weight, type, AssessmentFile(id, name, url)")
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

  Future<int> getTotalClasses(int classId) async {
    return (await _supabase
            .from('Schedule')
            .select('count')
            .eq('classId', classId)
            .lt('endTime', DateTime.now())
            .count(CountOption.exact))
        .count;
  }

  Future<int> getAttendedClasses(int classId, int studentId) async {
    return (await _supabase
            .from('Attendance')
            .select('*, Schedule(classId)')
            .eq('Schedule.classId', classId)
            .eq('present', true)
            .filter("studentId", "eq", studentId)
            .count(CountOption.exact))
        .count;
  }

  Future<int> getObtainedMarks(int classId, int studentId) async {
    final res = (await _supabase
        .from('Assessment')
        .select('Submission(marks)')
        .eq('classId', classId)
        .eq('Submission.studentId', studentId));

    final markList = res
        .map(
            (e) => e['Submission'].isNotEmpty ? e['Submission'][0]['marks'] : 0)
        .toList()
        .whereType<int>();
    if (markList.isEmpty) return 0;

    return markList.reduce((a, b) => a + b);
  }

  Future<int> getTotalMarks(int classId) async {
    final res = (await _supabase
        .from('Assessment')
        .select('max')
        .eq('classId', classId));
    final maxList = res.map((e) => e['max']).whereType<int>().toList();
    if (maxList.isEmpty) return 0;
    return maxList.reduce((a, b) => a + b);
  }

  Future<double> getWeightedMarks(int classId, int studentId) async {
    final res = (await _supabase
        .from('Assessment')
        .select('Submission(marks), weight, max')
        .eq('classId', classId)
        .eq('Submission.studentId', studentId));

    final markList = res
        .map((e) => {
              0: e['Submission'].isNotEmpty ? e['Submission'][0]['marks'] : 0,
              1: e['weight'],
              2: e['max'],
            })
        .whereType<Map<int, dynamic>>()
        .where((element) => element[0] != null)
        .toList();

    if (markList.isEmpty) return 0;
    return markList
        .map((e) => (e[0]! / e[2]! * e[1]!))
        .toList()
        .reduce((a, b) => a + b);
  }

  Future<int> getWeightedTotalMarks(int classId) async {
    final res = (await _supabase
        .from('Assessment')
        .select('max, weight')
        .eq('classId', classId));

    final totalList = res.map((e) => e['weight']).toList();
    if (totalList.isEmpty) return 0;
    return totalList.reduce((a, b) => a + b);
  }

  Future<List<Map<String, dynamic>>> getSchedules(int classId) async {
    return await _supabase
        .from("Schedule")
        .select(
            "id, startTime, endTime, Attendance(id, present, Student(id, rollNo, User(name)))")
        .eq("classId", classId);
  }

  Future<void> markAttendance(
    int attendanceId,
    int scheduleId,
    int studentId,
    bool present,
  ) async {
    await _supabase.from("Attendance").upsert({
      "id": attendanceId,
      "scheduleId": scheduleId,
      "studentId": studentId,
      "present": present,
    });
  }
}
