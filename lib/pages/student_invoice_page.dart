import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:project/controllers/auth_controller.dart';
import 'package:project/controllers/student_invoice_controller.dart';
import 'package:skeletonizer/skeletonizer.dart';

class StudentInvoicePage extends StatelessWidget {
  final authController = Get.find<AuthController>();
  final stateController = Get.put(StudentInvoiceController());
  StudentInvoicePage({super.key}) {
    stateController.getInvoices(authController.roleId);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          "Invoices",
          style: Get.textTheme.headlineSmall!.copyWith(
            color: Get.theme.colorScheme.primary,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(12),
        child: Obx(() => Skeletonizer(
              enabled: stateController.isLoading,
              child: ListView.builder(
                  itemCount: stateController.invoices.length,
                  itemBuilder: (context, index) {
                    final invoice = stateController.invoices[index];
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
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                invoice["description"],
                                style: Get.textTheme.bodyLarge!.copyWith(
                                  color: Get.theme.colorScheme.primary,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Text(invoice["term"]),
                            ],
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Text(
                                "${invoice["amount"].toStringAsFixed(1)} Rupees",
                                style: Get.textTheme.bodyLarge!.copyWith(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Text.rich(TextSpan(
                                text:
                                    "${invoice["paidDate"] == null ? 'Due' : 'Paid'} on ",
                                children: [
                                  TextSpan(
                                      text: () {
                                        final datetime = DateTime.parse(
                                            invoice["paidDate"] ??
                                                invoice["dueDate"]);

                                        int month = datetime.month;
                                        int day = datetime.day;
                                        int year = datetime.year;
                                        return "${[
                                          "Jan",
                                          "Feb",
                                          "Mar",
                                          "Apr",
                                          "May",
                                          "Jun",
                                          "Jul",
                                          "Aug",
                                          "Sep",
                                          "Oct",
                                          "Nov",
                                          "Dec"
                                        ][month - 1]} ${day.toString().padLeft(2, '0')}, $year";
                                      }(),
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                      )),
                                ],
                              )),
                            ],
                          ),
                        ],
                      ),
                    );
                  }),
            )),
      ),
    );
  }
}
