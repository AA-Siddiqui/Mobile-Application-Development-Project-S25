import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:project/controllers/profile_controller.dart';
import 'package:skeletonizer/skeletonizer.dart';

class ProfilePage extends StatelessWidget {
  ProfilePage({super.key});
  final controller = Get.put(ProfileController());

  Widget _buildTile(String title, String? value) {
    return Container(
      padding: EdgeInsets.all(12),
      margin: EdgeInsets.symmetric(vertical: 4),
      decoration: BoxDecoration(
        color: Get.theme.colorScheme.primaryContainer,
        borderRadius: BorderRadius.circular(4),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 18,
              color: Get.theme.colorScheme.onPrimaryContainer,
            ),
          ),
          Text(
            value ?? title,
            style: TextStyle(
              fontSize: 16,
              color: Get.theme.colorScheme.onPrimaryContainer,
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Obx(
        () => Skeletonizer(
          enabled: controller.isLoading,
          child: SafeArea(
            child: Stack(
              children: [
                Positioned(
                  child: BackButton(),
                ),
                SizedBox(
                  width: Get.size.width,
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Column(
                          children: [
                            // CircleAvatar(
                            //   radius: 64,
                            // ),
                            Text(
                              controller.name ?? "Name",
                              style: TextStyle(
                                fontSize: 32,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              "Department of ${controller.department ?? "Department"}",
                              style: TextStyle(
                                fontSize: 18,
                              ),
                            ),
                          ],
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Details",
                              style: TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            _buildTile("Program", controller.program),
                            _buildTile("Roll No", controller.rollNo),
                            _buildTile("Email", controller.email),
                            _buildTile("Address", controller.address),
                            _buildTile("Date of Birth", controller.dob),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
