import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ItemContainer extends StatelessWidget {
  final Widget child;
  final double marginX;
  final double marginY;
  const ItemContainer(
      {super.key, required this.child, this.marginX = 0, this.marginY = 8});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: marginY, horizontal: marginX),
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Get.theme.colorScheme.primaryContainer,
        borderRadius: BorderRadius.circular(8),
      ),
      child: child,
    );
  }
}
