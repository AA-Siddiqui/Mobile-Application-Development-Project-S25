import 'package:flutter/material.dart';
import 'package:get/get.dart';

SnackbarController showInfoToast(
  String title,
  String message, {
  String? actionLabel,
}) {
  return Get.showSnackbar(
    GetSnackBar(
      title: title,
      message: message,
      backgroundColor: Get.theme.colorScheme.primaryContainer,
      snackStyle: SnackStyle.FLOATING,
      snackPosition: SnackPosition.TOP,
      duration: Duration(seconds: 3),
      maxWidth: Get.size.width * 0.8,
      borderRadius: 8,
      dismissDirection: DismissDirection.horizontal,
    ),
  );
}

SnackbarController showErrorToast(
  String title,
  String message, {
  String? actionLabel,
}) {
  return Get.showSnackbar(
    GetSnackBar(
      title: title,
      message: message,
      backgroundColor: Get.theme.colorScheme.errorContainer,
      snackStyle: SnackStyle.FLOATING,
      snackPosition: SnackPosition.TOP,
      duration: Duration(seconds: 3),
      maxWidth: Get.size.width * 0.8,
      borderRadius: 8,
      dismissDirection: DismissDirection.horizontal,
    ),
  );
}
