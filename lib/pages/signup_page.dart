import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:project/controllers/auth_controller.dart';
import 'package:project/controllers/department_dialog_controller.dart';

class SignupPage extends StatelessWidget {
  final AuthController authController = Get.find<AuthController>();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController addressController = TextEditingController();
  final TextEditingController dobController = TextEditingController();
  final TextEditingController departmentController = TextEditingController();
  final TextEditingController programController = TextEditingController();
  final departmentStateController = Get.put(DepartmentDialogController());

  SignupPage({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Container(
          padding: EdgeInsets.all(16),
          width: MediaQuery.sizeOf(context).width * 0.8,
          child: SingleChildScrollView(
            child: Column(
              spacing: 20,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 16),
                  child: Image.asset("assets/logo-transparent.png"),
                  // child: Text(
                  //   "UMS",
                  //   style: TextStyle(
                  //     fontSize: 36,
                  //     color: Theme.of(context).primaryColor,
                  //     fontWeight: FontWeight.bold,
                  //   ),
                  // ),
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  spacing: 30,
                  children: [
                    Column(
                      spacing: 10,
                      children: [
                        TextField(
                          controller: nameController,
                          decoration: const InputDecoration(labelText: "Name"),
                        ),
                        TextField(
                          controller: emailController,
                          decoration: const InputDecoration(labelText: "Email"),
                        ),
                        TextField(
                          controller: passwordController,
                          obscureText: true,
                          decoration:
                              const InputDecoration(labelText: "Password"),
                        ),
                        TextField(
                          controller: addressController,
                          decoration:
                              const InputDecoration(labelText: "Address"),
                        ),
                        TextField(
                          onTap: () {
                            showDatePicker(
                              context: context,
                              firstDate: DateTime(1970),
                              lastDate: DateTime.now(),
                            ).then((date) {
                              if (date == null) return;
                              dobController.text =
                                  date.toString().split(" ")[0];
                            });
                          },
                          readOnly: true,
                          controller: dobController,
                          decoration: const InputDecoration(
                            labelText: "Date Of Birth",
                          ),
                        ),
                        TextField(
                          onTap: () {
                            Get.dialog(
                              AlertDialog(
                                title: Text('Select Your Department'),
                                content: SizedBox(
                                  width: double.maxFinite,
                                  child: ListView.builder(
                                    shrinkWrap: true,
                                    itemCount: departmentStateController
                                        .departments.length,
                                    itemBuilder: (context, index) {
                                      final department =
                                          departmentStateController
                                              .departments[index];
                                      return ListTile(
                                        title: Text(department),
                                        onTap: () {
                                          departmentStateController
                                              .selectDepartment(department);
                                          departmentController.text =
                                              departmentStateController
                                                  .selectedDepartment.value;
                                        },
                                      );
                                    },
                                  ),
                                ),
                              ),
                            );
                          },
                          readOnly: true,
                          controller: departmentController,
                          decoration: const InputDecoration(
                            labelText: "Department",
                          ),
                        ),
                        Obx(
                          () => departmentStateController
                                  .selectedDepartment.isNotEmpty
                              ? TextField(
                                  onTap: () {
                                    Get.dialog(
                                      AlertDialog(
                                        title: Text('Select Your Program'),
                                        content: SizedBox(
                                          width: double.maxFinite,
                                          child: ListView.builder(
                                            shrinkWrap: true,
                                            itemCount: departmentStateController
                                                .program.length,
                                            itemBuilder: (context, index) {
                                              final program =
                                                  departmentStateController
                                                      .program[index];
                                              return ListTile(
                                                title: Text(program),
                                                onTap: () {
                                                  departmentStateController
                                                      .selectProgram(program);
                                                  programController.text =
                                                      departmentStateController
                                                          .selectedProgram
                                                          .value;
                                                },
                                              );
                                            },
                                          ),
                                        ),
                                      ),
                                    );
                                  },
                                  readOnly: true,
                                  controller: programController,
                                  decoration: const InputDecoration(
                                    labelText: "Program",
                                  ),
                                )
                              : TextField(
                                  enabled: false,
                                  controller: programController,
                                  decoration: const InputDecoration(
                                    labelText: "Program",
                                    hintText: "Select a department first",
                                  ),
                                ),
                        ),
                      ],
                    ),
                    Column(
                      spacing: 4,
                      children: [
                        Obx(
                          () => authController.isLoading
                              ? CircularProgressIndicator()
                              : ElevatedButton(
                                  onPressed: () => authController.signUp(
                                      emailController.text,
                                      passwordController.text,
                                      addressController.text,
                                      DateTime.parse(dobController.text),
                                      departmentController.text,
                                      programController.text,
                                      nameController.text),
                                  child: const Text("Sign Up"),
                                ),
                        ),
                        ElevatedButton(
                          onPressed: () => authController.isRegistering = true,
                          child: const Text("Already have an account? Login"),
                        ),
                      ],
                    ),
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
