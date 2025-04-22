import 'package:flutter/material.dart';
import 'package:project/controllers/auth_controller.dart';
import 'package:project/pages/splash_page.dart';
import 'package:project/theme.dart';
import 'package:project/utils/auth_checker.dart';
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
      home: FutureBuilder(
        future: Future.delayed(
          const Duration(seconds: 3),
          () {
            return true;
          },
        ),
        builder: (context, snapshot) {
          if (snapshot.hasData && snapshot.data == true) {
            return AuthChecker();
          } else {
            return const SplashPage();
          }
        },
      ),
    );
  }
}
