import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:project/controllers/auth_controller.dart';
import 'package:project/controllers/student_results_controller.dart';
import 'package:project/widgets/item_container.dart';
import 'package:skeletonizer/skeletonizer.dart';

class StudentResultsPage extends StatelessWidget {
  final authController = Get.find<AuthController>();
  late final stateController =
      Get.put(StudentResultsController(authController.roleId));
  StudentResultsPage({super.key});

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
                Text(
                  "CGPA",
                  style: Get.textTheme.bodyLarge!.copyWith(
                    color: Get.theme.colorScheme.primary,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Obx(
                  () => Text(
                    stateController.cgpa.toStringAsFixed(2),
                    style: Get.theme.textTheme.headlineSmall!.copyWith(
                      color: Get.theme.colorScheme.onPrimaryContainer,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
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
                            Text(
                              result["title"].toString(),
                              style: Get.textTheme.bodyLarge!.copyWith(
                                color: Get.theme.colorScheme.primary,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Container(
                              width: 30,
                              height: 30,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(100),
                                color: Get.theme.colorScheme.tertiaryContainer,
                              ),
                              child: Center(
                                child: Text(
                                  result["grade"].toString(),
                                  style: Get.textTheme.bodyLarge!.copyWith(
                                    fontWeight: FontWeight.bold,
                                    color: {
                                          "A+": Get.theme.colorScheme.primary,
                                          "F": Get.theme.colorScheme.error
                                        }[result["grade"]] ??
                                        Get.theme.colorScheme
                                            .onSecondaryContainer,
                                  ),
                                ),
                              ),
                            ),
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
