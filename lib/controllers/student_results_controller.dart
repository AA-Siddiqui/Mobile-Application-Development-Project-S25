import 'package:get/get.dart';
import 'package:project/service/supabase_service.dart';

class StudentResultsController extends GetxController {
  /// TODO: Implement caching mechanism for results
  /// This will be done by making a student_results_actions.dart and student_results_model.dart
  /// file and registering the action in the DBHelper class.

  var isLoadingRx = false.obs;
  bool get isLoading => isLoadingRx.value;
  set isLoading(bool value) => isLoadingRx.value = value;

  var cgpaRx = 0.0.obs;
  double get cgpa => cgpaRx.value;
  set cgpa(double value) => cgpaRx.value = value;

  var resultsRx = <Map<String, dynamic>>[].obs;
  // ignore: invalid_use_of_protected_member
  List<Map<String, dynamic>> get results => resultsRx.value;
  set results(List<Map<String, dynamic>> value) => resultsRx.value = value;

  double _getScoreFromGrade(String grade) {
    switch (grade) {
      case "A+":
        return 4.0;
      case "A":
        return 3.667;
      case "B+":
        return 3.333;
      case "B":
        return 3.0;
      case "B-":
        return 2.667;
      case "C+":
        return 2.333;
      case "C":
        return 2.0;
      case "C-":
        return 1.667;
      case "D+":
        return 1.333;
      case "D":
        return 1.0;
      default:
        return 0;
    }
  }

  void getResults(int studentId) async {
    isLoading = true;
    results = await SupabaseService.result.getResults(studentId);

    double totalCredits = 0.0;
    double totalPoints = 0.0;

    for (var result in results) {
      totalPoints += (_getScoreFromGrade(result['grade']) * result['credits']);
      totalCredits += result['credits'];
    }
    cgpa = totalCredits == 0 ? 0 : totalPoints / totalCredits;

    isLoading = false;
  }
}
