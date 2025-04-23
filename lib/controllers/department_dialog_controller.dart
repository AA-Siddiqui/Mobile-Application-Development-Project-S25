import 'package:get/get.dart';
import 'package:project/service/supabase_service.dart';
import 'package:project/utils/toast.dart';

class DepartmentDialogController extends GetxController {
  var selectedDepartment = ''.obs;
  var selectedProgram = ''.obs;

  var departmentsRx = <String>[].obs;
  // ignore: invalid_use_of_protected_member
  List<String> get departments => departmentsRx.value;
  set departments(List<String> value) => departmentsRx.value = value;

  var programRx = <String>[].obs;
  // ignore: invalid_use_of_protected_member
  List<String> get program => programRx.value;
  set program(List<String> value) => programRx.value = value;

  var allDeps = [].obs;

  /// TODO: Implement caching mechanism for departments and programs
  /// This will be done by making a signup_actions.dart and signup_model.dart
  /// file and registering the action in the DBHelper class.

  @override
  void onInit() {
    super.onInit();
    SupabaseService.department.getDepartments().then((fetchedDepartments) {
      allDeps.value = fetchedDepartments;
      departments =
          fetchedDepartments.map((e) => e['name']).whereType<String>().toList();
    }).catchError((error) {
      Toast.error("Error", error.toString());
    });
  }

  void getPrograms(int departmentId) async {
    final programs = await SupabaseService.department.getPrograms(departmentId);
    program = programs.map((e) => e['name']).whereType<String>().toList();
  }

  void selectDepartment(String department) {
    selectedDepartment.value = department;
    int depId = -1;

    allDeps.where((e) => e['name'] == department).forEach((e) {
      depId = e['id'];
    });

    getPrograms(depId); // Fetch programs for the selected department
    Get.back(); // Close the dialog after selection
  }

  void selectProgram(String program) {
    selectedProgram.value = program;
    Get.back(); // Close the dialog after selection
  }
}
