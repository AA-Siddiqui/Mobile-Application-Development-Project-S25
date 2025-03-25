import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:project/controllers/auth_controller.dart';

class LoginPage extends StatelessWidget {
  final AuthController authController = Get.find<AuthController>();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  LoginPage({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Container(
          padding: EdgeInsets.all(16),
          width: MediaQuery.sizeOf(context).width * 0.8,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 36),
                child: Text(
                  "UMS",
                  style: TextStyle(
                    fontSize: 36,
                    color: Theme.of(context).primaryColor,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              // Builder(builder: (context) {
              //   return SupaEmailAuth(
              //     // redirectTo: kIsWeb ? null : 'io.mydomain.myapp://callback',
              //     onSignInComplete: (response) {
              //       if (response.session != null) {
              //         Navigator.of(context).pushReplacement(
              //           MaterialPageRoute(
              //             builder: (context) => HomePage(),
              //           ),
              //         );
              //       }
              //     },
              //   );
              // }),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  TextField(
                      controller: emailController,
                      decoration: const InputDecoration(labelText: "Email")),
                  TextField(
                      controller: passwordController,
                      obscureText: true,
                      decoration: const InputDecoration(labelText: "Password")),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () => authController.signIn(
                        emailController.text, passwordController.text),
                    child: const Text("Login"),
                  ),
                  TextButton(
                    onPressed: () => authController.signUp(
                        emailController.text, passwordController.text),
                    child: const Text("Sign Up"),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
