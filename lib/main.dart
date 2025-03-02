import 'package:flutter/material.dart';
import 'package:project/pages/home_page.dart';
import 'package:project/pages/login_page.dart';
import 'package:project/theme.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

void main() async {
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
      home: AppRoot(),
    );
  }
}

class AppRoot extends StatefulWidget {
  const AppRoot({super.key});

  @override
  State<AppRoot> createState() => _AppRootState();
}

class _AppRootState extends State<AppRoot> {
  Widget _currentScreen = const LoginPage();
  @override
  void initState() {
    super.initState();
    Supabase.instance.client.auth.onAuthStateChange.listen((authState) {
      final event = authState.event;
      final session = authState.session;
      setState(() {
        if (event == AuthChangeEvent.signedIn) {
          if (session != null) {
            _currentScreen = const HomePage();
          } else {
            Supabase.instance.client.auth.signOut();
          }
        } else if (event == AuthChangeEvent.signedOut) {
          _currentScreen = const LoginPage();
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return _currentScreen;
  }
}
