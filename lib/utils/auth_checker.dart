import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:project/controllers/auth_controller.dart';
import 'package:project/pages/login_page.dart';
import 'package:project/pages/signup_page.dart';
import 'package:project/pages/student_home_page.dart';

class AuthChecker extends StatelessWidget {
  AuthChecker({super.key});

  final AuthController authController = Get.find<AuthController>();

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => authController.isAuthenticated
          ? [
              Scaffold(
                body: Center(
                  child: CircularProgressIndicator(),
                ),
              ),
              StudentHomePage(),
              Scaffold(
                body: Center(
                  child: Text("Teacher Page"),
                ),
              ),
              Scaffold(
                body: Center(
                  child: Text("Admin Page"),
                ),
              ),
            ][authController.role]
          : authController.isRegistered
              ? LoginPage()
              : SignupPage(),
    );
  }
}
