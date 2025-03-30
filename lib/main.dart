import 'package:flutter/material.dart';
import 'package:project/controllers/auth_controller.dart';
import 'package:project/pages/student_home_page.dart';
import 'package:project/pages/login_page.dart';
import 'package:project/theme.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:get/get.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  const supabaseUrl = String.fromEnvironment("SUPABASE_URL");
  const supabaseAnonKey = String.fromEnvironment("SUPABASE_ANON_KEY");

  await Supabase.initialize(
    url: supabaseUrl,
    anonKey: supabaseAnonKey,
  );
  Get.put(AuthController());

  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light,
      darkTheme: AppTheme.dark,
      home: AuthChecker(),
    );
  }
}

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
          : LoginPage(),
    );
  }
}
