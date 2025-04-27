import 'package:flutter/material.dart';
import 'package:get/get.dart';

class StudentCourseController extends GetxController {
  final _pageIndexRx = 0.obs;
  int get pageIndex => _pageIndexRx.value;
  set pageIndex(int value) => _pageIndexRx.value = value;

  final pageController = PageController();

  void changePage(int pageNo) {
    pageController.animateToPage(
      pageNo,
      duration: Durations.medium1,
      curve: Curves.easeInOut,
    );
    pageIndex = pageNo;
  }
}
