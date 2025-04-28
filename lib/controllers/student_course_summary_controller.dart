import 'package:get/get.dart';
import 'package:project/service/supabase_service.dart';

class StudentCourseSummaryController extends GetxController {
  /// TODO: Implement caching mechanism for summary
  /// This will be done by making a student_course_suummary_actions.dart and student_course_suummary_model.dart
  /// file and registering the action in the DBHelper class.

  var isLoadingRx = true.obs;
  bool get isLoading => isLoadingRx.value;
  set isLoading(bool value) => isLoadingRx.value = value;

  var totalClassesRx = 0.obs;
  int get totalClasses => totalClassesRx.value;
  set totalClasses(int value) => totalClassesRx.value = value;

  var attendedClassesRx = 0.obs;
  int get attendedClasses => attendedClassesRx.value;
  set attendedClasses(int value) => attendedClassesRx.value = value;

  var obtainedMarksRx = 0.obs;
  int get obtainedMarks => obtainedMarksRx.value;
  set obtainedMarks(int value) => obtainedMarksRx.value = value;

  var totalMarksRx = 0.obs;
  int get totalMarks => totalMarksRx.value;
  set totalMarks(int value) => totalMarksRx.value = value;

  var obtainedWeightedMarksRx = 0.0.obs;
  double get obtainedWeightedMarks => obtainedWeightedMarksRx.value;
  set obtainedWeightedMarks(double value) =>
      obtainedWeightedMarksRx.value = value;

  var totalWeightedMarksRx = 0.obs;
  int get totalWeightedMarks => totalWeightedMarksRx.value;
  set totalWeightedMarks(int value) => totalWeightedMarksRx.value = value;

  void init(int classId, int studentId) {
    getTotalClasses(classId);
    getAttendedClasses(classId, studentId);
    getMarkings(classId, studentId);
  }

  Future<void> getTotalClasses(int classId) async {
    totalClasses = await SupabaseService.course.getTotalClasses(classId);
  }

  Future<void> getAttendedClasses(int classId, int studentId) async {
    attendedClasses = await SupabaseService.course.getAttendedClasses(
      classId,
      studentId,
    );
  }

  Future<void> getMarkings(int classId, int studentId) async {
    isLoading = true;
    obtainedMarks = await SupabaseService.course.getObtainedMarks(
      classId,
      studentId,
    );
    totalMarks = await SupabaseService.course.getTotalMarks(classId);
    obtainedWeightedMarks = await SupabaseService.course.getWeightedMarks(
      classId,
      studentId,
    );
    totalWeightedMarks = await SupabaseService.course.getWeightedTotalMarks(
      classId,
    );
    isLoading = false;
  }
}
