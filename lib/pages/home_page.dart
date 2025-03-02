import 'package:flutter/material.dart';
import 'package:project/pages/profile_page.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      drawer: Drawer(
        child: ListView(
          children: [
            ListTile(
              title: Text("Profile"),
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ProfilePage(),
                ),
              ),
            )
          ],
        ),
      ),
      body: Center(
        child: TextButton(
          onPressed: () async {
            await Supabase.instance.client.auth.signOut();
          },
          child: Text("LOL"),
        ),
      ),
    );
  }
}
