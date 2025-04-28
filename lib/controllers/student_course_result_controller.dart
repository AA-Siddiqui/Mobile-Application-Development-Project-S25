import 'package:get/get.dart';
import 'package:project/service/supabase_service.dart';

class StudentCourseResultController extends GetxController {
  /// TODO: Implement caching mechanism for results
  /// This will be done by making a student_course_results_actions.dart and student_course_results_model.dart
  /// file and registering the action in the DBHelper class.

  final courseResultsRx = <Map<String, dynamic>>[].obs;
  // ignore: invalid_use_of_protected_member
  List<Map<String, dynamic>> get courseResults => courseResultsRx.value;
  set courseResults(List<Map<String, dynamic>> value) =>
      courseResultsRx.value = value;

  var isLoadingRx = false.obs;
  bool get isLoading => isLoadingRx.value;
  set isLoading(bool value) => isLoadingRx.value = value;

  Future<void> getCourseResults(int classId, int studentId) async {
    isLoading = true;
    final unflattended =
        await SupabaseService.course.getCourseResults(classId, studentId);

    courseResults = unflattended.map((e) {
      final submission = e["Submission"] as List<dynamic>;
      return {
        "id": e["id"],
        "title": e["title"],
        "max": e["max"],
        "weight": e["weight"],
        // e["Submission"].isNotEmpty ? e["Submission"]["marks"] : 0,
        "marks": submission.isNotEmpty
            ? submission.fold(0, (sum, item) => sum + (item["marks"] as int))
            : 0,
      };
    }).toList();
    isLoading = false;
  }
}
