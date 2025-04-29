import 'package:supabase_flutter/supabase_flutter.dart';

class ResultService {
  static final ResultService _instance = ResultService._internal();
  factory ResultService() => _instance;
  ResultService._internal();

  SupabaseClient get _supabase => Supabase.instance.client;

  Future<List<Map<String, dynamic>>> getResults(int studentId) async {
    // 1. Get all completed class schedules (ended before today)
    final schedules = await _supabase
        .from('Schedule')
        .select('classId, endTime')
        .lt('endTime', DateTime.now().toIso8601String());

    final completedClassIds =
        schedules.map((s) => s['classId']).toSet().toList();

    if (completedClassIds.isEmpty) return [];

    // 2. Get class to course mapping
    final classes = await _supabase
        .from('Class')
        .select('id, courseId')
        .inFilter('id', completedClassIds);

    final classIdToCourseId = {for (var c in classes) c['id']: c['courseId']};

    final courseIds = classes.map((c) => c['courseId']).toSet().toList();

    // 3. Get course names and credit hours
    final courses = await _supabase
        .from('Course')
        .select('id, name, credits')
        .inFilter('id', courseIds);

    final courseIdToInfo = {
      for (var course in courses)
        course['id']: {'name': course['name'], 'creditHr': course['credits']}
    };

    // 4. Get all assessments from completed classes
    final assessments = await _supabase
        .from('Assessment')
        .select('id, classId, max, weight')
        .inFilter('classId', completedClassIds);

    final assessmentIds = assessments.map((a) => a['id']).toList();

    // 5. Get all submissions by this student
    final submissions = await _supabase
        .from('Submission')
        .select('assessmentId, marks')
        .eq('studentId', studentId)
        .inFilter('assessmentId', assessmentIds);

    // 6. Organize marks by course name
    final Map<String, List<Map<String, dynamic>>> marksByCourse = {};

    for (var assessment in assessments) {
      final classID = assessment['classId'];
      final assessmentID = assessment['id'];
      final weight = (assessment['weight'] as num).toDouble();
      final max = (assessment['max'] as num).toDouble();

      final submission = submissions.firstWhere(
        (s) => s['assessmentId'] == assessmentID,
        orElse: () => {},
      );

      if (submission.isNotEmpty) {
        final marks = (submission['marks'] as num).toDouble();
        final courseID = classIdToCourseId[classID];
        final courseInfo = courseIdToInfo[courseID];

        if (courseInfo != null) {
          final courseName = courseInfo['name'];

          marksByCourse.putIfAbsent(courseName, () => []);
          marksByCourse[courseName]!.add({
            'weighted': (marks / max) * weight,
            'weight': weight,
            'credits': courseInfo['creditHr']
          });
        }
      }
    }

    // 7. Grading helper
    String getGrade(double marks) {
      if (marks >= 85) return "A+";
      if (marks >= 80) return "A";
      if (marks >= 75) return "B+";
      if (marks >= 71) return "B";
      if (marks >= 68) return "B-";
      if (marks >= 64) return "C+";
      if (marks >= 61) return "C";
      if (marks >= 58) return "C-";
      if (marks >= 54) return "D+";
      if (marks >= 50) return "D";
      return "F";
    }

    // 8. Final result
    final result = marksByCourse.entries.map((entry) {
      final entries = entry.value;
      final totalWeighted = entries.fold(0.0, (sum, e) => sum + e['weighted']);
      final totalWeight = entries.fold(0.0, (sum, e) => sum + e['weight']);
      final percent = totalWeighted / totalWeight * 100;

      return {
        'title': entry.key,
        'marks': percent,
        'grade': getGrade(percent),
        'credits': entries[0]['credits'],
      };
    }).toList();

    return result;
  }
}
