import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SplashPage extends StatelessWidget {
  const SplashPage({super.key});
  final double val = 0.5;

  @override
  Widget build(BuildContext context) => Scaffold(
        backgroundColor: Color.fromRGBO(29, 95, 145, 1),
        body: Center(
          child: SizedBox(
            width: Get.mediaQuery.size.width * val,
            height: Get.mediaQuery.size.width * val,
            child: Image.asset(
              "assets/logo.png",
              fit: BoxFit.fitWidth,
              width: Get.mediaQuery.size.width * val,
              height: Get.mediaQuery.size.width * val,
            ),
          ),
        ),
      );
}
