import 'package:get/get.dart';
import 'package:project/service/supabase_service.dart';

class TeacherGradingController extends GetxController {
  /// TODO: Implement caching mechanism for grades
  /// This will be done by making a teacher_grades_actions.dart and teacher_grades_model.dart
  /// file and registering the action in the DBHelper class.

  TeacherGradingController(int classId, int assessmentId) {
    getStudentList(classId, assessmentId);
  }

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
      action["Student"]["name"] = action["Student"]["User"]["name"];
      action["Student"].removeWhere((key, value) => key == "User");
      action["Student"]["marks"] =
          action["Class"]["Assessment"][0]["Submission"].isNotEmpty
              ? action["Class"]["Assessment"][0]["Submission"][0]["marks"]
              : 0;
      action["Class"].removeWhere((key, value) => key == "User");
      action = action["Student"];
      action["studentId"] = action["id"];
      action.removeWhere((key, value) => key == "id");
      return action;
    }).toList();
    isLoading = false;
  }
}
