import 'package:get/get.dart';
import 'package:project/controllers/auth_controller.dart';
import 'package:project/service/supabase_service.dart';

class StudentHomeController extends GetxController {
  final authController = Get.find<AuthController>();

  /// TODO: Implement caching mechanism for classes
  /// This will be done by making a student_home_actions.dart and student_home_model.dart
  /// file and registering the action in the DBHelper class.

  var classesRx = <Map<String, dynamic>>[].obs;
  // ignore: invalid_use_of_protected_member
  List<Map<String, dynamic>> get classes => classesRx.value;
  set classes(List<Map<String, dynamic>> value) => classesRx.value = value;

  var isLoadingRx = false.obs;
  bool get isLoading => isLoadingRx.value;
  set isLoading(bool value) => isLoadingRx.value = value;

  @override
  void onInit() {
    super.onInit();
    fetchClassData();
  }

  void fetchClassData() async {
    // Fetch class data from the database
    isLoading = false;

    while (authController.roleId == -1) {
      await Future.delayed(const Duration(milliseconds: 100));
    }
    final classData =
        await SupabaseService.user.getClassDetails(authController.roleId);
    classes = classData.map((data) {
      // {
      //   Class: {
      //     term: Spring 2025,
      //     Course: {
      //       name: Programming Fundamentals (Theory)
      //     },
      //     Teacher: {
      //       User: {
      //         name: Addan Abdullah
      //       }
      //     },
      //   section: BSSE-1B
      //   }
      // }
      data = data["Class"];
      return {
        "id": data["id"],
        "courseName": data["Course"]["name"],
        "teacherName": data["Teacher"]["User"]["name"],
        "term": data["term"],
        "section": data["section"],
      };
    }).toList();
    isLoading = false;
  }
}
