import 'package:get/get.dart';
import 'package:project/service/supabase_service.dart';

class TeacherGradingController extends GetxController {
  /// TODO: Implement caching mechanism for grades
  /// This will be done by making a teacher_grades_actions.dart and teacher_grades_model.dart
  /// file and registering the action in the DBHelper class.

  TeacherGradingController(int classId, int assessmentId) {
    getStudentList(classId, assessmentId);
  }

  var requestCountRx = 0.obs;
  int get requestCount => requestCountRx.value;
  set requestCount(int value) => requestCountRx.value = value;

  var requestDoneRx = 0.obs;
  int get requestDone => requestDoneRx.value;
  set requestDone(int value) => requestDoneRx.value = value;

  var isLoadingRx = false.obs;
  bool get isLoading => isLoadingRx.value;
  set isLoading(bool value) => isLoadingRx.value = value;

  var gradeListRx = [].obs;
  // ignore: invalid_use_of_protected_member
  List get gradeList => gradeListRx.value;
  set gradeList(List value) => gradeListRx.value = value;

  void getStudentList(int classId, int assessmentId) async {
    isLoading = true;
    final data = await SupabaseService.courseActivity
        .getGradingDetails(assessmentId, classId);
    gradeList = data.map((action) {
      return {
        "studentId": action["Student"]["id"],
        "name": action["Student"]["User"]["name"],
        "rollNo": action["Student"]["rollNo"],
        "max": action["Class"]["Assessment"][0]["max"],
        "marks": action["Class"]["Assessment"][0]["Submission"].isNotEmpty
            ? action["Class"]["Assessment"][0]["Submission"][0]["marks"]
            : 0,
        "submissionMade":
            action["Class"]["Assessment"][0]["Submission"].isNotEmpty,
        "submissionId":
            action["Class"]["Assessment"][0]["Submission"].isNotEmpty
                ? action["Class"]["Assessment"][0]["Submission"][0]["id"]
                : null,
      };
    }).toList();
    isLoading = false;
  }

  Future<int> updateMarks(
    int marks,
    int assessmentId,
    int studentId,
    int? submissionId,
  ) async {
    return await SupabaseService.courseActivity.updateMarks(
      marks,
      assessmentId,
      studentId,
      submissionId,
    );
  }
}
