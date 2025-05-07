import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:project/controllers/auth_controller.dart';
import 'package:project/controllers/connection_controller.dart';
import 'package:project/pages/login_page.dart';
import 'package:project/pages/signup_page.dart';
import 'package:project/pages/student_home_page.dart';
import 'package:project/pages/teacher_home_page.dart';

class AuthChecker extends StatelessWidget {
  AuthChecker({super.key});

  final AuthController authController = Get.find<AuthController>();
  final ConnectionController connectionController =
      Get.find<ConnectionController>();

  @override
  Widget build(BuildContext context) {
    return Obx(() => connectionController.isOnline
        ? authController.isAuthenticated
            ? [
                Scaffold(
                  body: Center(
                    child: CircularProgressIndicator(),
                  ),
                ),
                StudentHomePage(),
                TeacherHomePage(),
                Scaffold(
                  body: Center(
                    child: Text("Admin Page"),
                  ),
                ),
              ][authController.role]
            : authController.isRegistering
                ? LoginPage()
                : SignupPage()
        : Scaffold(
            body: Center(
              child: Text("No connection"),
            ),
          ));
  }
}
