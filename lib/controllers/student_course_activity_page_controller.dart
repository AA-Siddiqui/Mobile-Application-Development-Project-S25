import 'package:get/get.dart';
import 'package:project/service/supabase_service.dart';

class StudentCourseActivityPageController extends GetxController {
  /// TODO: Implement caching mechanism for course_activities_page
  /// This will be done by making a student_course_activities_page_actions.dart and student_course_activities_page_model.dart
  /// file and registering the action in the DBHelper class.

  var isLoadingRx = false.obs;
  bool get isLoading => isLoadingRx.value;
  set isLoading(bool value) => isLoadingRx.value = value;

  var marksRx = 0.obs;
  int get marks => marksRx.value;
  set marks(int value) => marksRx.value = value;

  var submissionIdRx = Rxn<int>();
  int? get submissionId => submissionIdRx.value;
  set submissionId(int? value) => submissionIdRx.value = value;

  var filesRx = [].obs;
  // ignore: invalid_use_of_protected_member
  List get uploadedFiles => filesRx.value;
  set uploadedFiles(List value) => filesRx.value = value;

  Future<void> getDetails(
    int assessmentId,
    int studentId,
  ) async {
    isLoading = true;
    final res = await SupabaseService.courseActivityService
        .getAssessmentDetails(assessmentId, studentId);

    if (res.isEmpty) {
      marks = 0;
      uploadedFiles = [];
      submissionId = null;
      isLoading = false;
      return;
    }

    marks = res[0]["marks"] ?? 0;
    uploadedFiles = res[0]["SubmissionFile"] ?? [];
    submissionId = res[0]["id"];

    isLoading = false;
  }
}
