import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:project/controllers/auth_controller.dart';
import 'package:project/utils/toast.dart';

class FontController extends GetxController {
  var size = 72.0.obs;

  Obx get slider => Obx(
        () => Column(
          children: [
            Text(size.value.toString()),
            Slider(
              value: size.value,
              onChanged: _updateSize,
              min: 36,
              max: 128,
            ),
          ],
        ),
      );

  void _updateSize(double size) {
    this.size.value = size;
  }
}

class Debug {
  final AuthController authController = Get.find<AuthController>();
  get toastTestsWidget => Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextButton(
              onPressed: () {
                Toast.info(
                  "Info",
                  "Info message",
                );
              },
              child: Text("SnackBar Info"),
            ),
            TextButton(
              onPressed: () {
                Toast.error(
                  "Error",
                  "Error message",
                );
              },
              child: Text("SnackBar Error"),
            ),
            IconButton(
              icon: const Icon(Icons.logout),
              onPressed: authController.signOut,
            ),
          ],
        ),
      );
}
