import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:project/controllers/auth_controller.dart';
import 'package:project/controllers/student_results_controller.dart';
import 'package:project/widgets/item_container.dart';
import 'package:skeletonizer/skeletonizer.dart';

class StudentResultsPage extends StatelessWidget {
  final authController = Get.find<AuthController>();
  final stateController = Get.put(StudentResultsController());
  StudentResultsPage({super.key}) {
    stateController.getResults(authController.roleId);
  }

  @override
  Widget build(BuildContext context) {
    /// TODO: Style the texts better
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          "Results",
          style: Get.textTheme.headlineSmall!.copyWith(
            color: Get.theme.colorScheme.primary,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: Column(
        children: [
          ItemContainer(
            marginX: 8,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text("CGPA"),
                Obx(() => Text(stateController.cgpa.toStringAsFixed(2))),
              ],
            ),
          ),
          Text(
            "Courses",
            style: Get.textTheme.headlineSmall!.copyWith(
              color: Get.theme.colorScheme.primary,
              fontWeight: FontWeight.bold,
            ),
          ),
          Expanded(
            child: Obx(() => Skeletonizer(
                  enabled: stateController.isLoading,
                  child: ListView.builder(
                    itemCount: stateController.results.length,
                    itemBuilder: (context, index) {
                      final result = stateController.results[index];
                      return ItemContainer(
                        marginX: 8,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(result["title"].toString()),
                            Text(result["grade"].toString()),
                          ],
                        ),
                      );
                    },
                  ),
                )),
          ),
        ],
      ),
    );
  }
}
