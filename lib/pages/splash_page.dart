import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:project/utils/auth_checker.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  @override
  void initState() {
    super.initState();
    Future.delayed(
      const Duration(seconds: 3),
      () {
        Get.to(AuthChecker());
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Image.asset("assets/logo.png"),
    );
  }
}
