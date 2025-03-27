import 'package:flutter/material.dart';
import 'package:get/get.dart';

extension SnackBarTemplate on GetSnackBar {
  /// Displays a basic snackbar
  static GetSnackBar info(
    String title,
    String message, {
    String? actionLabel,
  }) {
    return GetSnackBar(
      title: title,
      message: message,
      backgroundColor: Get.theme.colorScheme.primaryContainer,
      snackStyle: SnackStyle.FLOATING,
      snackPosition: SnackPosition.TOP,
      duration: Duration(seconds: 3),
      maxWidth: Get.size.width * 0.8,
      borderRadius: 8,
      dismissDirection: DismissDirection.horizontal,
    );
  }

  /// Displays a red snackbar indicating error
  static GetSnackBar error(
    String title,
    String message, {
    String? actionLabel,
  }) {
    return GetSnackBar(
      title: title,
      message: message,
      backgroundColor: Get.theme.colorScheme.errorContainer,
      snackStyle: SnackStyle.FLOATING,
      snackPosition: SnackPosition.TOP,
      duration: Duration(seconds: 3),
      maxWidth: Get.size.width * 0.8,
      borderRadius: 8,
      dismissDirection: DismissDirection.horizontal,
    );
  }
}
