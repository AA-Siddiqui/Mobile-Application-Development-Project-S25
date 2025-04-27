import 'package:get/get.dart';
import 'package:project/service/supabase_service.dart';

class StudentCourseAttendanceController extends GetxController {
  /// TODO: Implement caching mechanism for attendances
  /// This will be done by making a student_course_attendances_actions.dart and student_course_attendances_model.dart
  /// file and registering the action in the DBHelper class.

  final courseAttendancesRx = <Map<String, dynamic>>[].obs;
  // ignore: invalid_use_of_protected_member
  List<Map<String, dynamic>> get courseAttendances => courseAttendancesRx.value;
  set courseAttendances(List<Map<String, dynamic>> value) =>
      courseAttendancesRx.value = value;

  var isLoadingRx = false.obs;
  bool get isLoading => isLoadingRx.value;
  set isLoading(bool value) => isLoadingRx.value = value;

  Future<void> getCourseAttendances(int classId, int studentId) async {
    isLoading = true;
    final unflattended =
        await SupabaseService.course.getCourseAttendances(classId, studentId);
    courseAttendances = unflattended.map((e) {
      return {
        "present": e["present"],
        "startTime": e["Schedule"]["startTime"],
      };
    }).toList();
    isLoading = false;
  }
}
