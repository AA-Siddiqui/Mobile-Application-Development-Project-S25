import 'package:flutter/material.dart';
import 'package:project/pages/home_page.dart';
import 'package:project/widgets/login_widget.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({
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
              Builder(builder: (context) {
                return SupaEmailAuth(
                  // redirectTo: kIsWeb ? null : 'io.mydomain.myapp://callback',
                  onSignInComplete: (response) {
                    if (response.session != null) {
                      Navigator.of(context).pushReplacement(
                        MaterialPageRoute(
                          builder: (context) => HomePage(),
                        ),
                      );
                    }
                  },
                );
              }),
            ],
          ),
        ),
      ),
    );
  }
}
