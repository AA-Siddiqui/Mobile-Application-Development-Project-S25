import 'package:get/get.dart';
import 'package:project/service/supabase_service.dart';

class TeacherCourseActivityListController extends GetxController {
  /// TODO: Implement caching mechanism for activities
  /// This will be done by making a teacher_course_activities_actions.dart and teacher_course_activities_model.dart
  /// file and registering the action in the DBHelper class.

  final courseActivitiesRx = <Map<String, dynamic>>[].obs;
  // ignore: invalid_use_of_protected_member
  List<Map<String, dynamic>> get courseActivities => courseActivitiesRx.value;
  set courseActivities(List<Map<String, dynamic>> value) =>
      courseActivitiesRx.value = value;

  var isLoadingRx = false.obs;
  bool get isLoading => isLoadingRx.value;
  set isLoading(bool value) => isLoadingRx.value = value;

  Future<void> getCourseActivities(int classId) async {
    isLoading = true;
    courseActivities =
        await SupabaseService.course.getCourseActivities(classId);
    isLoading = false;
  }

  void deleteActivity(int assessmentId) async {
    isLoading = true;
    await SupabaseService.course.deleteActivity(assessmentId);
    courseActivities.removeWhere((element) => element["id"] == assessmentId);
    isLoading = false;
  }
}
