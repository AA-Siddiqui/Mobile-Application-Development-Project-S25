import 'package:get/get.dart';
import 'package:project/controllers/auth_controller.dart';

class TeacherHomeController extends GetxController {
  final authController = Get.find<AuthController>();

  /// TODO: Implement caching mechanism for classes and profile
  /// This will be done by making a teacher_home_actions.dart and teacher_home_model.dart
  /// file and registering the action in the DBHelper class.

  var classesRx = <Map<String, dynamic>>[].obs;
  // ignore: invalid_use_of_protected_member
  List<Map<String, dynamic>> get classes => classesRx.value;
  set classes(List<Map<String, dynamic>> value) => classesRx.value = value;

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

  // TODO: WORK HERE
}
