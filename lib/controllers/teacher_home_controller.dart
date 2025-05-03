import 'package:get/get.dart';
import 'package:project/controllers/auth_controller.dart';
import 'package:project/service/supabase_service.dart';

class TeacherHomeController extends GetxController {
  final authController = Get.find<AuthController>();

  /// TODO: Implement caching mechanism for classes and profile
  /// This will be done by making a teacher_home_actions.dart and teacher_home_model.dart
  /// file and registering the action in the DBHelper class.

  var classesRx = [].obs;
  // ignore: invalid_use_of_protected_member
  List get classes => classesRx.value;
  set classes(List value) => classesRx.value = value;

  var isLoadingRx = false.obs;
  bool get isLoading => isLoadingRx.value;
  set isLoading(bool value) => isLoadingRx.value = value;

  var nameRx = "".obs;
  String get name => nameRx.value;
  set name(String value) => nameRx.value = value;

  var positionRx = "".obs;
  String get position => positionRx.value;
  set position(String value) => positionRx.value = value;

  var departmentRx = "".obs;
  String get department => departmentRx.value;
  set department(String value) => departmentRx.value = value;

  @override
  onInit() {
    super.onInit();
    getPageData();
  }

  Future<void> getPageData() async {
    isLoading = true;

    final data = await SupabaseService.user.getTeacherHomePageData();
    name = data["name"];
    position = data["Teacher"][0]["position"];
    department = data["Department"]["name"];
    final flattenedClasses = data["Teacher"][0]["Class"].map((c) {
      return {
        "courseName": c["Course"]["name"],
        "term": c["term"],
        "section": c["section"],
      };
    }).toList();

    classes = flattenedClasses;

    isLoading = false;
  }
}
