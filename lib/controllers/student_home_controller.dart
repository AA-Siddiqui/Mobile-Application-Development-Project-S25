import 'package:get/get.dart';
import 'package:project/controllers/auth_controller.dart';
import 'package:project/service/supabase_service.dart';

class StudentHomeController extends GetxController {
  final int _roleId = Get.find<AuthController>().roleId;

  /// TODO: Implement caching mechanism for classes
  /// This will be done by making a student_home_actions.dart and student_home_model.dart
  /// file and registering the action in the DBHelper class.

  var classesRx = [].obs;
  // ignore: invalid_use_of_protected_member
  List get classes => classesRx.value;
  set classes(List value) => classesRx.value = value;

  @override
  void onInit() {
    super.onInit();
    fetchClassData();
  }

  void fetchClassData() async {
    // Fetch class data from the database
    final classData = await SupabaseService.user.getClassDetails(_roleId);
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
        "courseName": data["Course"]["name"],
        "teacherName": data["Teacher"]["User"]["name"],
        "term": data["term"],
        "section": data["section"],
      };
    }).toList();
    print(classes);
  }
}
