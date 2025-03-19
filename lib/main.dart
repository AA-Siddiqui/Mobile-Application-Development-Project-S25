import 'package:flutter/material.dart';
import 'package:project/pages/home_page.dart';
import 'package:project/pages/login_page.dart';
import 'package:project/theme.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  const supabaseUrl = String.fromEnvironment("SUPABASE_URL");
  const supabaseAnonKey = String.fromEnvironment("SUPABASE_ANON_KEY");

  await Supabase.initialize(
    url: supabaseUrl,
    anonKey: supabaseAnonKey,
  );
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: AppTheme.light,
      darkTheme: AppTheme.dark,
      home: StreamBuilder<AuthState>(
        stream: Supabase.instance.client.auth.onAuthStateChange,
        builder: (BuildContext context, AsyncSnapshot<AuthState> snapshot) {
          // final authState = snapshot.data;
          // if (authState == null) {
          //   return const LoginPage();
          // }

          // final event = authState.event;
          // final session = authState.session;
          // if (event == AuthChangeEvent.signedIn) {
          //   if (session != null) {
          //     return const HomePage();
          //   } else {
          //     Supabase.instance.client.auth.signOut();
          //   }
          // } else if (event == AuthChangeEvent.signedOut) {
          //   return const LoginPage();
          // }
          // return const LoginPage();
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Scaffold(
              body: Center(child: CircularProgressIndicator()),
            );
          }

          // Ensure snapshot has data
          if (!snapshot.hasData || snapshot.data == null) {
            return const LoginPage();
          }

          final session = Supabase.instance.client.auth.currentSession;

          // If a session exists, go to HomePage, otherwise go to LoginPage
          if (session != null) {
            return const HomePage();
          } else {
            return const LoginPage();
          }
        },
      ),
    );
  }
}
