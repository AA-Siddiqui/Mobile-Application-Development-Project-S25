import 'package:get/get.dart';
import 'package:project/service/supabase_service.dart';

class TeacherCourseActivityController extends GetxController {
  /// TODO: Implement caching mechanism for activities
  /// This will be done by making a teacher_course_activities_actions.dart and teacher_course_activities_model.dart
  /// file and registering the action in the DBHelper class.

  var isLoadingRx = false.obs;
  bool get isLoading => isLoadingRx.value;
  set isLoading(bool value) => isLoadingRx.value = value;

  var isUploadingRx = false.obs;
  bool get isUploading => isUploadingRx.value;
  set isUploading(bool value) => isUploadingRx.value = value;

  var selectedTypeRx = "Assignment".obs;
  String get selectedType => selectedTypeRx.value;
  set selectedType(String value) => selectedTypeRx.value = value;

  var deadlineRx = DateTime.now().obs;
  DateTime get deadline => deadlineRx.value;
  set deadline(DateTime value) => deadlineRx.value = value;

  Future<void> deleteAssessmentFile(int assessmentFileId) async {
    isUploading = true;
    await SupabaseService.courseActivity.deleteAssessmentFile(assessmentFileId);
    isUploading = false;
  }
}
